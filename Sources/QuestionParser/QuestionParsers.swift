import ParserCombinators
import ParserCombinatorOperators


public struct QuestionParsers {

    private typealias TP = TokenParsers
    private typealias POS = POSParsers

    public static let relationshipWord =
        TP.someWord("of", "by", tag: "IN")

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
    //   - "give me"

    public static let findListGiveShow: Parser<Unit, Token> =
        TP.someWord("find", "list", "give", "show").ignored()
            ~ TP.word("me").opt().ignored()

    // Examples:
    //   - "all"
    //   - "some of"
    //   - "a couple"

    public static let someAllAny: Parser<Unit, Token> =
        TP.someWord("some", "all", "any", "only", "many", "both").ignored()

    public static let aFewCouple: Parser<Unit, Token> =
        TP.word("a").ignored()
            ~ TP.someWord("few", "couple", "number", "lot").ignored()

    public static let aListOf: Parser<Unit, Token> =
        TP.words("a", "list", "of").ignored()
            ~ someAllAny.opt().ignored()

    public static let count: Parser<Unit, Token> =
        ((someAllAny || aFewCouple) ~ TP.word("of").opt().ignored())
            || aListOf

    // Examples:
    //   - "Europe"
    //   - "the US"
    //   - "the 19th century"
    //   - "green paintings"
    //   - "people"
    //   - "a Canadian"

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

    public static let hyphenSeparator: Parser<([Token], [Token]) -> [Token], Token> =
        POS.hyphen ^^ { hyphen in
            { (a, b) in
                a + [hyphen] + b
            }
        }

    public static let hyphenedNouns: Parser<[Token], Token> =
        POS.nouns.chainLeft(separator: hyphenSeparator, min: 1).map { $0! }

    public static let nounsNamed: Parser<[Token], Token> =
        (POS.determiner.opt() ^^ { $0.map { [$0] } ?? [] })
            ~ (POS.anyAdverb.opt() ^^ { $0.map { [$0] } ?? [] })
            ~ adjectives
            ~ hyphenedNouns

    public static let adjectiveNamed: Parser<[Token], Token> =
        POS.determiner ~ adjectives

    public static let named: Parser<[Token], Token> =
        nounsNamed
        || adjectiveNamed

    public static let simpleNamedValue: Parser<Value, Token> =
        named ^^ Value.named

    // Examples:
    //   - "Obama's children"
    //   - "Obama's children's mothers"

    // NOTE: handles possessives, which have higher precedence than relationship words,
    // see namedValue

    public static let namedValue: Parser<Value, Token> = {
        let separator = POS.possessive ^^ { token in
            { (a: Value, b: Value) in
                // NOTE: order
                Value.relationship(b, a, token: token)
            }
        }
        return simpleNamedValue.chainLeft(separator: separator, min: 1).map { $0! }
    }()

    // Examples:
    //   - "100"
    //   - "thousand"
    //   - "1 million"
    //   - "42 meters"
    //   - "two million inhabitants"

    public static let numericValue: Parser<Value, Token> =
        (POS.numbers ~ named.opt()) ^^ {
            (numbers, optUnit) in
            return optUnit
                .map { .numberWithUnit(numbers, unit: $0) }
                ?? .number(numbers)
        }

    // Examples:
    //   - "the soundtrack for Cameron's Titanic"

    // NOTE: handles relationship words, which have lower precedence than possesives,
    // see namedValue

    public static let namedValues: Parser<Value, Token> = {
        let separator = relationshipWord ^^ { token in
            { (a: Value, b: Value) in
                // NOTE: order
                Value.relationship(a, b, token: token)
            }
        }

        return namedValue.chainRight(separator: separator, min: 1).map { $0! }
    }()

    // Examples:
    //   - "\"The Red Victorian\""

    public static let quoted: Parser<[Token], Token> = {
        let opening = TP.tag("``")
        let closing = TP.tag("''")
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

    public static let filter: Parser<Filter, Token> =
        ((POS.comparativeAdjective.opt() ~ POS.preposition).opt() ~ values) ^^ {
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
    //   - "died Orwell in"
    // NOTE: first two examples are "direct", second two are "inverse":
    //       "did Orwell write" ~= "were written by" Orwell => "did write Orwell"

    public static let inversePropertyAdjectiveSuffix: Parser<([Token], Filter) -> Property, Token> =
        (POS.strictAdjective ~ POS.preposition) ^^ { adjective, preposition in
            return { verbs, filter in
                .inverseWithFilter(
                    name: verbs + [adjective, preposition],
                    filter: filter
                )
            }
    }

    public static let inversePropertyVerbsSuffix: Parser<([Token], Filter) -> Property, Token> =
        (POS.verbs ~ (POS.particle || (POS.preposition <~ notFollowedBy(namedValue))).opt()) ^^ {
            let (moreVerbs, particle) = $0
            let rest = moreVerbs
                + (particle.map { [$0] } ?? [])
            return { verbs, filter in
                .inverseWithFilter(
                    name: verbs + rest,
                    filter: filter
                )
            }
        }

    public static let inversePropertyPrepositionSuffix: Parser<([Token], Filter) -> Property, Token> =
        (POS.preposition <~ notFollowedBy(namedValue)) ^^ { preposition in
            return { verbs, filter in
                .inverseWithFilter(
                    name: verbs + [preposition],
                    filter: filter
                )
            }
        }

    public static let inversePropertySuffix: Parser<([Token], Filter) -> Property, Token> =
            inversePropertyPrepositionSuffix
            || inversePropertyVerbsSuffix
            || inversePropertyAdjectiveSuffix

    public static let propertyAdjectiveSuffix: Parser<([Token], Filter) -> Property, Token> =
        (POS.strictAdjective <~ notFollowedBy(POS.noun)) ^^ { adjective in
            return { (verbs, filter) in
                .adjectiveWithFilter(
                    name: verbs + [adjective],
                    filter: filter
                )
            }
        }

    public static let complexProperty: Parser<Property, Token> =
        (POS.whDeterminer.opt() ~> POS.verbs.opt()).flatMap {
            if let verbs = $0 {
                // TODO: more after filters only when verb is auxiliary do/does/did

                let moreParser: Parser<(([Token], Filter) -> Property)?, Token> = {
                    if verbs.count == 1, let verb = verbs.first {

                        if verb.isAuxiliaryVerb {
                            return (inversePropertySuffix || propertyAdjectiveSuffix).opt()
                        } else {
                            return (inversePropertyPrepositionSuffix || propertyAdjectiveSuffix).opt()
                        }
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

    public static let withProperty: Parser<Property, Token> =
        (TP.word("with") ~ filters) ^^ {
            let (name, filter) = $0
            return .withFilter(name: [name], filter: filter)
        }

    public static let property: Parser<Property, Token> =
        withProperty
            || complexProperty


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

    private static func reduceQueries(queries: [Query]) -> Query {
        return .and(queries.flatMap { (query: Query) -> [Query] in
            if case let .and(queries) = query {
                return queries
            } else {
                return [query]
            }
        })
    }

    public static let queries: Parser<Query, Token> =
        TP.commaOrAndList(
            parser: query,
            andReducer: reduceQueries,
            orReducer: reduceQueries,
            andOptional: false
    )

    // Examples:
    //   - "Clinton"
    //   - "Clinton's children"
    //   - "California's cities"
    //   - "California's cities' population sizes"
    //   - "Clinton's children and grandchildren"

    public static let queryPossessiveRelationships: Parser<Query, Token> = {
        let separator = POS.possessive ^^ { token in
            { (a: Query, b: Query) in
                Query.relationship(b, a, token: token)
            }
        }
        return queries.chainLeft(separator: separator, min: 1).map { $0! }
    }()

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


    public static let queryOfRelationship: Parser<(Query) -> Query, Token> =
        (relationshipWord ~ fullQuery) ^^ {
            let (token, nested) = $0
            return { (query: Query) in
                .relationship(
                    query,
                    nested,
                    token: token
                )
            }
        }

    public static let fullQuery: Parser<Query, Token> =
        ((queryPossessiveRelationships <~ (POS.whDeterminer || TP.word("who")).opt())
            ~ (queryProperties ||| queryOfRelationship).opt())
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
        (whichWhat ||| ((whoWhatBe ||| findListGiveShow) ~ count.opt())).opt().ignored()

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

    public static let thingQuestion: Parser<ListQuestion, Token> =
        (TP.word("what") ~> properties)
            ^^ ListQuestion.thing

    public static let question: Parser<ListQuestion, Token> =
        thingQuestion ||| personQuestion ||| listQuestion

    public static func rewrite(tokens: [Token]) -> [Token] {
        var tokens = tokens

        // drop sentence terminator
        if tokens.last?.tag == "." {
            tokens.removeLast()
        }

        // move initial preposition to end
        if tokens.first?.tag == "IN" {
            let initialPreposition = tokens.removeFirst()
            tokens.append(Token(
                word: initialPreposition.word.lowercased(),
                tag: initialPreposition.tag,
                lemma: initialPreposition.lemma
            ))
        }

        return tokens
    }
}
