
import XCTest
import QuestionParser
import DiffedAssertEqual

class TokenTests: XCTestCase {

    func testEncoding() throws {
        let tokens = [Token(word: "was", tag: "VBD", lemma: "be")]
        let data = try JSONEncoder().encode(tokens)
        guard let string = String(data: data, encoding: .utf8) else {
            XCTFail("unable to decode JSON data")
            return
        }

        diffedAssertEqual(
            string,
            "[{\"tag\":\"VBD\",\"word\":\"was\",\"lemma\":\"be\"}]"
        )
    }
}
