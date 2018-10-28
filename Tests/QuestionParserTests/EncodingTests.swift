
import XCTest
import QuestionParser
import DiffedAssertEqual

class EncodingTests: XCTestCase {

    func testQ1() throws {
        let query: ListQuestion = .other(
            .withProperty(
                .named([t("books", "NN", "book")]),
                property: .and([
                    .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("write", "VB", "write")
                        ],
                        filter: .plain(.named([t("Orwell", "NNP", "orwell")]))
                    ),
                    .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("before", "IN", "before")],
                            value: .named([
                                t("the", "DT", "the"),
                                t("world", "NN", "world"),
                                t("war", "NN", "war")
                            ])
                        )
                    )
                ])
            )
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        diffedAssertEqual(
            String(data: try encoder.encode(query), encoding: .utf8),
            """
            {
              "type" : "list-question",
              "subtype" : "other",
              "query" : {
                "query" : {
                  "type" : "query",
                  "subtype" : "named",
                  "tokens" : [
                    {
                      "word" : "books",
                      "lemma" : "book",
                      "type" : "token",
                      "tag" : "NN"
                    }
                  ]
                },
                "property" : {
                  "type" : "property",
                  "subtype" : "and",
                  "properties" : [
                    {
                      "filter" : {
                        "type" : "filter",
                        "subtype" : "plain",
                        "value" : {
                          "type" : "value",
                          "subtype" : "named",
                          "tokens" : [
                            {
                              "word" : "Orwell",
                              "lemma" : "orwell",
                              "type" : "token",
                              "tag" : "NNP"
                            }
                          ]
                        }
                      },
                      "type" : "property",
                      "subtype" : "inverse-with-filter",
                      "name" : [
                        {
                          "word" : "did",
                          "lemma" : "do",
                          "type" : "token",
                          "tag" : "VBD"
                        },
                        {
                          "word" : "write",
                          "lemma" : "write",
                          "type" : "token",
                          "tag" : "VB"
                        }
                      ]
                    },
                    {
                      "filter" : {
                        "value" : {
                          "type" : "value",
                          "subtype" : "named",
                          "tokens" : [
                            {
                              "word" : "the",
                              "lemma" : "the",
                              "type" : "token",
                              "tag" : "DT"
                            },
                            {
                              "word" : "world",
                              "lemma" : "world",
                              "type" : "token",
                              "tag" : "NN"
                            },
                            {
                              "word" : "war",
                              "lemma" : "war",
                              "type" : "token",
                              "tag" : "NN"
                            }
                          ]
                        },
                        "type" : "filter",
                        "subtype" : "with-modifier",
                        "modifier" : [
                          {
                            "word" : "before",
                            "lemma" : "before",
                            "type" : "token",
                            "tag" : "IN"
                          }
                        ]
                      },
                      "type" : "property",
                      "subtype" : "with-filter",
                      "name" : [

                      ]
                    }
                  ]
                },
                "type" : "query",
                "subtype" : "with-property"
              }
            }
            """
        )
    }
}
