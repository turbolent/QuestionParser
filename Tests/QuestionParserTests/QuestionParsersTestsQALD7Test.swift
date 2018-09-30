
// https://github.com/ag-sc/QALD/blob/aaa6f17149056d6fdd877562c23d4c3894096fe6/7/data/qald-7-test-en-wikidata.json
// Sep 10, 2017
// jq '[.questions[]  |  select (.answertype == "resource" ) | .question[] | select(.language == "en") | .string]'

import XCTest
import SwiftParserCombinators
@testable import QuestionParser

final class QuestionParsersTestsQALD7Test: XCTestCase {

    func testQ1() {

        // Give me all cosmonauts.

        expectQuestionSuccess(
            .other(.named([t("cosmonauts", "NNS", "cosmonaut")])),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("cosmonauts", "NNS", "cosmonaut"),
            t(".", ".", ".")
        )
    }

    func testQ2() {

        // Who is the daughter of Robert Kennedy married to?

        expectQuestionSuccess(
            .person(
                .inverseWithFilter(
                    name: [
                        t("is", "VBZ", "be"),
                        t("married", "VBD", "marry"),
                        t("to", "IN", "to")
                    ],
                    filter: .plain(
                        .relationship(
                            .named([
                                t("the", "DT", "the"),
                                t("daughter", "NN", "daughter")
                            ]),
                            .named([
                                t("Robert", "NNP", "robert"),
                                t("Kennedy", "NNP", "kennedy")
                            ]),
                            token: t("of", "IN", "of")
                        )
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("daughter", "NN", "daughter"),
            t("of", "IN", "of"),
            t("Robert", "NNP", "robert"),
            t("Kennedy", "NNP", "kennedy"),
            t("married", "VBD", "marry"),
            t("to", "IN", "to"),
            t("?", ".", "?")
        )
    }

    func testQ3() {

        // Which river does the Brooklyn Bridge cross?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("river", "NN", "river")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("cross", "V", "cross")
                        ],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("Brooklyn", "NNP", "brooklyn"),
                            t("Bridge", "NNP", "bridge")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("river", "NN", "river"),
            t("does", "VBZ", "do"),
            t("the", "DT", "the"),
            t("Brooklyn", "NNP", "brooklyn"),
            t("Bridge", "NNP", "bridge"),
            t("cross", "V", "cross"),
            t("?", ".", "?")
        )
    }

    func testQ4() {

        // In which city did John F. Kennedy die?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("city", "NN", "city")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("die", "VB", "die"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([
                            t("John", "NNP", "john"),
                            t("F.", "NNP", "f."),
                            t("Kennedy", "NNP", "kennedy")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("city", "NN", "city"),
            t("did", "VBD", "do"),
            t("John", "NNP", "john"),
            t("F.", "NNP", "f."),
            t("Kennedy", "NNP", "kennedy"),
            t("die", "VB", "die"),
            t("?", ".", "?")
        )
    }

    func testQ5() {

        // Which countries have more than ten caves?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("countries", "NNS", "country")]),
                    property: .withFilter(
                        name: [t("have", "VBP", "have")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("more", "JJR", "more"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [t("ten", "CD", "ten")],
                                unit: [t("caves", "NNS", "cave")]
                            )
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("countries", "NNS", "country"),
            t("have", "VBP", "have"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("ten", "CD", "ten"),
            t("caves", "NNS", "cave"),
            t("?", ".", "?")
        )
    }

    func testQ6() {

        // Who created Goofy?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("created", "VBD", "create")],
                    filter: .plain(.named([t("Goofy", "N", "goofy")]))
                )
            ),
            t("Who", "WP", "who"),
            t("created", "VBD", "create"),
            t("Goofy", "N", "goofy"),
            t("?", ".", "?")
        )
    }

    func testQ7() {

        // Give me the capitals of all countries in Africa.

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("capitals", "NNS", "capital")
                    ]),
                    .withProperty(
                        .named([
                            t("all", "DT", "all"),
                            t("countries", "NNS", "country")
                        ]),
                        property: .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("Africa", "NNP", "africa")])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("the", "DT", "the"),
            t("capitals", "NNS", "capital"),
            t("of", "IN", "of"),
            t("all", "DT", "all"),
            t("countries", "NNS", "country"),
            t("in", "IN", "in"),
            t("Africa", "NNP", "africa"),
            t(".", ".", ".")
        )
    }

    func testQ8() {

        // Give me all cities in New Jersey with more than 100000 inhabitants.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([
                                    t("New", "NNP", "new"),
                                    t("Jersey", "NNP", "jersey")
                                ])
                            )
                        ),
                        .withFilter(
                            name: [t("with", "IN", "with")],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("more", "JJR", "more"),
                                    t("than", "IN", "than")
                                ],
                                value: .number(
                                    [t("100000", "CD", "100000")],
                                    unit: [t("inhabitants", "NNS", "inhabitant")]
                                )
                            )
                        )
                    ])
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("cities", "NNS", "city"),
            t("in", "IN", "in"),
            t("New", "NNP", "new"),
            t("Jersey", "NNP", "jersey"),
            t("with", "IN", "with"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("100000", "CD", "100000"),
            t("inhabitants", "NNS", "inhabitant"),
            t(".", ".", ".")
        )
    }

    func testQ9() {

        // TODO: improve

        // Which museum exhibits The Scream by Munch?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("museum", "NN", "museum")]),
                    property: .and([
                        .withFilter(
                            name: [t("exhibits", "VBZ", "exhibit")],
                            filter: .plain(.named([
                                t("The", "DT", "the"),
                                t("Scream", "NNP", "scream")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("by", "IN", "by")],
                                value: .named([t("Munch", "NNP", "munch")])
                            )
                        )
                    ])
                )
            ),
            t("Which", "WDT", "which"),
            t("museum", "NN", "museum"),
            t("exhibits", "VBZ", "exhibit"),
            t("The", "DT", "the"),
            t("Scream", "NNP", "scream"),
            t("by", "IN", "by"),
            t("Munch", "NNP", "munch"),
            t("?", ".", "?")
        )
    }

    func testQ10() {

        // In which country is the Limerick Lake?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("country", "NN", "country")]),
                    property: .inverseWithFilter(
                        name: [
                            t("is", "VBZ", "be"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("Limerick", "NNP", "limerick"),
                            t("Lake", "NNP", "lake")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("country", "NN", "country"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("Limerick", "NNP", "limerick"),
            t("Lake", "NNP", "lake"),
            t("?", ".", "?")
        )
    }

    func testQ11() {

        // Which television shows were created by John Cleese?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("television", "NN", "television"),
                        t("shows", "NNS", "show")
                    ]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("created", "VBN", "create")
                        ],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("John", "NNP", "john"),
                                t("Cleese", "NNP", "cleese")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("television", "NN", "television"),
            t("shows", "NNS", "show"),
            t("were", "VBD", "be"),
            t("created", "VBN", "create"),
            t("by", "IN", "by"),
            t("John", "NNP", "john"),
            t("Cleese", "NNP", "cleese"),
            t("?", ".", "?")
        )
    }

    func testQ12() {

        // TODO improve

        // Which mountain is the highest after the Annapurna?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("mountain", "NN", "mountain")]),
                    property: .and([
                        .withFilter(
                            name: [t("is", "VBZ", "be")],
                            filter: .plain(.named([
                                t("the", "DT", "the"),
                                t("highest", "JJS", "high")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("after", "IN", "after")],
                                value: .named([
                                    t("the", "DT", "the"),
                                    t("Annapurna", "NNP", "annapurna")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("Which", "WDT", "which"),
            t("mountain", "NN", "mountain"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("highest", "JJS", "high"),
            t("after", "IN", "after"),
            t("the", "DT", "the"),
            t("Annapurna", "NNP", "annapurna"),
            t("?", ".", "?")
        )
    }

    func testQ13() {

        // In which films directed by Garry Marshall was Julia Roberts starring?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("films", "NNS", "film")]),
                    property: .and([
                        .withFilter(
                            name: [t("directed", "VBN", "direct")],
                            filter: .withModifier(
                                modifier: [t("by", "IN", "by")],
                                value: .named([
                                    t("Garry", "NNP", "garry"),
                                    t("Marshall", "NNP", "marshall")
                                ])
                            )
                        ),
                        .inverseWithFilter(
                            name: [
                                t("was", "VBD", "be"),
                                t("starring", "VBG", "star"),
                                t("in", "IN", "in")
                            ],
                            filter: .plain(.named([
                                t("Julia", "NNP", "julia"),
                                t("Roberts", "NNP", "roberts")
                            ]))
                        )
                    ])
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("films", "NNS", "film"),
            t("directed", "VBN", "direct"),
            t("by", "IN", "by"),
            t("Garry", "NNP", "garry"),
            t("Marshall", "NNP", "marshall"),
            t("was", "VBD", "be"),
            t("Julia", "NNP", "julia"),
            t("Roberts", "NNP", "roberts"),
            t("starring", "VBG", "star"),
            t("?", ".", "?")
        )
    }

    func testQ14() {

        // Give me all communist countries.

        expectQuestionSuccess(
            .other(
                .named([
                    t("communist", "JJ", "communist"),
                    t("countries", "NNS", "country")
                ])
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("communist", "JJ", "communist"),
            t("countries", "NNS", "country"),
            t(".", ".", ".")
        )
    }

    func testQ15() {

        // Which awards did Douglas Hofstadter win?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("awards", "NNS", "award")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("win", "VB", "win")
                        ],
                        filter: .plain(.named([
                            t("Douglas", "NNP", "douglas"),
                            t("Hofstadter", "NNP", "hofstadter")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("awards", "NNS", "award"),
            t("did", "VBD", "do"),
            t("Douglas", "NNP", "douglas"),
            t("Hofstadter", "NNP", "hofstadter"),
            t("win", "VB", "win"),
            t("?", ".", "?")
        )
    }

    func testQ16() {

        // What is the currency of the Czech Republic?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("currency", "NN", "currency")]),
                    .named([
                        t("the", "DT", "the"),
                        t("Czech", "NNP", "czech"),
                        t("Republic", "NNP", "republic")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("currency", "NN", "currency"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("Czech", "NNP", "czech"),
            t("Republic", "NNP", "republic"),
            t("?", ".", "?")
        )
    }

    func testQ17() {

        // Which countries adopted the Euro?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("countries", "NNS", "country")]),
                    property: .withFilter(
                        name: [t("adopted", "VBD", "adopt")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("Euro", "NNP", "euro")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("countries", "NNS", "country"),
            t("adopted", "VBD", "adopt"),
            t("the", "DT", "the"),
            t("Euro", "NNP", "euro"),
            t("?", ".", "?")
        )
    }

    func testQ18() {

        // Which countries have more than two official languages?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("countries", "NNS", "country")]),
                    property: .withFilter(
                        name: [t("have", "VBP", "have")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("more", "JJR", "more"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [t("two", "CD", "two")],
                                unit: [
                                    t("official", "JJ", "official"),
                                    t("languages", "NNS", "language")
                                ]
                            )
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("countries", "NNS", "country"),
            t("have", "VBP", "have"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("two", "CD", "two"),
            t("official", "JJ", "official"),
            t("languages", "NNS", "language"),
            t("?", ".", "?")
        )
    }

    func testQ19() {

        // Who is the owner of Rolls-Royce?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("owner", "NN", "owner")
                    ]),
                    .named([
                        t("Rolls", "NNP", "rolls"),
                        t("-", "HYPH", "-"),
                        t("Royce", "NNP", "royce")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("owner", "NN", "owner"),
            t("of", "IN", "of"),
            t("Rolls", "NNP", "rolls"),
            t("-", "HYPH", "-"),
            t("Royce", "NNP", "royce"),
            t("?", ".", "?")
        )
    }

    func testQ20() {

        // Through which countries does the Yenisei river flow?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("countries", "NNS", "country")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("flow", "V", "flow"),
                            t("through", "IN", "through")
                        ],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("Yenisei", "NNP", "yenisei"),
                            t("river", "NN", "river")
                        ]))
                    )
                )
            ),
            t("Through", "IN", "through"),
            t("which", "WDT", "which"),
            t("countries", "NNS", "country"),
            t("does", "VBZ", "do"),
            t("the", "DT", "the"),
            t("Yenisei", "NNP", "yenisei"),
            t("river", "NN", "river"),
            t("flow", "V", "flow"),
            t("?", ".", "?")
        )
    }

    func testQ21() {

        // Which politicians were married to a German?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("politicians", "NNS", "politician")]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("married", "VBN", "marry")
                        ],
                        filter: .withModifier(
                            modifier: [t("to", "IN", "to")],
                            value: .named([
                                t("a", "DT", "a"),
                                t("German", "JJ", "german")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("politicians", "NNS", "politician"),
            t("were", "VBD", "be"),
            t("married", "VBN", "marry"),
            t("to", "IN", "to"),
            t("a", "DT", "a"),
            t("German", "JJ", "german"),
            t("?", ".", "?")
        )
    }

    func testQ22() {

        // What is the highest mountain in Australia?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("highest", "JJS", "high"),
                        t("mountain", "NN", "mountain")
                    ]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Australia", "NNP", "australia")])
                        )
                    )
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("highest", "JJS", "high"),
            t("mountain", "NN", "mountain"),
            t("in", "IN", "in"),
            t("Australia", "NNP", "australia"),
            t("?", ".", "?")
        )
    }

    func testQ23() {

        // Give me all soccer clubs in Spain.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("soccer", "NN", "soccer"),
                        t("clubs", "NNS", "club")
                    ]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Spain", "NNP", "spain")])
                        )
                    )
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("soccer", "NN", "soccer"),
            t("clubs", "NNS", "club"),
            t("in", "IN", "in"),
            t("Spain", "NNP", "spain"),
            t(".", ".", ".")
        )
    }

    func testQ24() {

        // What is the official language of Suriname?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("official", "JJ", "official"),
                        t("language", "NN", "language")
                    ]),
                    .named([t("Suriname", "NNP", "suriname")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("official", "JJ", "official"),
            t("language", "NN", "language"),
            t("of", "IN", "of"),
            t("Suriname", "NNP", "suriname"),
            t("?", ".", "?")
        )
    }

    func testQ25() {

        // Who is the mayor of Tel Aviv?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("mayor", "NN", "mayor")
                    ]),
                    .named([
                        t("Tel", "NNP", "tel"),
                        t("Aviv", "NNP", "aviv")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("mayor", "NN", "mayor"),
            t("of", "IN", "of"),
            t("Tel", "NNP", "tel"),
            t("Aviv", "NNP", "aviv"),
            t("?", ".", "?")
        )
    }

    func testQ26() {

        // Which telecommunications organizations are located in Belgium?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("telecommunications", "NN", "telecommunications"),
                        t("organizations", "NNS", "organization")
                    ]),
                    property: .withFilter(
                        name: [
                            t("are", "VBP", "be"),
                            t("located", "VBN", "locate")
                        ],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Belgium", "NNP", "belgium")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("telecommunications", "NN", "telecommunications"),
            t("organizations", "NNS", "organization"),
            t("are", "VBP", "be"),
            t("located", "VBN", "locate"),
            t("in", "IN", "in"),
            t("Belgium", "NNP", "belgium"),
            t("?", ".", "?")
        )
    }

    func testQ27() {

        // What is the highest place of the Urals?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("highest", "JJS", "high"),
                        t("place", "NN", "place")
                    ]),
                    .named([
                        t("the", "DT", "the"),
                        t("Urals", "NNS", "ural")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("highest", "JJS", "high"),
            t("place", "NN", "place"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("Urals", "NNS", "ural"),
            t("?", ".", "?")
        )
    }

    func testQ28() {

        // TODO: improve

        // Who wrote the lyrics for the Polish national anthem?

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("wrote", "VBD", "write")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("lyrics", "NNS", "lyric")
                        ]))
                    ),
                    .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("for", "IN", "for")],
                            value: .named([
                                t("the", "DT", "the"),
                                t("Polish", "JJ", "polish"),
                                t("national", "JJ", "national"),
                                t("anthem", "NN", "anthem")
                            ])
                        )
                    )
                ])
            ),
            t("Who", "WP", "who"),
            t("wrote", "VBD", "write"),
            t("the", "DT", "the"),
            t("lyrics", "NNS", "lyric"),
            t("for", "IN", "for"),
            t("the", "DT", "the"),
            t("Polish", "JJ", "polish"),
            t("national", "JJ", "national"),
            t("anthem", "NN", "anthem"),
            t("?", ".", "?")
        )
    }

    func testQ29() {

        // Give me all federal chancellors of Germany.

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("federal", "JJ", "federal"),
                        t("chancellors", "NNS", "chancellor")
                    ]),
                    .named([t("Germany", "NNP", "germany")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("federal", "JJ", "federal"),
            t("chancellors", "NNS", "chancellor"),
            t("of", "IN", "of"),
            t("Germany", "NNP", "germany"),
            t(".", ".", ".")
        )
    }

    func testQ30() {

        // List all episodes of the first season of the HBO television series The Sopranos.

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("episodes", "NNS", "episode")]),
                    .relationship(
                        .named([
                            t("the", "DT", "the"),
                            t("first", "JJ", "first"),
                            t("season", "NN", "season")
                        ]),
                        .withProperty(
                            .named([
                                t("the", "DT", "the"),
                                t("HBO", "NNP", "hbo"),
                                t("television", "NN", "television"),
                                t("series", "NN", "series")
                            ]),
                            property: .withFilter(
                                name: [],
                                filter: .plain(.named([
                                    t("The", "DT", "the"),
                                    t("Sopranos", "NNPS", "sopranos")
                                ]))
                            )
                        ),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("List", "VB", "list"),
            t("all", "DT", "all"),
            t("episodes", "NNS", "episode"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("first", "JJ", "first"),
            t("season", "NN", "season"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("HBO", "NNP", "hbo"),
            t("television", "NN", "television"),
            t("series", "NN", "series"),
            t("The", "DT", "the"),
            t("Sopranos", "NNPS", "sopranos"),
            t(".", ".", ".")
        )
    }

    func testQ31() {

        // Which actors were born in Germany?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("actors", "NNS", "actor")]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("born", "VBN", "bear")
                        ],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Germany", "NNP", "germany")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("actors", "NNS", "actor"),
            t("were", "VBD", "be"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("Germany", "NNP", "germany"),
            t("?", ".", "?")
        )
    }

    func testQ32() {

        // Which instruments does Cat Stevens play?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("instruments", "NNS", "instrument")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("play", "VB", "play")
                        ],
                        filter: .plain(.named([
                            t("Cat", "NNP", "cat"),
                            t("Stevens", "NNP", "stevens")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("instruments", "NNS", "instrument"),
            t("does", "VBZ", "do"),
            t("Cat", "NNP", "cat"),
            t("Stevens", "NNP", "stevens"),
            t("play", "VB", "play"),
            t("?", ".", "?")
        )
    }

    func testQ33() {

        // Give me all books written by Danielle Steel

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNS", "book")]),
                    property: .withFilter(
                        name: [t("written", "VBN", "write")],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("Danielle", "NNP", "danielle"),
                                t("Steel", "NNP", "steel")
                            ])
                        )
                    )
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("books", "NNS", "book"),
            t("written", "VBN", "write"),
            t("by", "IN", "by"),
            t("Danielle", "NNP", "danielle"),
            t("Steel", "NNP", "steel")
        )
    }
}
