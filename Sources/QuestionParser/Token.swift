
public struct Token: Hashable {
    public let word: String
    public let tag: String
    public let lemma: String

    private static let auxiliaryVerbLemmas: Set<String> =
        ["have", "be", "do"]

    public var isAuxiliaryVerb: Bool {
        return Token.auxiliaryVerbLemmas.contains(lemma)
    }
}
