import ParserCombinators


public final class QuestionReader: CollectionReader<[Token]> {

    public typealias C = [Token]

    public let nameParser: Parser<[Token], Token>

    public required init(collection: C, index: C.Index, nameParser: Parser<[Token], Token>) {
        self.nameParser = nameParser
        super.init(collection: collection, index: index)
    }

    public convenience init(collection: C, nameParser: Parser<[Token], Token>) {
        self.init(collection: collection, index: collection.startIndex, nameParser: nameParser)
    }

    required init(collection: C, index: C.Index) {
        fatalError()
    }

    public override func rest() -> Self {
        return type(of: self).init(
            collection: collection,
            index: collection.index(after: index),
            nameParser: nameParser
        )
    }
}
