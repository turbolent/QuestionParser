
import XCTest
import QuestionParser
import DiffedAssertEqual

class TokenTests: XCTestCase {

    func testEncoding() throws {

        if #available(OSX 10.13, *) {
            diffJSON(
                """
                [
                  {
                    "type": "token",
                    "word": "was",
                    "tag": "VBD",
                    "lemma": "be"
                  }
                ]
                """,
                [Token(word: "was", tag: "VBD", lemma: "be")]
            )
        }
    }
}
