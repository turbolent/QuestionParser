
import XCTest
import ParserCombinators
import ParserCombinatorOperators
import DiffedAssertEqual
import QuestionParser


func t(_ word: String, _ tag: String, _ lemma: String) -> Token {
    return Token(word: word, tag: tag, lemma: lemma)
}

private func parse<T>(
    parser: Parser<T, Token>,
    input: [Token],
    usePackratReader: Bool = false,
    nameParser: Parser<[Token], Token>? = nil
)
    -> ParseResult<T, Token>
{
    var reader: Reader<Token> =
        QuestionReader(
            collection: input,
            nameParser: nameParser ?? failure("not available")
        )
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
    )
    switch result {
    case .success(let actual, _):
        diffedAssertEqual(
            expected,
            actual,
            file: file,
            line: line
        )
        if expected != actual {
            print(actual)
        }
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
    )
    switch result {
    case .success(let actual, _):
        diffedAssertEqual(
            expected,
            actual,
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
)
    where T: Equatable
{
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
    )
    switch result {
    case .success(let actual, _):
        diffedAssertEqual(
            expected,
            actual,
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
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
                message,
                actualMessage,
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    let result = parse(
        parser: parser,
        input: input,
        usePackratReader: usePackratReader,
        nameParser: nameParser
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
                message,
                actualMessage,
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
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    QuestionParserTests.expectSuccess(
        parser,
        expected,
        tokens,
        nameParser: nameParser,
        file: file,
        line: line
    )
}

func expectSuccess<T: Equatable>(
    _ parser: Parser<T, Token>,
    _ expected: T,
    _ tokens: [Token],
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    QuestionParserTests.expectSuccess(
        parser: parser,
        input: tokens,
        expected: expected,
        nameParser: nameParser,
        file: file,
        line: line
    )
}

func expectQuestionSuccess(
    _ expectedQuestion: ListQuestion,
    _ tokens: Token...,
    nameParser: Parser<[Token], Token>? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    expectSuccess(
        QuestionParsers.question <~ endOfInput(),
        expectedQuestion,
        QuestionParsers.rewrite(tokens: tokens),
        nameParser: nameParser,
        file: file,
        line: line
    )
}
