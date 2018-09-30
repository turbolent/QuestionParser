import SwiftParserCombinators

public struct POSParsers {

    private typealias TP = TokenParsers

    public static let noun =
        TP.pos("N", strict: false)

    public static let nouns: Parser<[Token], Token> =
        noun.rep(min: 1)

    public static let verb =
        TP.pos("V", strict: false)

    public static let verbs: Parser<[Token], Token> =
        verb.rep(min: 1)

    public static let number =
        TP.pos("CD", strict: true)

    public static let numbers: Parser<[Token], Token> =
        number.rep(min: 1)

    public static let particle =
        TP.pos("RP", strict: true)

    public static let preposition =
        TP.pos("IN", strict: true)
            || TP.pos("TO", strict: true)

    public static let determiner =
        TP.pos("DT", strict: true)

    public static let strictAdjective =
        TP.pos("JJ", strict: true)

    public static let anyAdjective =
        TP.pos("JJ", strict: false)

    public static let comparativeAdjective =
        TP.pos("JJR", strict: true)

    public static let superlativeAdjective =
        TP.pos("JJS", strict: true)

    public static let possessive =
        TP.pos("POS", strict: true)

    public static let coordinatingConjunction =
        TP.pos("CC", strict: true)

    public static let whDeterminer =
        TP.pos("WDT", strict: true)

    public static let anyAdverb =
        TP.pos("RB", strict: false)

    public static let hyphen =
        TP.pos("HYPH", strict: true)
}

