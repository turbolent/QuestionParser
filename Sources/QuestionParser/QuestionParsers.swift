import SwiftParserCombinators

public struct QuestionParsers {

    private typealias TP = TokenParsers
    private typealias POS = POSParsers

    // Examples:
    //   - "in which"
    //   - "what"

    public static let whichWhat: Parser<Unit, Token> =
        POS.preposition.opt().ignored()
            ~ TP.someWord("which", "what").ignored()


    // Examples:
    //   - "what is"
    //   - "what are"
    //   - "who were"

    public static let whoWhatBe: Parser<Unit, Token> =
        TP.someWord("who", "what").ignored()
            ~ TP.lemma("be").ignored()

    // Examples:
    //   - "find"
    //   - "list"
    //   - "show me"

    public static let findListGiveShow: Parser<Unit, Token> =
        TP.someWord("find", "list", "give", "show").ignored()
            ~ TP.word("me").opt().ignored()

    // Examples:
    //   - "all"
    //   - "some of"
    //   - "a couple"

    public static let someAllAny: Parser<Unit, Token> = {
        let someAllAny =
            TP.someWord("some", "all", "any", "only", "many", "both").ignored()
        let aFewCouple =
            TP.word("a").ignored()
                ~ TP.someWord("few", "couple", "number", "lot").ignored()
        return (someAllAny || aFewCouple)
            ~ TP.word("of").opt().ignored()
    }()

    // Examples:
    //   - "Europe"
    //   - "the US"
    //   - "the 19th century"
    //   - "green paintings"
    //   - "people"

    // Note: disambiguate/extract superlative and adjective in later stage,
    //       might either be named entity or specific type

    public static let adjectives: Parser<[Token], Token> =
        (
            POS.superlativeAdjective.opt()
                ~ POS.anyAdjective.rep() as Parser<[Token], Token>
        ) ^^ {
            switch $0 {
            case let (superlative?, adjectives):
                return [superlative] + adjectives
            case let (nil, adjectives):
                return adjectives
            }
    }

    public static let named: Parser<[Token], Token> =
        (POS.determiner.opt() ^^ { $0.map { [$0] } ?? [] })
            ~ (POS.anyAdverb.opt() ^^ { $0.map { [$0] } ?? [] })
            ~ adjectives
            ~ POS.nouns

    public static let namedValue: Parser<Value, Token> =
        named ^^ Value.named

    // Examples:
    //   - "100"
    //   - "thousand"
    //   - "1 million"
    //   - "42 meters"
    //   - "two million inhabitants"

    public static let numericValue: Parser<Value, Token> =
        (POS.numbers ~ POS.nouns.opt()) ^^ {
            (numbers, optUnit) in
            return optUnit
                .map { .number(numbers, unit: $0) }
                ?? .number(numbers)
        }

    // Examples:
    //   - "Obama's children"
    //   - "Obama's children's mothers"

    public static let namedValues: Parser<Value, Token> = {
        let moreNamedValues: Parser<[Value], Token> =
            (POS.possessive ~> namedValue).rep()
        return (namedValue ~~ moreNamedValues) ^^ {
            (first, rest) in

            return rest.reduce(first) { result, namedValue in
                .relationship(namedValue, result)
            }
        }
    }()

    // Examples:
    //   - "\"The Red Victorian\""

    static let quoted: Parser<[Token], Token> = {
        let opening = TP.pos("``", strict: true)
        let closing = TP.pos("''", strict: true)
        let anyExceptClosing: Parser<[Token], Token> =
            elem(kind: "not('')", predicate: { $0.tag != "''" }).rep()
        return (opening ~> anyExceptClosing) <~ closing
    }()

    // Examples:
    //   - "America"
    //   - "dystopian societies"
    //   - "Obama's children"
    //   - "1900"
    //   - "1000 kilometers"
    //   - "two million inhabitants"

    public static let value: Parser<Value, Token> =
        namedValues
            || numericValue
            || (quoted ^^ Value.named)

    public static let values: Parser<Value, Token> =
        TP.commaOrAndList(
            parser: value,
            andReducer: {
                .and($0.flatMap { (value: Value) -> [Value] in
                    if case let .and(values) = value {
                        return values
                    } else {
                        return [value]
                    }
                })
            },
            orReducer: {
                .or($0.flatMap { (value: Value) -> [Value] in
                    if case let .or(values) = value {
                        return values
                    } else {
                        return [value]
                    }
                })
            },
            andOptional: false
        )

    // Examples:
    //   - "before 1900"
    //   - "in Europe"
    //   - "larger than Europe"
    //   - "smaller than Europe and the US"

    public static let prepositionExceptOf =
        POS.preposition.filter { $0.word != "of" }

    public static let filter: Parser<Filter, Token> =
        ((POS.comparativeAdjective.opt() ~ prepositionExceptOf).opt() ~ values) ^^ {
            switch $0 {
            case (nil, let values):
                return .plain(values)
            case let ((nil, preposition)?, values):
                return .withModifier(
                    modifier: [preposition],
                    value: values
                )
            case let ((comparative?, preposition)?, values):
                return .withComparativeModifier(
                    modifier: [comparative, preposition],
                    value: values
                )
            }
        }

    public static let filters: Parser<Filter, Token> =
        TP.commaOrAndList(
            parser: filter,
            andReducer: {
                .and($0.flatMap { (filter: Filter) -> [Filter] in
                    if case let .and(filters) = filter {
                        return filters
                    } else {
                        return [filter]
                    }
                })
            },
            orReducer: {
                .or($0.flatMap { (filter: Filter) -> [Filter] in
                    if case let .or(filters) = filter {
                        return filters
                    } else {
                        return [filter]
                    }
                })
            },
            andOptional: false
        )


    // Examples:
    //   - "died"
    //   - "died before 1900 or after 1910" (NOTE: one property with two filters)
    //   - "by George Orwell"
    //   - "did George Orwell write"
    //   - "did Obama star in"
    // NOTE: first two examples are "direct", second two are "inverse":
    //       "did Orwell write" ~= "were written by" Orwell => "did write Orwell"

    public static let inversePropertySuffix: Parser<([Token], Filter) -> Property, Token> =
        (POS.verbs ~ (POS.particle || (POS.preposition <~ notFollowedBy(namedValue))).opt()) ^^ {
            switch $0 {
            case let (moreVerbs, particle?):
                return { verbs, filter in
                    .inverseWithFilter(
                        name: verbs + moreVerbs + [particle],
                        filter: filter
                    )
                }
            case (let moreVerbs, nil):
                return { verbs, filter in
                    .inverseWithFilter(
                        name: verbs + moreVerbs,
                        filter: filter
                    )
                }
            }
        }

    public static let propertyAdjectiveSuffix: Parser<([Token], Filter) -> Property, Token> =
        POS.strictAdjective ^^ { adjective in
            return { (verbs, filter) in
                .adjectiveWithFilter(
                    name: verbs + [adjective],
                    filter: filter
                )
            }
        }

    public static let property: Parser<Property, Token> =
        (POS.whDeterminer.opt() ~> POS.verbs.opt()).flatMap {
            if let verbs = $0 {
                // TODO: more after filters only when verb is auxiliary do/does/did

                let moreParser: Parser<(([Token], Filter) -> Property)?, Token> = {
                    if verbs.count == 1, let verb = verbs.first, verb.isAuxiliaryVerb {
                        return (inversePropertySuffix || propertyAdjectiveSuffix).opt()
                    } else {
                        return propertyAdjectiveSuffix.opt()
                    }
                }()

                return (filters ~ moreParser).opt() ^^ {
                    switch $0 {
                    case let (filter, suffixConstructor?)?:
                        return suffixConstructor(verbs, filter)
                    case let (filter, nil)?:
                        return .withFilter(name: verbs, filter: filter)
                    case nil:
                        return .named(verbs)
                    }
                }

            } else {
                return filters ^^ {
                    .withFilter(name: [], filter: $0)
                }
            }
        }


    // Examples:
    //   - "died before 1900 or after 1910 or were born in 1923"
    //   - "written by Orwell were longer than 200 pages"
    //     (NOTE: 2 properties, "and" is optional,
    //            valid when starting with "which books")

    public static let properties: Parser<Property, Token> =
        TP.commaOrAndList(
            parser: property,
            andReducer: {
                .and($0.flatMap { (property: Property) -> [Property] in
                    if case let .and(properties) = property {
                        return properties
                    } else {
                        return [property]
                    }
                })
            },
            orReducer: {
                .or($0.flatMap { (property: Property) -> [Property] in
                    if case let .or(properties) = property {
                        return properties
                    } else {
                        return [property]
                    }
                })
            },
            andOptional: true
        )

    // Examples:
    //   - "youngest children"
    //   - "the largest cities"
    //   - "main actor"

    public static let namedQuery: Parser<Query, Token> =
         named ^^ Query.named

    public static let query: Parser<Query, Token> =
        namedQuery
            || (quoted ^^ Query.named)

    // Examples:
    //   - "children and grandchildren"
    //   - "China, the USA, and Japan"
    // TODO: maybe just use commaOrAndList
    // TODO: differentiate "and" and "or"?!
    // TODO: handling nesting of "and" and "or"

    public static let queriesSeparator: Parser<Unit, Token> =
        (TP.comma.ignored() ~ POS.coordinatingConjunction.opt().ignored())
            || (TP.comma.opt().ignored() ~ POS.coordinatingConjunction.ignored())

    public static let queries: Parser<Query, Token> =
        query.rep(separator: queriesSeparator, min: 1) ^^ { (queries: [Query]) in
            if queries.count == 1, let query = queries.first {
                return query
            } else {
                return .and(queries)
            }
        }

    // Examples:
    //   - "Clinton"
    //   - "Clinton's children"
    //   - "California's cities"
    //   - "California's cities' population sizes"
    //   - "Clinton's children and grandchildren"

    public static let queryRelationships: Parser<Query, Token> = {
        let separator = POS.possessive ^^ { sep in
            { (a: Query, b: Query) in
                Query.relationship(b, a, token: sep)
            }
        }
        return queries.chainLeft(separator, min: 1).map { $0! }
    }()

    // Examples:
    //   - "of the USA"
    //   - "of China"

    public static let relationship: Parser<(Token, Query), Token> =
        TP.word("of") ~ fullQuery

    // Examples
    //   - "people"
    //   - "actors that died in Berlin"
    //   - "engineers which"
    //   - "largest cities that"
    //   - "cities of California"
    //   - "California's cities"
    //   - "population of the USA"

    // TODO: execution should "filter" first (use properties),
    //       before applying inner superlative

    public static let queryProperties: Parser<(Query) -> Query, Token> =
        properties ^^ { property in
            { (query: Query) in
                .withProperty(
                    query,
                    property: property
                )
            }
        }

    public static let queryRelationship: Parser<(Query) -> Query, Token> =
        relationship ^^ {
            let (sep, nested) = $0
            return { (query: Query) in
                .relationship(
                    query,
                    nested,
                    token: sep
                )
            }
        }

    public static let fullQuery: Parser<Query, Token> =
        ((queryRelationships <~ (POS.whDeterminer || TP.word("who")).opt())
            ~ (queryProperties ||| queryRelationship).opt())
        ^^ {
            switch $0 {
            case (let query, nil):
                return query
            case let (query, queryConstructor?):
                return queryConstructor(query)
            }
        }

    // Examples:
    //   - "which"
    //   - "what are"
    //   - "find all"
    //   - "give me a few"
    // NOTE: ||| to match as much as possible

    public static let listQuestionStart: Parser<Unit, Token> =
        (whichWhat ||| ((whoWhatBe ||| findListGiveShow) ~ someAllAny.opt())).opt().ignored()

    // Examples:
    //   - "which presidents were born before 1900"
    //   - "give me all actors born in Berlin and San Francisco"

    public static let listQuestion: Parser<ListQuestion, Token> =
        (listQuestionStart ~ fullQuery) ^^ {
            // TODO: handle start
            .other($1)
        }

    // Examples:
    //   - "who died in 1900"
    //   - "who was born in Europe and died in the US"

    public static let personQuestion: Parser<ListQuestion, Token> =
        (TP.word("who") ~> properties)
            ^^ ListQuestion.person

    // Examples:
    //   - "what did George Orwell write"
    //   - "what was authored by George Orwell"

    static let thingQuestion: Parser<ListQuestion, Token> =
        (TP.word("what") ~> properties)
            ^^ ListQuestion.thing

    static let question: Parser<ListQuestion, Token> =
        (listQuestion || personQuestion || thingQuestion)
            <~ POSParsers.sentenceTerminator.opt()
}
