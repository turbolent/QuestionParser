
import SwiftParserCombinators


public struct TokenParsers {

    private typealias Predicate = (Token) -> Bool

    public static func pos(_ tag: String, strict: Bool) -> Parser<Token, Token> {
        let kind =
            ["POS", tag, strict ? "" : "*"]
                .joined(separator: " ")
        let predicate: Predicate = strict
            ? { $0.tag == tag }
            : { $0.tag.hasPrefix(tag) }
        return elem(
            kind: kind,
            predicate: predicate
        )
    }

    public static func word(_ word: String) -> Parser<Token, Token> {
        return elem(kind: "word '\(word)'") {
            $0.word.caseInsensitiveCompare(word) == .orderedSame
        }
    }

    public static func lemma(_ lemma: String) -> Parser<Token, Token> {
        return elem(kind: "lemma '\(lemma)'") {
            $0.lemma.caseInsensitiveCompare(lemma) == .orderedSame
        }
    }

    public static func someWord(_ firstWord: String, _ moreWords: String...) -> Parser<Token, Token> {
        return moreWords.reduce(word(firstWord)) { $0 || word($1) }
    }

    public static func words(_ firstWord: String, _ moreWords: String...) -> Parser<[Token], Token> {
        return moreWords.reduce(word(firstWord).map { [$0] }) { $0 ~ word($1) }
    }

    public static let and = word("and")
    public static let or = word("or")
    public static let comma = word(",")

    public static func commaOrAndList<T>(
        parser: Parser<T, Token>,
        andReducer: @escaping ([T]) -> T,
        orReducer: @escaping ([T]) -> T,
        andOptional: Bool
    )
        -> Parser<T, Token>
    {
        let andVariants = and
                || words("as", "well", "as")

        let andSeparator = andOptional
            ? andVariants.opt().ignored()
            : andVariants.ignored()

        let andParser: Parser<T, Token> =
            parser.rep(separator: andSeparator, min: 1) ^^ { (items: [T]) in
                if items.count == 1, let inner = items.first {
                    return inner
                } else {
                    return andReducer(items)
                }
            }

        let orParser: Parser<T, Token> =
            andParser.rep(separator: or, min: 1) ^^ { (items: [T]) in
                if items.count == 1, let inner = items.first {
                    return inner
                } else {
                    return orReducer(items)
                }
        }

        let combiner =
            (and ^^^ andReducer)
                || (or ^^^ orReducer)

        let values: Parser<[T], Token> = orParser.rep(separator: comma, min: 1)

        return values ~ (comma.opt() ~> (combiner ~ values)).opt() ^^ {
            switch $0 {
            case let (values, (combiner, moreValues)?):
                return combiner(values + moreValues)
            case let (values, nil):
                if values.count == 1, let inner = values.first {
                    return inner
                } else {
                    return andReducer(values)
                }
            }
        }
    }

}
