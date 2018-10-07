
import ParserCombinators

public extension Parser {
    func ignored() -> Parser<Unit, Element> {
        return map(Unit.empty)
    }
}
