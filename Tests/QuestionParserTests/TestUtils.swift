
import XCTest
import ParserCombinators
import DiffedAssertEqual
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
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
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
        diffedAssertEqual(
            value,
            expected,
            file: file,
            line: line
        )
    case .failure, .error:
        XCTFail(
            String(describing: result),
            file: file,
            line: line
        )
    }
}

func expectSuccess<T>(
    parser: Parser<T, Token>,
    input: [Token],
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
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
        XCTFail(
            String(describing: result),
            file: file,
            line: line
        )
    }
}

func expectSuccess<T>(
    parser: Parser<T?, Token>,
    input: [Token],
    expected: T?,
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
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
        diffedAssertEqual(
            value,
            expected,
            file: file,
            line: line
        )
    case .failure, .error:
        XCTFail(
            String(describing: result),
            file: file,
            line: line
        )
    }
}

func expectSuccess<T>(
    parser: Parser<[T], Token>,
    input: [Token],
    expected: [T],
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
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
        diffedAssertEqual(
            value,
            expected,
            file: file,
            line: line
        )
    case .failure, .error:
        XCTFail(
            String(describing: result),
            file: file,
            line: line
        )
    }
}

func expectFailure<T>(
    parser: Parser<T, Token>,
    input: [Token],
    message: String? = nil,
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success:
        XCTFail(
            "\(result) is successful",
            file: file,
            line: line
        )
    case .failure(let actualMessage, _):
        if let message = message {
            diffedAssertEqual(
                actualMessage,
                message,
                "Failure, but wrong message",
                file: file,
                line: line
            )
        }
    case .error:
        XCTFail(
            "\(result) is error",
            file: file,
            line: line
        )
    }
}

func expectError<T>(
    parser: Parser<T, Token>,
    input: [Token],
    message: String? = nil,
    usePackratReader: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader
    )
    switch result {
    case .success:
        XCTFail(
            "\(result) is successful",
            file: file,
            line: line
        )
    case .failure:
        XCTFail(
            "\(result) is failure",
            file: file,
            line: line
        )
    case .error(let actualMessage, _):
        if let message = message {
            diffedAssertEqual(
                actualMessage,
                message,
                "Error, but wrong message",
                file: file,
                line: line
            )
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
    _ tokens: Token...,
    file: StaticString = #file,
    line: UInt = #line
) {
    QuestionParserTests.expectSuccess(
        parser,
        expected,
        tokens,
        file: file,
        line: line
    )
}

func expectSuccess<T: Equatable>(
    _ parser: Parser<T, Token>,
    _ expected: T,
    _ tokens: [Token],
    file: StaticString = #file,
    line: UInt = #line
) {
    QuestionParserTests.expectSuccess(
        parser: parser,
        input: tokens,
        expected: expected,
        file: file,
        line: line
    )
}

func expectQuestionSuccess(
    _ expectedQuestion: ListQuestion,
    _ tokens: Token...,
    file: StaticString = #file,
    line: UInt = #line
) {
    expectSuccess(
        QuestionParsers.question <~ endOfInput(),
        expectedQuestion,
        QuestionParsers.rewrite(tokens: tokens),
        file: file,
        line: line
    )
}

@available(OSX 10.13, *)
func diffJSON<T>(
    _ expected: String,
    _ actual: T,
    file: StaticString = #file,
    line: UInt = #line
)
    where T: Encodable
{
    do {
        let actualEncodedData = try JSONEncoder().encode(actual)
        guard let expectedEncodedData = expected.data(using: .utf8) else {
            XCTFail("failed to UTF8-decode expected string")
            return
        }

        let expectedDecoded = try JSONSerialization.jsonObject(with: expectedEncodedData, options: [])
        let actualDecoded = try JSONSerialization.jsonObject(with: actualEncodedData, options: [])

        let expectedDecodedData = try JSONSerialization.data(
            withJSONObject: expectedDecoded,
            options: .sortedKeys
        )
        let actualDecodedData = try JSONSerialization.data(
            withJSONObject: actualDecoded,
            options: .sortedKeys
        )

        XCTAssertEqual(expectedDecodedData, actualDecodedData)

    } catch let error {
        XCTFail(error.localizedDescription,
                file: file,
                line: line)
    }
}
