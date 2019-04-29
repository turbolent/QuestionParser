import ParserCombinators

public struct POSParsers {

    private typealias TP = TokenParsers

    public static let noun =
        TP.anyTag("N")

    public static let nouns: Parser<[Token], Token> =
        noun.rep(min: 1)

    public static let verb =
        TP.anyTag("V")

    public static let verbs: Parser<[Token], Token> =
        verb.rep(min: 1)

    public static let number =
        TP.tag("CD")

    public static let numbers: Parser<[Token], Token> =
        number.rep(min: 1)

    public static let particle =
        TP.tag("RP")

    public static let preposition =
        TP.tag("IN") || TP.tag("TO")

    public static let determiner =
        TP.tag("DT")

    public static let strictAdjective =
        TP.tag("JJ")

    public static let anyAdjective =
        TP.anyTag("JJ")

    public static let comparativeAdjective =
        TP.tag("JJR")

    public static let superlativeAdjective =
        TP.tag("JJS")

    public static let possessive =
        TP.tag("POS")

    public static let coordinatingConjunction =
        TP.tag("CC")

    public static let whDeterminer =
        TP.tag("WDT")

    public static let anyAdverb =
        TP.anyTag("RB")

    public static let hyphen =
        TP.tag("HYPH")
}

