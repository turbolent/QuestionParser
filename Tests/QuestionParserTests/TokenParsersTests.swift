import XCTest
import SwiftParserCombinators
@testable import QuestionParser

final class TokenParsersTests: XCTestCase {

    func testCommaOrAndList() {

        let p = TokenParsers.commaOrAndList(
            parser: elem(kind: "number", predicate: { Int($0.word) != nil })
                .map { .number([$0]) },
            andReducer: {
                .and($0.flatMap { (value: Value) -> [Value] in
                    if case let .and(values) = value {
                        return values
                    } else {
                        return [value]
                    }
                })
            },
            orReducer: {
                .or($0.flatMap { (value: Value) -> [Value] in
                    if case let .or(values) = value {
                        return values
                    } else {
                        return [value]
                    }
                })
            },
            andOptional: false
        )

        expectSuccess(
            parser: p,
            input: [t("1", "", "")],
            expected: .number([t("1", "", "")])
        )

        expectSuccess(
            parser: p,
            input: [
                t("1", "", ""),
                t("and", "", ""),
                t("2", "", ""),
            ],
            expected: .and([
                .number([t("1", "", "")]),
                .number([t("2", "", "")])
            ])
        )

        expectSuccess(
            parser: p,
            input: [
                t("1", "", ""),
                t("or", "", ""),
                t("2", "", ""),
            ],
            expected: .or([
                .number([t("1", "", "")]),
                .number([t("2", "", "")])
            ])
        )

        expectSuccess(
            parser: p,
            input: [
                t("1", "", ""),
                t(",", "", ""),
                t("2", "", ""),
                t(",", "", ""),
                t("and", "", ""),
                t("3", "", ""),
            ],
            expected: .and([
                .number([t("1", "", "")]),
                .number([t("2", "", "")]),
                .number([t("3", "", "")])

            ])
        )

        expectSuccess(
            parser: p,
            input: [
                t("1", "", ""),
                t(",", "", ""),
                t("2", "", ""),
                t(",", "", ""),
                t("or", "", ""),
                t("3", "", ""),
            ],
            expected: .or([
                .number([t("1", "", "")]),
                .number([t("2", "", "")]),
                .number([t("3", "", "")])
            ])
        )

        expectSuccess(
            parser: p,
            input: [
                t("1", "", ""),
                t(",", "", ""),
                t("2", "", ""),
                t("and", "", ""),
                t("3", "", ""),
            ],
            expected: .and([
                .number([t("1", "", "")]),
                .number([t("2", "", "")]),
                .number([t("3", "", "")])
            ])
        )
    }

}
