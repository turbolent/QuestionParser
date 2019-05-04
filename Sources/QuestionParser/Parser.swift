
import ParserCombinators

public extension Parser {
    func ignored() -> Parser<Unit, Element> {
        return map(Unit.empty)
    }

    func toArray() -> Parser<[T], Element> {
         return map { [$0] }
    }

    func toArray<U>() -> Parser<[U], Element>
        where T == Optional<U>
    {
        return map { $0.map { [$0] } ?? [] }
    }
}
