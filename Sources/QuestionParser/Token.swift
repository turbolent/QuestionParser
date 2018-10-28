
public struct Token: Hashable {

    public let word: String
    public let tag: String
    public let lemma: String

    public init(word: String, tag: String, lemma: String) {
        self.word = word
        self.tag = tag
        self.lemma = lemma
    }

    private static let auxiliaryVerbLemmas: Set<String> =
        ["have", "be", "do"]

    public var isAuxiliaryVerb: Bool {
        return Token.auxiliaryVerbLemmas.contains(lemma)
    }
}

extension Token: Encodable {

    private enum CodingKeys: CodingKey {
        case type
        case word
        case tag
        case lemma
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("token", forKey: .type)
        try container.encode(word, forKey: .word)
        try container.encode(tag, forKey: .tag)
        try container.encode(lemma, forKey: .lemma)
    }
}
