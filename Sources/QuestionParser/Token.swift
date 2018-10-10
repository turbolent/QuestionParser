
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
