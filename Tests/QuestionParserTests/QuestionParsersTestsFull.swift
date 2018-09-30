import XCTest
import SwiftParserCombinators
@testable import QuestionParser

final class QuestionParsersTestsFull: XCTestCase {

    func testQ1() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("musicians", "NNS", "musician")]),
                    property: .and([
                        .withFilter(
                            name: [
                                t("were", "VBD", "be"),
                                t("born", "VBN", "bear")
                            ],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("Vienna", "NNP", "vienna")])
                            )
                        ),
                        .withFilter(
                            name: [t("died", "VBN", "die")],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("Berlin", "NNP", "berlin")])
                            )
                        )
                    ])
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "me"),
            t("all", "DT", "all"),
            t("musicians", "NNS", "musician"),
            t("that", "WDT", "that"),
            t("were", "VBD", "be"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("Vienna", "NNP", "vienna"),
            t("and", "CC", "and"),
            t("died", "VBN", "die"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin")
        )
    }

    func testQ2() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("presidents", "NNS", "president")]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("born", "VBN", "bear")
                        ],
                        filter: .withModifier(
                            modifier: [t("before", "IN", "before")],
                            value: .number([t("1900", "CD", "1900")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("presidents", "NNS", "president"),
            t("were", "VBD", "be"),
            t("born", "VBN", "bear"),
            t("before", "IN", "before"),
            t("1900", "CD", "1900")
        )
    }

    func testQ3() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("actors", "NNS", "actor")]),
                    property: .withFilter(
                        name: [t("born", "VBN", "bear")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .or([
                                .named([t("Berlin", "NNP", "berlin")]),
                                .named([
                                    t("San", "NNP", "san"),
                                    t("Francisco", "NNP", "francisco")
                                ])
                            ])
                        )
                    )
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "me"),
            t("all", "DT", "all"),
            t("actors", "NNS", "actor"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin"),
            t("or", "CC", "or"),
            t("San", "NNP", "san"),
            t("Francisco", "NNP", "francisco")
        )
    }

    func testQ4() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNS", "book")]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("George", "NNP", "george"),
                                t("Orwell", "NNP", "orwell")
                            ])
                        )
                    )
                )
            ),
            t("List", "VB", "list"),
            t("books", "NNS", "book"),
            t("by", "IN", "by"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell")
        )
    }

    func testQ5() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NN", "book")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("write", "VB", "write")
                        ],
                        filter: .plain(
                            .named([
                                t("George", "NNP", "george"),
                                t("Orwell", "NNP", "orwell")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("books", "NN", "book"),
            t("did", "VBD", "do"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell"),
            t("write", "VB", "write")
        )
    }

    func testQ6() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NN", "book")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("write", "VB", "write")
                        ],
                        filter: .plain(
                            .named([
                                t("George", "NNP", "george"),
                                t("Orwell", "NNP", "orwell")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("books", "NN", "book"),
            t("did", "VBD", "do"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell"),
            t("write", "VB", "write"))
    }

    func testQ7() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("presidents", "NNS", "president")]),
                    .named([t("Argentina", "NNP", "argentina")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("list", "VB", "list"),
            t("presidents", "NNS", "president"),
            t("of", "IN", "of"),
            t("Argentina", "NNP", "argentina")
        )
    }

    func testQ8() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("movies", "NNS", "movie")]),
                    property: .withFilter(
                        name: [t("directed", "VBN", "direct")],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("Quentin", "NNP", "quentin"),
                                t("Tarantino", "NNP", "tarantino")
                            ])
                        )
                    )
                )
            ),
            t("List", "VB", "list"),
            t("movies", "NNS", "movie"),
            t("directed", "VBN", "direct"),
            t("by", "IN", "by"),
            t("Quentin", "NNP", "quentin"),
            t("Tarantino", "NNP", "tarantino")
        )
    }

    func testQ9() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("movies", "NN", "movie")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("direct", "VB", "direct")
                        ],
                        filter: .plain(
                            .named([
                                t("Mel", "NNP", "mel"),
                                t("Gibson", "NNP", "gibson")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("movies", "NN", "movie"),
            t("did", "VBD", "do"),
            t("Mel", "NNP", "mel"),
            t("Gibson", "NNP", "gibson"),
            t("direct", "VB", "direct")
        )
    }

    func testQ10() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("movies", "NN", "movie")]), property:
                    .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("star", "VB", "star"),
                            t("in", "RP", "in")
                        ],
                        filter: .plain(.named([t("Obama", "NNP", "obama")]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("movies", "NN", "movie"),
            t("did", "VBD", "do"),
            t("Obama", "NNP", "obama"),
            t("star", "VB", "star"),
            t("in", "RP", "in")
        )
    }

    func testQ11() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("movies", "NN", "movie")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("appear", "VB", "appear")
                        ],
                        filter: .plain(.named([
                            t("Jennifer", "NNP", "jennifer"),
                            t("Aniston", "NNP", "aniston")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("what", "WDT", "what"),
            t("movies", "NN", "movie"),
            t("did", "VBD", "do"),
            t("Jennifer", "NNP", "jennifer"),
            t("Aniston", "NNP", "aniston"),
            t("appear", "VB", "appear")
        )
    }

    func testQ12() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("Movies", "NNP", "movie")]),
                    property: .withFilter(
                        name: [t("starring", "VB", "star")],
                        filter: .plain(.named([
                            t("Winona", "NNP", "winona"),
                            t("Ryder", "NNP", "ryder")
                        ]))
                    )
                )
            ),
            t("Movies", "NNP", "movie"),
            t("starring", "VB", "star"),
            t("Winona", "NNP", "winona"),
            t("Ryder", "NNP", "ryder")
        )
    }

    func testQ13() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("albums", "NNS", "album")]),
                    .named([
                        t("Pink", "NNP", "pink"),
                        t("Floyd", "NNP", "floyd")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("List", "VB", "list"),
            t("albums", "NNS", "album"),
            t("of", "IN", "of"),
            t("Pink", "NNP", "pink"),
            t("Floyd", "NNP", "floyd")
        )
    }

    func testQ14() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("actors", "NNS", "actor")
                    ]),
                    .named([t("Titanic", "NNP", "titanic")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("List", "VB", "list"),
            t("the", "DT", "the"),
            t("actors", "NNS", "actor"),
            t("of", "IN", "of"),
            t("Titanic", "NNP", "titanic")
        )
    }

    func testQ15() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("actors", "NNS", "actor")
                    ]),
                    .named([t("Titanic", "NNP", "titanic")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("who", "WP", "who"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("actors", "NNS", "actor"),
            t("of", "IN", "of"),
            t("Titanic", "NNP", "titanic")
        )
    }

    func testQ16() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("acted", "VBD", "act")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .named([t("Alien", "NNP", "alien")])
                    )
                )
            ),
            t("who", "WP", "who"),
            t("acted", "VBD", "act"),
            t("in", "IN", "in"),
            t("Alien", "NNP", "alien")
        )
    }

    func testQ17() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("starred", "VBD", "star")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .named([t("Inception", "NNP", "inception")])
                    )
                )
            ),
            t("who", "WP", "who"),
            t("starred", "VBD", "star"),
            t("in", "IN", "in"),
            t("Inception", "NNP", "inception")
        )
    }

    func testQ18() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("actors", "NNS", "actor")
                    ]),
                    property: .withFilter(
                        name: [t("starred", "VBD", "star")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Inception", "NNP", "inception")])
                        )
                    )
                )
            ),
            t("who", "WP", "who"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("actors", "NNS", "actor"),
            t("which", "WDT", "which"),
            t("starred", "VBD", "star"),
            t("in", "IN", "in"),
            t("Inception", "NNP", "inception")
        )
    }

    func testQ19() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("director", "NN", "director")
                    ]),
                    .named([
                        t("Big", "NN", "big"),
                        t("Fish", "NN", "fish")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("director", "NN", "director"),
            t("of", "IN", "of"),
            t("Big", "NN", "big"),
            t("Fish", "NN", "fish")
        )
    }

    func testQ20() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("directed", "VBD", "direct")],
                    filter: .plain(.named([t("Pocahontas", "NNP", "pocahontas")]))
                )
            ),
            t("who", "WP", "who"),
            t("directed", "VBD", "direct"),
            t("Pocahontas", "NNP", "pocahontas")
        )
    }

    func testQ21() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("city", "NN", "city")]),
                    property: .withFilter(
                        name: [t("is", "VBZ", "be")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("bigger", "JJR", "big"),
                                t("than", "IN", "than")
                            ],
                            value: .named([
                                t("New", "NNP", "new"),
                                t("York", "NNP", "york"),
                                t("City", "NNP", "city")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("city", "NN", "city"),
            t("is", "VBZ", "be"),
            t("bigger", "JJR", "big"),
            t("than", "IN", "than"),
            t("New", "NNP", "new"),
            t("York", "NNP", "york"),
            t("City", "NNP", "city")
        )
    }

    func testQ22() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("members", "NNS", "member")
                    ]),
                    .named([
                        t("Metallica", "NNP", "metallica")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("members", "NNS", "member"),
            t("of", "IN", "of"),
            t("Metallica", "NNP", "metallica")
        )
    }

    func testQ23() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("members", "NNS", "member")]),
                    .named([t("Metallica", "NNP", "metallica")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("members", "NNS", "member"),
            t("of", "IN", "of"),
            t("Metallica", "NNP", "metallica")
        )
    }

    func testQ24() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("music", "NN", "music"),
                        t("genre", "NN", "genre")
                    ]),
                    .named([t("Gorillaz", "NNP", "gorillaz")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("music", "NN", "music"),
            t("genre", "NN", "genre"),
            t("of", "IN", "of"),
            t("Gorillaz", "NNP", "gorillaz")
        )
    }

    func testQ25() {
        expectQuestionSuccess(
            .other(.named([t("actors", "NNP", "actor")])),
            t("actors", "NNP", "actor")
        )
    }

    func testQ26() {
        expectQuestionSuccess(
            .other(.named([
                t("Radiohead", "NNS", "radiohead"),
                t("members", "NNP", "member")
            ])),
            t("Radiohead", "NNS", "radiohead"),
            t("members", "NNP", "member")
        )
    }

    func testQ27() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("the", "DT", "the"), t("cast", "NN", "cast")]),
                    .named([t("Friends", "NNS", "friend")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("cast", "NN", "cast"),
            t("of", "IN", "of"),
            t("Friends", "NNS", "friend")
        )
    }

    func testQ28() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("works", "VBZ", "work")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .named([
                            t("Breaking", "NNS", "break"),
                            t("Bad", "NNS", "bad")
                        ])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("works", "VBZ", "work"),
            t("in", "IN", "in"),
            t("Breaking", "NNS", "break"),
            t("Bad", "NNS", "bad")
        )
    }

    func testQ29() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("languages", "NNS", "language")]),
                    property: .withFilter(
                        name: [
                            t("are", "VBP", "be"),
                            t("spoken", "VBN", "speak")
                        ],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Switzerland", "NNP", "switzerland")])
                        )
                    )
                )
            ),
            t("what", "WDT", "what"),
            t("languages", "NNS", "language"),
            t("are", "VBP", "be"),
            t("spoken", "VBN", "speak"),
            t("in", "IN", "in"),
            t("Switzerland", "NNP", "switzerland")
        )
    }

    func testQ30() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .withFilter(
                        name: [t("have", "VBP", "have")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("more", "JJR", "more"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [
                                    t("two", "CD", "two"),
                                    t("million", "CD", "million")
                                ],
                                unit: [t("inhabitants", "NNS", "inhabitant")]
                            )
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("cities", "NNS", "city"),
            t("have", "VBP", "have"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("two", "CD", "two"),
            t("million", "CD", "million"),
            t("inhabitants", "NNS", "inhabitant")
        )
    }

    func testQ31() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("films", "NNS", "film")]),
                    property: .withFilter(
                        name: [t("featured", "VBD", "feature")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("character", "NN", "character"),
                            t("Popeye", "NNP", "popeye"),
                            t("Doyle", "NNP", "doyle")
                        ]))
                    )
                )
            ),
            t("What", "WP", "what"),
            t("films", "NNS", "film"),
            t("featured", "VBD", "feature"),
            t("the", "DT", "the"),
            t("character", "NN", "character"),
            t("Popeye", "NNP", "popeye"),
            t("Doyle", "NNP", "doyle")
        )
    }

    func testQ32() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("is", "VBZ", "be")],
                    filter: .withComparativeModifier(
                        modifier: [
                            t("taller", "JJR", "tall"),
                            t("than", "IN", "than")
                        ],
                        value: .named([t("Obama", "NNP", "obama")])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("taller", "JJR", "tall"),
            t("than", "IN", "than"),
            t("Obama", "NNP", "obama")
        )
    }

    func testQ33() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("lived", "VBD", "live")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .or([
                            .and([
                                .named([t("Berlin", "NNP", "berlin")]),
                                .named([t("Copenhagen", "NNP", "copenhagen")])
                            ]),
                            .named([
                                t("New", "NNP", "new"),
                                t("York", "NNP", "york"),
                                t("City", "NNP", "city")
                            ])
                        ])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("lived", "VBD", "live"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin"),
            t("and", "CC", "and"),
            t("Copenhagen", "NNP", "copenhagen"),
            t("or", "CC", "or"),
            t("New", "NNP", "new"),
            t("York", "NNP", "york"),
            t("City", "NNP", "city")
        )
    }

    func testQ34() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNS", "book")]),
                    property: .and([
                        .withFilter(
                            name: [t("written", "VBN", "write")],
                            filter: .withModifier(
                                modifier: [t("by", "IN", "by")],
                                value: .named([t("Orwell", "NNP", "orwell")])
                            )
                        ),
                        .withFilter(
                            name: [t("are", "VBP", "be")],
                            filter: .withModifier(
                                modifier: [t("about", "IN", "about")],
                                value: .named([
                                    t("dystopian", "JJ", "dystopian"),
                                    t("societies", "NNS", "society")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("books", "NNS", "book"),
            t("written", "VBN", "write"),
            t("by", "IN", "by"),
            t("Orwell", "NNP", "orwell"),
            t("are", "VBP", "be"),
            t("about", "IN", "about"),
            t("dystopian", "JJ", "dystopian"),
            t("societies", "NNS", "society")
        )
    }

    func testQ35() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NN", "book")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("write", "VB", "write")
                        ],
                        filter: .plain(.or([
                            .named([t("Orwell", "NNP", "orwell")]),
                            .named([t("Shakespeare", "NNP", "shakespeare")])
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("books", "NN", "book"),
            t("did", "VBD", "do"),
            t("Orwell", "NNP", "orwell"),
            t("or", "CC", "or"),
            t("Shakespeare", "NNP", "shakespeare"),
            t("write", "VB", "write")
        )
    }

    func testQ36() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("children", "NNS", "child")
                    ]),
                    .named([
                        t("the", "DT", "the"),
                        t("presidents", "NNS", "president")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("who", "WP", "who"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("children", "NNS", "child"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("presidents", "NNS", "president")
        )
    }

    func testQ37() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("largest", "JJS", "large"),
                        t("cities", "NNS", "city")
                    ]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("europe", "NN", "europe")])
                        )
                    )
                )
            ),
            t("what", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("largest", "JJS", "large"),
            t("cities", "NNS", "city"),
            t("in", "IN", "in"),
            t("europe", "NN", "europe")
        )
    }

    func testQ38() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NN", "population"),
                        t("sizes", "NNS", "size")
                    ]),
                    .withProperty(
                        .named([t("cities", "NNS", "city")]),
                        property: .withFilter(
                            name: [t("located", "VBN", "locate")],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("california", "NN", "california")])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("what", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("population", "NN", "population"),
            t("sizes", "NNS", "size"),
            t("of", "IN", "of"),
            t("cities", "NNS", "city"),
            t("located", "VBN", "locate"),
            t("in", "IN", "in"),
            t("california", "NN", "california")
        )
    }

    func testQ39() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NN", "population"),
                        t("sizes", "NNS", "size")
                    ]),
                    .withProperty(
                        .named([t("cities", "NNS", "city")]),
                        property: .withFilter(
                            name: [
                                t("are", "VBP", "be"),
                                t("located", "VBN", "locate")
                            ],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("california", "NN", "california")])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("what", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("population", "NN", "population"),
            t("sizes", "NNS", "size"),
            t("of", "IN", "of"),
            t("cities", "NNS", "city"),
            t("that", "WDT", "that"),
            t("are", "VBP", "be"),
            t("located", "VBN", "locate"),
            t("in", "IN", "in"),
            t("california", "NN", "california")
        )
    }

    func testQ40() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("children", "NNS", "child")
                    ]),
                    .relationship(
                        .named([
                            t("the", "DT", "the"),
                            t("children", "NNS", "child")
                        ]),
                        .named([
                            t("Bill", "NNP", "bill"),
                            t("Clinton", "NNP", "clinton")
                        ]),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("children", "NNS", "child"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("children", "NNS", "child"),
            t("of", "IN", "of"),
            t("Bill", "NNP", "bill"),
            t("Clinton", "NNP", "clinton")
        )
    }

    func testQ41() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("largest", "JJS", "large"),
                        t("cities", "NNS", "city")
                    ]),
                    .named([t("California", "NNP", "california")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("largest", "JJS", "large"),
            t("cities", "NNS", "city"),
            t("of", "IN", "of"),
            t("California", "NNP", "california")
        )
    }

    func testQ42() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("biggest", "JJS", "big"),
                        t("cities", "NNS", "city")
                    ]),
                    .named([t("California", "NNP", "california")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("biggest", "JJS", "big"),
            t("cities", "NNS", "city"),
            t("of", "IN", "of"),
            t("California", "NNP", "california")
        )
    }

    func testQ43() {
        expectQuestionSuccess(
            .person(
                .inverseWithFilter(
                    name: [
                        t("did", "VBD", "do"),
                        t("marry", "VB", "marry")
                    ],
                    filter: .plain(.named([
                        t("Bill", "NNP", "bill"),
                        t("Clinton", "NNP", "clinton")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("did", "VBD", "do"),
            t("Bill", "NNP", "bill"),
            t("Clinton", "NNP", "clinton"),
            t("marry", "VB", "marry")
        )
    }

    func testQ44() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("daughters", "NN", "daughter")]),
                    .named([t("Clinton", "NNP", "clinton")]),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("Clinton", "NNP", "clinton"),
            t("'s", "POS", "'s"),
            t("daughters", "NN", "daughter")
        )
    }

    func testQ45() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("biggest", "JJS", "big"),
                        t("cities", "NNS", "city")
                    ]),
                    .named([t("California", "NNP", "california")]),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("California", "NNP", "california"),
            t("'s", "POS", "'s"),
            t("biggest", "JJS", "big"),
            t("cities", "NNS", "city")
        )
    }

    func testQ46() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("daughter", "NN", "daughter")]),
                    .named([
                        t("Bill", "NNP", "bill"),
                        t("Clinton", "NNP", "clinton")
                    ]),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("Bill", "NNP", "bill"),
            t("Clinton", "NNP", "clinton"),
            t("'s", "POS", "'s"),
            t("daughter", "NN", "daughter")
        )
    }

    func testQ47() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("grandfather", "NN", "grandfather")]),
                    .relationship(
                        .named([t("daughter", "NN", "daughter")]),
                        .relationship(
                            .named([t("husband", "NN", "husband")]),
                            .relationship(
                                .named([t("daughter", "NN", "daughter")]),
                                .named([
                                    t("Bill", "NNP", "bill"),
                                    t("Clinton", "NNP", "clinton")
                                ]),
                                token: t("'s", "POS", "'s")
                            ),
                            token: t("'s", "POS", "'s")
                        ),
                        token: t("'s", "POS", "'s")
                    ),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("Bill", "NNP", "bill"),
            t("Clinton", "NNP", "clinton"),
            t("'s", "POS", "'s"),
            t("daughter", "NN", "daughter"),
            t("'s", "POS", "'s"),
            t("husband", "NN", "husband"),
            t("'s", "POS", "'s"),
            t("daughter", "NN", "daughter"),
            t("'s", "POS", "'s"),
            t("grandfather", "NN", "grandfather")
        )
    }

    func testQ48() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("presidents", "NNS", "president")]),
                    property: .withFilter(
                        name: [t("have", "VBP", "have")],
                        filter: .plain(.named([t("children", "NNS", "child")]))
                    )
                )
            ),
            t("presidents", "NNS", "president"),
            t("that", "WDT", "that"),
            t("have", "VBP", "have"),
            t("children", "NNS", "child")
        )
    }

    func testQ49() {
        expectQuestionSuccess(
            .person(
                .inverseWithFilter(
                    name: [
                        t("did", "VBD", "do"),
                        t("marry", "VB", "marry")
                    ],
                    filter: .plain(
                        .relationship(
                            .named([t("daughter", "NN", "daughter")]),
                            .named([
                                t("Bill", "NNP", "bill"),
                                t("Clinton", "NNP", "clinton")
                            ]),
                            token: t("'s", "POS", "'s")
                        )
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("did", "VBD", "do"),
            t("Bill", "NNP", "bill"),
            t("Clinton", "NNP", "clinton"),
            t("'s", "POS", "'s"),
            t("daughter", "NN", "daughter"),
            t("marry", "VB", "marry")
        )
    }

    func testQ50() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("californian", "JJS", "californian"),
                        t("cities", "NNS", "city")
                    ]),
                    property: .withFilter(
                        name: [t("live", "VBP", "live")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("more", "JJR", "more"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [
                                    t("2", "CD", "2"),
                                    t("million", "CD", "million")
                                ],
                                unit: [t("people", "NNS", "people")]
                            )
                        )
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("californian", "JJS", "californian"),
            t("cities", "NNS", "city"),
            t("live", "VBP", "live"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("2", "CD", "2"),
            t("million", "CD", "million"),
            t("people", "NNS", "people")
        )
    }

    func testQ51() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NNP", "population")
                    ]),
                    .withProperty(
                        .named([t("Japan", "NNP", "japan")]),
                        property: .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("before", "IN", "before")],
                                value: .number([t("1900", "CD", "1900")])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("the", "DT", "the"),
            t("population", "NNP", "population"),
            t("of", "IN", "of"),
            t("Japan", "NNP", "japan"),
            t("before", "IN", "before"),
            t("1900", "CD", "1900")
        )
    }

    func testQ52() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NN", "population")
                    ]),
                    .and([
                        .named([t("China", "NNP", "china")]),
                        .named([
                            t("the", "DT", "the"),
                            t("USA", "NNP", "usa")
                        ])
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("population", "NN", "population"),
            t("of", "IN", "of"),
            t("China", "NNP", "china"),
            t("and", "CC", "and"),
            t("the", "DT", "the"),
            t("USA", "NNP", "usa")
        )
    }

    func testQ53() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NNP", "population")
                    ]),
                    .and([
                        .named([t("Japan", "NNP", "japan")]),
                        .named([t("China", "NNP", "china")])
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("the", "DT", "the"),
            t("population", "NNP", "population"),
            t("of", "IN", "of"),
            t("Japan", "NNP", "japan"),
            t("and", "CC", "and"),
            t("China", "NNP", "china")
        )
    }

    func testQ54() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("population", "NNP", "population")
                    ]),
                    .withProperty(
                        .and([
                            .named([t("Japan", "NNP", "japan")]),
                            .named([t("China", "NNP", "china")])
                        ]),
                        property: .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("before", "IN", "before")],
                                value: .number([t("1900", "CD", "1900")])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("the", "DT", "the"),
            t("population", "NNP", "population"),
            t("of", "IN", "of"),
            t("Japan", "NNP", "japan"),
            t("and", "CC", "and"),
            t("China", "NNP", "china"),
            t("before", "IN", "before"),
            t("1900", "CD", "1900")
        )
    }

    func testQ55() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .and([
                        .named([
                            t("the", "DT", "the"),
                            t("population", "NNP", "population")
                        ]),
                        .named([t("area", "NNP", "area")])
                    ]),
                    .and([
                        .named([t("Japan", "NNP", "japan")]),
                        .named([t("China", "NNP", "china")])
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("the", "DT", "the"),
            t("population", "NNP", "population"),
            t("and", "CC", "and"),
            t("area", "NNP", "area"),
            t("of", "IN", "of"),
            t("Japan", "NNP", "japan"),
            t("and", "CC", "and"),
            t("China", "NNP", "china")
        )
    }

    func testQ56() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .and([
                        .named([
                            t("the", "DT", "the"),
                            t("population", "NN", "population")
                        ]),
                        .named([
                            t("land", "NN", "land"),
                            t("area", "NN", "area")
                        ]),
                        .named([t("capitals", "NNP", "capital")])
                    ]),
                    .and([
                        .named([t("Japan", "NNP", "japan")]),
                        .named([t("India", "NNP", "india")]),
                        .named([t("China", "NNP", "china")])
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("the", "DT", "the"),
            t("population", "NN", "population"),
            t(",", ",", ","),
            t("land", "NN", "land"),
            t("area", "NN", "area"),
            t("and", "CC", "and"),
            t("capitals", "NNP", "capital"),
            t("of", "IN", "of"),
            t("Japan", "NNP", "japan"),
            t(",", ",", ","),
            t("India", "NNP", "india"),
            t("and", "CC", "and"),
            t("China", "NNP", "china")
        )
    }

    func testQ57() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("children", "NNS", "child")]),
                    .relationship(
                        .named([
                            t("all", "DT", "all"),
                            t("presidents", "NNS", "president")
                        ]),
                        .named([
                            t("the", "DT", "the"),
                            t("US", "NNP", "us")
                        ]),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("children", "NNS", "child"),
            t("of", "IN", "of"),
            t("all", "DT", "all"),
            t("presidents", "NNS", "president"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("US", "NNP", "us")
        )
    }

    func testQ58() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .and([
                        .named([t("children", "NNS", "child")]),
                        .named([t("grandchildren", "NNS", "grandchild")])
                    ]),
                    .named([t("Clinton", "NNP", "clinton")]),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("Clinton", "NNP", "clinton"),
            t("'s", "POS", "'s"),
            t("children", "NNS", "child"),
            t("and", "CC", "and"),
            t("grandchildren", "NNS", "grandchild")
        )
    }

    func testQ59() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .and([
                        .named([t("population", "NNP", "population")]),
                        .named([t("area", "NNP", "area")])
                    ]),
                    .and([
                        .named([t("Japan", "NNP", "japan")]),
                        .named([t("China", "NNP", "china")])
                    ]),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("Japan", "NNP", "japan"),
            t("and", "CC", "and"),
            t("China", "NNP", "china"),
            t("'s", "POS", "'s"),
            t("population", "NNP", "population"),
            t("and", "CC", "and"),
            t("area", "NNP", "area")
        )
    }

    func testQ60() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNS", "book")]),
                    property: .and([
                        .withFilter(
                            name: [
                                t("were", "VBD", "be"),
                                t("written", "VBN", "write")
                            ],
                            filter: .withModifier(
                                modifier: [t("by", "IN", "by")],
                                value: .named([t("Orwell", "NNP", "orwell")])
                            )
                        ),
                        .withFilter(
                            name: [t("are", "VBP", "be")],
                            filter: .withModifier(
                                modifier: [t("about", "IN", "about")],
                                value: .named([
                                    t("dystopian", "JJ", "dystopian"),
                                    t("societies", "NNS", "society")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("books", "NNS", "book"),
            t("were", "VBD", "be"),
            t("written", "VBN", "write"),
            t("by", "IN", "by"),
            t("Orwell", "NNP", "orwell"),
            t("and", "CC", "and"),
            t("are", "VBP", "be"),
            t("about", "IN", "about"),
            t("dystopian", "JJ", "dystopian"),
            t("societies", "NNS", "society")
        )
    }

    func testQ61() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("president", "NN", "president")
                    ]),
                    .named([t("France", "NNP", "france")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("president", "NN", "president"),
            t("of", "IN", "of"),
            t("France", "NNP", "france")
        )
    }

    func testQ62() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("daughters", "NNS", "daughter")
                    ]),
                    .relationship(
                        .named([
                            t("the", "DT", "the"),
                            t("wife", "NN", "wife")
                        ]),
                        .relationship(
                            .named([
                                t("the", "DT", "the"),
                                t("president", "NN", "president")
                            ]),
                            .named([
                                t("the", "DT", "the"),
                                t("United", "NNP", "united"),
                                t("States", "NNPS", "state")
                            ]),
                            token: t("of", "IN", "of")
                        ),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("daughters", "NNS", "daughter"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("wife", "NN", "wife"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("president", "NN", "president"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("United", "NNP", "united"),
            t("States", "NNPS", "state")
        )
    }

    func testQ63() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NN", "book")]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("authored", "VBN", "author")
                        ],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("George", "NNP", "george"),
                                t("Orwell", "NNP", "orwell")
                            ])
                        )
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("books", "NN", "book"),
            t("were", "VBD", "be"),
            t("authored", "VBN", "author"),
            t("by", "IN", "by"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell")
        )
    }

    func testQ64() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("actor", "NN", "actor")]),
                    property: .withFilter(
                        name: [t("married", "VBD", "marry")],
                        filter: .plain(
                            .relationship(
                                .named([t("sister", "NN", "sister")]),
                                .named([
                                    t("John", "NNP", "john"),
                                    t("F.", "NNP", "f."),
                                    t("Kennedy", "NNP", "kennedy")
                                ]),
                                token: t("'s", "POS", "'s")
                            )
                        )
                    )
                )
            ),
            t("What", "WDT", "what"),
            t("actor", "NN", "actor"),
            t("married", "VBD", "marry"),
            t("John", "NNP", "john"),
            t("F.", "NNP", "f."),
            t("Kennedy", "NNP", "kennedy"),
            t("'s", "POS", "'s"),
            t("sister", "NN", "sister")
        )
    }

    func testQ65() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("instrument", "NN", "instrument")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("play", "VB", "play")
                        ],
                        filter: .plain(.named([
                            t("John", "NNP", "john"),
                            t("Lennon", "NNP", "lennon")
                        ]))
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("instrument", "NN", "instrument"),
            t("did", "VBD", "do"),
            t("John", "NNP", "john"),
            t("Lennon", "NNP", "lennon"),
            t("play", "VB", "play")
        )
    }

    func testQ66() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("poets", "NNS", "poet")]),
                    property: .withFilter(
                        name: [t("lived", "VBD", "live")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([
                                t("the", "DT", "the"),
                                t("19th", "JJ", "19th"),
                                t("century", "NN", "century")
                            ])
                        )
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("poets", "NNS", "poet"),
            t("lived", "VBD", "live"),
            t("in", "IN", "in"),
            t("the", "DT", "the"),
            t("19th", "JJ", "19th"),
            t("century", "NN", "century")
        )
    }

    func testQ67() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("wrote", "VBD", "write")],
                    filter: .plain(.and([
                        .named([
                            t("Le", "NNP", "le"),
                            t("Petit", "NNP", "petit"),
                            t("Prince", "NNP", "prince")
                        ]),
                        .named([
                            t("Vol", "NNP", "vol"),
                            t("de", "NNP", "de"),
                            t("Nuit", "NNP", "nuit")
                        ])
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("wrote", "VBD", "write"),
            t("\"", "``", "\""),
            t("Le", "NNP", "le"),
            t("Petit", "NNP", "petit"),
            t("Prince", "NNP", "prince"),
            t("\"", "''", "\""),
            t("and", "CC", "and"),
            t("\"", "``", "\""),
            t("Vol", "NNP", "vol"),
            t("de", "NNP", "de"),
            t("Nuit", "NNP", "nuit"),
            t("\"", "''", "\"")
        )
    }

    func testQ68() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("son", "NN", "son")
                    ]),
                    .relationship(
                        .named([
                            t("the", "DT", "the"),
                            t("main", "JJ", "main"),
                            t("actor", "NN", "actor")
                        ]),
                        .named([
                            t("I", "PRP", "i"),
                            t(",", ",", ","),
                            t("Robot", "NNP", "robot")
                        ]),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("son", "NN", "son"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("main", "JJ", "main"),
            t("actor", "NN", "actor"),
            t("of", "IN", "of"),
            t("\"", "``", "\""),
            t("I", "PRP", "i"),
            t(",", ",", ","),
            t("Robot", "NNP", "robot"),
            t("\"", "''", "\"")
        )
    }

    func testQ69() {
        expectQuestionSuccess(
            .thing(
                .inverseWithFilter(
                    name: [
                        t("did", "VBD", "do"),
                        t("write", "VB", "write")
                    ],
                    filter: .plain(.named([
                        t("George", "NNP", "george"),
                        t("Orwell", "NNP", "orwell")
                    ]))
                )
            ),
            t("What", "WP", "what"),
            t("did", "VBD", "do"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell"),
            t("write", "VB", "write")
        )
    }

    func testQ70() {
        expectQuestionSuccess(
            .thing(
                .withFilter(
                    name: [
                        t("was", "VBD", "be"),
                        t("authored", "VBN", "author")
                    ],
                    filter: .withModifier(
                        modifier: [t("by", "IN", "by")],
                        value: .named([
                            t("George", "NNP", "george"),
                            t("Orwell", "NNP", "orwell")
                        ])
                    )
                )
            ),
            t("What", "WP", "what"),
            t("was", "VBD", "be"),
            t("authored", "VBN", "author"),
            t("by", "IN", "by"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell")
        )
    }

    func testQ71() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNP", "book")]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("authored", "VBN", "author")
                        ],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("George", "NNP", "george"),
                                t("Orwell", "NNP", "orwell")
                            ])
                        )
                    )
                )
            ),
            t("What", "WP", "what"),
            t("books", "NNP", "book"),
            t("were", "VBD", "be"),
            t("authored", "VBN", "author"),
            t("by", "IN", "by"),
            t("George", "NNP", "george"),
            t("Orwell", "NNP", "orwell")
        )
    }

    func testQ72() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .and([
                        .named([t("children", "NNS", "child")]),
                        .named([
                            t("grand", "JJ", "grand"),
                            t("children", "NNS", "child")
                        ])
                    ]),
                    .named([t("Clinton", "NNP", "clinton")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("children", "NNS", "child"),
            t("and", "CC", "and"),
            t("grand", "JJ", "grand"),
            t("children", "NNS", "child"),
            t("of", "IN", "of"),
            t("Clinton", "NNP", "clinton")
        )
    }

    func testQ73() {

        // TODO: handle in second stage:
        //       empty property with modifying filter is constraining preceding property

        expectQuestionSuccess(
            .other(
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
            ),
            t("which", "WDT", "which"),
            t("books", "NN", "book"),
            t("did", "VBD", "do"),
            t("Orwell", "NNP", "orwell"),
            t("write", "VB", "write"),
            t("before", "IN", "before"),
            t("the", "DT", "the"),
            t("world", "NN", "world"),
            t("war", "NN", "war")
        )
    }

    func testQ74() {

        // TODO: handle in second stage:
        //       filter of empty second property is constraining preceding property
        //       (empty property is shortened from ~"which is")

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [t("have", "VBP", "have")],
                            filter: .plain(.named([
                                t("a", "DT", "a"),
                                t("population", "NN", "population")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .number([
                                    t("1", "CD", "1"),
                                    t("million", "CD", "million")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("cities", "NNS", "city"),
            t("which", "WDT", "which"),
            t("have", "VBP", "have"),
            t("a", "DT", "a"),
            t("population", "NN", "population"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("1", "CD", "1"),
            t("million", "CD", "million")
        )
    }

    func testQ75() {

        // TODO: handle in second stage:
        //       filter of empty second property is constraining preceding property
        //       (empty property is shortened from ~"which is")

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [t("have", "VBP", "have")],
                            filter: .plain(.named([
                                t("a", "DT", "a"),
                                t("population", "NN", "population")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .number([t("1000", "CD", "1000")])
                            )
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("cities", "NNS", "city"),
            t("have", "VBP", "have"),
            t("a", "DT", "a"),
            t("population", "NN", "population"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("1000", "CD", "1000")
        )
    }

    func testQ76() {

        // TODO: handle in second stage:
        //       filter of second property with single "be" lemma is constraining preceding property

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [t("have", "VBP", "have")],
                            filter: .plain(.named([
                                t("a", "DT", "a"),
                                t("population", "NN", "population")
                            ]))
                        ),
                        .withFilter(
                            name: [t("is", "VBZ", "be")],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .number([t("1000", "CD", "1000")])
                            )
                        )
                    ])
                )
            ),
            t("cities", "NNS", "city"),
            t("which", "WDT", "which"),
            t("have", "VBP", "have"),
            t("a", "DT", "a"),
            t("population", "NN", "population"),
            t("that", "WDT", "that"),
            t("is", "VBZ", "be"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("1000", "CD", "1000")
        )
    }

    func testQ77() {

        // TODO: handle in second stage:
        //       filter of empty second property is constraining preceding property
        //       (empty property is shortened from ~"which is")

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [t("have", "VBP", "have")],
                            filter: .plain(.named([
                                t("a", "DT", "a"),
                                t("population", "NN", "population")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .number([t("1000", "CD", "1000")])
                            )
                        )
                    ])
                )
            ),
            t("cities", "NNS", "city"),
            t("which", "WDT", "which"),
            t("have", "VBP", "have"),
            t("a", "DT", "a"),
            t("population", "NN", "population"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("1000", "CD", "1000")
        )
    }

    func testQ78() {

        // TODO: handle in second stage:
        //       filter of empty second property is constraining preceding property
        //       (empty property is shortened from ~"which is")

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .relationship(
                        .named([t("cities", "NNS", "city")]),
                        .named([t("California", "NNP", "california")]),
                        token: t("'s", "POS", "'s")
                    ),
                    property: .and([
                        .withFilter(
                            name: [t("have", "VBP", "have")],
                            filter: .plain(.named([
                                t("a", "DT", "a"),
                                t("population", "NN", "population")
                            ]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .number([
                                    t("1", "CD", "1"),
                                    t("million", "CD", "million")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("California", "NNP", "california"),
            t("'s", "POS", "'s"),
            t("cities", "NNS", "city"),
            t("which", "WDT", "which"),
            t("have", "VBP", "have"),
            t("a", "DT", "a"),
            t("population", "NN", "population"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("1", "CD", "1"),
            t("million", "CD", "million")
        )
    }

    func testQ79() {

        // TODO: handle in second stage:
        //       filter of empty last property is constraining preceding property
        //       (empty property is shortened from ~"which are located in")

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("California", "NNP", "california")])
                            )
                        ),
                        .withFilter(
                            name: [t("are", "VBP", "be")],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .named([t("cities", "NNS", "city")])
                            )
                        ),
                        .withFilter(
                            name: [],
                            filter: .or([
                                .withModifier(
                                    modifier: [t("in", "IN", "in")],
                                    value: .named([t("Germany", "NNP", "germany")])
                                ),
                                .withModifier(
                                    modifier: [t("in", "IN", "in")],
                                    value: .named([t("France", "NNP", "france")])
                                )
                            ])
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("cities", "NNS", "city"),
            t("in", "IN", "in"),
            t("California", "NNP", "california"),
            t("are", "VBP", "be"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("cities", "NNS", "city"),
            t("in", "IN", "in"),
            t("Germany", "NNP", "germany"),
            t("or", "CC", "or"),
            t("in", "IN", "in"),
            t("France", "NNP", "france")
        )
    }

    func testQ80() {

        // TODO: "Schindler's List" should be detected as one name, not as a possessive:
        //       also run NER for possessives
        // TODO: handle in second stage:
        //       filter of empty second property is constraining preceding property

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("composed", "VBN", "compose")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("music", "NN", "music")
                        ]))
                    ),
                    .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("for", "IN", "for")],
                            value: .relationship(
                                .named([t("List", "NN", "list")]),
                                .named([t("Schindler", "NNP", "schindler")]),
                                token: t("'s", "POS", "'s")
                            )
                        )
                    )
                ])
            ),
            t("Who", "WP", "who"),
            t("composed", "VBN", "compose"),
            t("the", "DT", "the"),
            t("music", "NN", "music"),
            t("for", "IN", "for"),
            t("Schindler", "NNP", "schindler"),
            t("'s", "POS", "'s"),
            t("List", "NN", "list")
        )
    }

    func testQ81() {

        // TODO: handle in second stage:
        //       filter of second property is constraining preceding property with comparative filter

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("cities", "NNS", "city")]),
                    property: .and([
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("California", "NNP", "california")])
                            )
                        ),
                        .withFilter(
                            name: [t("are", "VBP", "be")],
                            filter: .withComparativeModifier(
                                modifier: [
                                    t("larger", "JJR", "large"),
                                    t("than", "IN", "than")
                                ],
                                value: .named([
                                    t("cities", "NNS", "city")
                                ])
                            )
                        ),
                        .withFilter(
                            name: [
                                t("are", "VBD", "be"),
                                t("located", "VBD", "locate")
                            ],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([t("Germany", "NNP", "germany")])
                            )
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("cities", "NNS", "city"),
            t("in", "IN", "in"),
            t("California", "NNP", "california"),
            t("are", "VBP", "be"),
            t("larger", "JJR", "large"),
            t("than", "IN", "than"),
            t("cities", "NNS", "city"),
            t("which", "WDT", "which"),
            t("are", "VBD", "be"),
            t("located", "VBD", "locate"),
            t("in", "IN", "in"),
            t("Germany", "NNP", "germany")
        )
    }

    func testQ82() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("authors", "NNS", "author")]),
                    property: .named([t("died", "VBD", "die")])
                )
            ),
            t("authors", "NNS", "author"),
            t("who", "WP", "who"),
            t("died", "VBD", "die")
        )
    }

    func testQ83() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("authors", "NNS", "author")]),
                    property: .withFilter(
                        name: [t("died", "VBD", "die")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Berlin", "NNP", "berlin")])
                        )
                    )
                )
            ),
            t("authors", "NNS", "author"),
            t("which", "WDT", "which"),
            t("died", "VBD", "die"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin")
        )
    }

    func testQ84() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("mountains", "NNS", "mountain")]),
                    property: .adjectiveWithFilter(
                        name: [
                            t("are", "VBP", "be"),
                            t("high", "JJ", "high")
                        ],
                        filter: .plain(.number(
                            [t("1000", "CD", "1000")],
                            unit: [t("meters", "NNS", "meter")])
                        )
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("mountains", "NNS", "mountain"),
            t("are", "VBP", "be"),
            t("1000", "CD", "1000"),
            t("meters", "NNS", "meter"),
            t("high", "JJ", "high")
        )
    }

    func testQ85() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("mountains", "NNS", "mountain")]),
                    property: .adjectiveWithFilter(
                        name: [
                            t("are", "VBP", "be"),
                            t("high", "JJ", "high")
                        ],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("more", "JJR", "more"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [t("1000", "CD", "1000")],
                                unit: [t("meters", "NNS", "meter")]
                            )
                        )
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("mountains", "NNS", "mountain"),
            t("are", "VBP", "be"),
            t("more", "JJR", "more"),
            t("than", "IN", "than"),
            t("1000", "CD", "1000"),
            t("meters", "NNS", "meter"),
            t("high", "JJ", "high")
        )
    }

    func testQ86() {

        // TODO: handle in second stage:
        //       filter of last property is constraining preceding property (~"which were")

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("starred", "VBD", "star")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("movies", "NNS", "movie")])
                        )
                    ),
                    .withFilter(
                        name: [t("directed", "VBN", "direct")],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("Christopher", "NN", "christopher"),
                                t("Nolan", "NN", "nolan")
                            ])
                        )
                    )
                ])
            ),
            t("who", "WP", "who"),
            t("starred", "VBD", "star"),
            t("in", "IN", "in"),
            t("movies", "NNS", "movie"),
            t("directed", "VBN", "direct"),
            t("by", "IN", "by"),
            t("Christopher", "NN", "christopher"),
            t("Nolan", "NN", "nolan")
        )
    }

    func testQ87() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("country", "NN", "country")]),
                    property: .inverseWithFilter(
                        name: [
                            t("was", "VBD", "be"),
                            t("born", "VBN", "bear"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([t("Obama", "NNP", "obama")]))
                    )
                )
            ),
            t("which", "WDT", "which"),
            t("country", "NN", "country"),
            t("was", "VBD", "be"),
            t("Obama", "NNP", "obama"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in")
        )
    }

    func testQ88() {
        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("country", "NN", "country")]),
                    property: .and([
                        .inverseWithFilter(
                            name: [
                                t("was", "VBD", "be"),
                                t("born", "VBN", "bear"),
                                t("in", "IN", "in")
                            ],
                            filter: .plain(.named([t("Obama", "NNP", "obama")]))
                        ),
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .number([t("1961", "CD", "1961")])
                            )
                        )
                    ])
                )
            ),
            t("which", "WDT", "which"),
            t("country", "NN", "country"),
            t("was", "VBD", "be"),
            t("Obama", "NNP", "obama"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("in", "IN", "in"),
            t("1961", "CD", "1961")
        )
    }

    func testQ89() {
        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("movies", "NNS", "movie")]),
                    .relationship(
                        .named([t("father-in-law", "NN", "father-in-law")]),
                        .named([
                            t("Seth", "NNP", "seth"),
                            t("Gabel", "NNP", "gabel")
                        ]),
                        token: t("'s", "POS", "'s")),
                    token: t("'s", "POS", "'s")
                )
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("some", "DT", "some"),
            t("of", "IN", "of"),
            t("Seth", "NNP", "seth"),
            t("Gabel", "NNP", "gabel"),
            t("'s", "POS", "'s"),
            t("father-in-law", "NN", "father-in-law"),
            t("'s", "POS", "'s"),
            t("movies", "NNS", "movie")
        )
    }

    func testQ90() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("lived", "VBD", "live")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .or([
                            .named([t("Berlin", "NNP", "berlin")]),
                            .named([t("Copenhagen", "NNP", "copenhagen")]),
                            .named([
                                t("New", "NNP", "new"),
                                t("York", "NNP", "york"),
                                t("City", "NNP", "city")
                            ])
                        ])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("lived", "VBD", "live"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin"),
            t(",", ",", ","),
            t("Copenhagen", "NNP", "copenhagen"),
            t(",", ",", ","),
            t("or", "CC", "or"),
            t("New", "NNP", "new"),
            t("York", "NNP", "york"),
            t("City", "NNP", "city")
        )
    }

    func testQ91() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("lived", "VBD", "live")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .and([
                            .named([t("Berlin", "NNP", "berlin")]),
                            .named([t("Copenhagen", "NNP", "copenhagen")]),
                            .named([
                                t("New", "NNP", "new"),
                                t("York", "NNP", "york"),
                                t("City", "NNP", "city")
                            ])
                        ])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("lived", "VBD", "live"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin"),
            t(",", ",", ","),
            t("Copenhagen", "NNP", "copenhagen"),
            t(",", ",", ","),
            t("and", "CC", "and"),
            t("New", "NNP", "new"),
            t("York", "NNP", "york"),
            t("City", "NNP", "city")
        )
    }

    func testQ92() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("lived", "VBD", "live")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .and([
                            .named([t("Berlin", "NNP", "berlin")]),
                            .named([t("Paris", "NNP", "paris")]),
                            .or([
                                .named([t("Copenhagen", "NNP", "copenhagen")]),
                                .named([t("Toronto", "NNP", "toronto")])
                            ]),
                            .named([
                                t("New", "NNP", "new"),
                                t("York", "NNP", "york"),
                                t("City", "NNP", "city")
                            ])
                        ])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("lived", "VBD", "live"),
            t("in", "IN", "in"),
            t("Berlin", "NNP", "berlin"),
            t("and", "CC", "and"),
            t("Paris", "NNP", "paris"),
            t(",", ",", ","),
            t("Copenhagen", "NNP", "copenhagen"),
            t("or", "CC", "or"),
            t("Toronto", "NNP", "toronto"),
            t(",", ",", ","),
            t("and", "CC", "and"),
            t("New", "NNP", "new"),
            t("York", "NNP", "york"),
            t("City", "NNP", "city")
        )
    }

    func testQ93() {
        expectQuestionSuccess(
            .other(.
                withProperty(
                    .named([t("universities", "NNS", "university")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("go", "VBD", "go"),
                            t("to", "TO", "to")
                        ],
                        filter: .plain(.named([t("Obama", "NNP", "obama")]))
                    )
                )
            ),
            t("Which", "WP", "which"),
            t("universities", "NNS", "university"),
            t("did", "VBD", "do"),
            t("Obama", "NNP", "obama"),
            t("go", "VBD", "go"),
            t("to", "TO", "to")
        )
    }

    func testQ94() {
        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("went", "VBD", "go")],
                    filter: .withModifier(
                        modifier: [t("to", "TO", "to")],
                        value: .named([t("Stanford", "NNP", "stanford")])
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("went", "VBD", "go"),
            t("to", "TO", "to"),
            t("Stanford", "NNP", "stanford")
        )
    }
}
