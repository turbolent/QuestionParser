
import XCTest
import SwiftParserCombinators
@testable import QuestionParser

func t(_ word: String, _ tag: String, _ lemma: String) -> Token {
    return Token(word: word, tag: tag, lemma: lemma)
}

private func parse<T>(
    parser: Parser<T, Token>,
    input: [Token],
    usePackratReader: Bool = false
)
    -> ParseResult<T, Token>
{
    var reader: Reader<Token> =
        CollectionReader(collection: input)
    if usePackratReader {
        reader = PackratReader(underlying: reader)
    }
    return parser.parse(reader)
}

func expectSuccess<T>(
    parser: Parser<T, Token>,
    input: [Token],
    expected: T,
    usePackratReader: Bool = false
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success(let value, _):
        XCTAssertEqual(value, expected)
    case .failure, .error:
        XCTFail(String(describing: result))
    }
}

func expectSuccess<T>(
    parser: Parser<T, Token>,
    input: [Token],
    usePackratReader: Bool = false
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success:
        break
    case .failure, .error:
        XCTFail(String(describing: result))
    }
}

func expectSuccess<T>(
    parser: Parser<T?, Token>,
    input: [Token],
    expected: T?,
    usePackratReader: Bool = false
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success(let value, _):
        XCTAssertEqual(value, expected)
    case .failure, .error:
        XCTFail(String(describing: result))
    }
}

func expectSuccess<T>(
    parser: Parser<[T], Token>,
    input: [Token],
    expected: [T],
    usePackratReader: Bool = false
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success(let value, _):
        XCTAssertEqual(value, expected)
    case .failure, .error:
        XCTFail(String(describing: result))
    }
}

func expectFailure<T>(
    parser: Parser<T, Token>,
    input: [Token],
    message: String? = nil,
    usePackratReader: Bool = false
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success:
        XCTFail("\(result) is successful")
    case .failure(let actualMessage, _):
        if let message = message {
            XCTAssertEqual(actualMessage, message, "Failure, but wrong message")
        }
    case .error:
        XCTFail("\(result) is error")
    }
}

func expectError<T>(
    parser: Parser<T, Token>,
    input: [Token],
    message: String? = nil,
    usePackratReader: Bool = false
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success:
        XCTFail("\(result) is successful")
    case .failure:
        XCTFail("\(result) is failure")
    case .error(let actualMessage, _):
        if let message = message {
            XCTAssertEqual(actualMessage, message, "Error, but wrong message")
        }
    }
}

extension Parser where T == [Character] {
    var stringParser: Parser<String, Element> {
        return self ^^ { String($0) }
    }
}

func expectSuccess<T: Equatable>(
    _ parser: Parser<T, Token>,
    _ expected: T,
    _ tokens: Token...
) {
    QuestionParserTests.expectSuccess(
        parser,
        expected,
        tokens
    )
}

func expectSuccess<T: Equatable>(
    _ parser: Parser<T, Token>,
    _ expected: T,
    _ tokens: [Token]
) {
    QuestionParserTests.expectSuccess(
        parser: parser,
        input: tokens,
        expected: expected
    )
}

func expectQuestionSuccess(_ expectedQuestion: ListQuestion, _ tokens: Token...) {
    expectSuccess(
        QuestionParsers.question.whole(),
        expectedQuestion,
        QuestionParsers.rewrite(tokens: tokens)
    )
}
