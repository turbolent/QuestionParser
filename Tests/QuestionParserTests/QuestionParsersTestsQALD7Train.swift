
// https://github.com/ag-sc/QALD/blob/aaa6f17149056d6fdd877562c23d4c3894096fe6/7/data/qald-7-train-en-wikidata.json
// Oct 25, 2017
// jq '[.questions[]  |  select (.answertype == "resource" ) | .question[] | select(.language == "en") | .string]'

import XCTest
import SwiftParserCombinators
@testable import QuestionParser

final class QuestionParsersTestsQALD7Train: XCTestCase {

    func testQ1() {

        // Who was the doctoral supervisor of Albert Einstein?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("doctoral", "JJ", "doctoral"),
                        t("supervisor", "NN", "supervisor")
                    ]),
                    .named([
                        t("Albert", "NNP", "albert"),
                        t("Einstein", "NNP", "einstein")
                    ]),
                    token: t("of", "IN", "of"))
            ),
            t("Who", "WP", "who"),
            t("was", "VBD", "be"),
            t("the", "DT", "the"),
            t("doctoral", "JJ", "doctoral"),
            t("supervisor", "NN", "supervisor"),
            t("of", "IN", "of"),
            t("Albert", "NNP", "albert"),
            t("Einstein", "NNP", "einstein"),
            t("?", ".", "?")
        )
    }

    func testQ2() {

        // Who wrote the song Hotel California?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("wrote", "VBD", "write")],
                    filter: .plain(.named([
                        t("the", "DT", "the"),
                        t("song", "NN", "song"),
                        t("Hotel", "NNP", "hotel"),
                        t("California", "NNP", "california")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("wrote", "VBD", "write"),
            t("the", "DT", "the"),
            t("song", "NN", "song"),
            t("Hotel", "NNP", "hotel"),
            t("California", "NNP", "california"),
            t("?", ".", "?")
        )
    }

    func testQ3() {

        // Who was on the Apollo 11 mission?

        // TODO:
//        expectQuestionSuccess(
//            .person(
//                // ...
//            ),
//            t("Who", "WP", "who"),
//            t("was", "VBD", "be"),
//            t("on", "IN", "on"),
//            t("the", "DT", "the"),
//            t("Apollo", "NNP", "apollo"),
//            t("11", "CD", "11"),
//            t("mission", "NN", "mission"),
//            t("?", ".", "?")
//        )
    }

    func testQ4() {

        // Which electronics companies were founded in Beijing?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("electronics", "NNS", "electronic"), t("companies", "NNS", "company")
                    ]),
                    property: .withFilter(
                        name: [
                            t("were", "VBD", "be"),
                            t("founded", "VBN", "found")
                        ],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Beijing", "NNP", "beijing")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("electronics", "NNS", "electronic"),
            t("companies", "NNS", "company"),
            t("were", "VBD", "be"),
            t("founded", "VBN", "found"),
            t("in", "IN", "in"),
            t("Beijing", "NNP", "beijing"),
            t("?", ".", "?")
        )
    }


    func testQ5() {

        // What is in a chocolate chip cookie?

        expectQuestionSuccess(
            .thing(
                .withFilter(
                    name: [t("is", "VBZ", "be")],
                    filter: .withModifier(
                        modifier: [t("in", "IN", "in")],
                        value: .named([
                            t("a", "DT", "a"),
                            t("chocolate", "NN", "chocolate"),
                            t("chip", "NN", "chip"),
                            t("cookie", "NN", "cookie")
                        ])
                    )
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("in", "IN", "in"),
            t("a", "DT", "a"),
            t("chocolate", "NN", "chocolate"),
            t("chip", "NN", "chip"),
            t("cookie", "NN", "cookie"),
            t("?", ".", "?")
        )
    }

    func testQ6() {

        // In which U.S. state is Mount McKinley located?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("U.S.", "NNP", "u.s."),
                        t("state", "NN", "state")
                    ]),
                    property: .inverseWithFilter(
                        name: [
                            t("is", "VBZ", "be"),
                            t("located", "VBN", "locate"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([
                            t("Mount", "NNP", "mount"),
                            t("McKinley", "NNP", "mckinley")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("U.S.", "NNP", "u.s."),
            t("state", "NN", "state"),
            t("is", "VBZ", "be"),
            t("Mount", "NNP", "mount"),
            t("McKinley", "NNP", "mckinley"),
            t("located", "VBN", "locate"),
            t("?", ".", "?")
        )
    }

    func testQ7() {

        // Which Indian company has the most employees?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("Indian", "JJ", "indian"),
                        t("company", "NN", "company")
                    ]),
                    property: .withFilter(
                        name: [t("has", "VBZ", "have")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("most", "JJS", "most"),
                            t("employees", "NNS", "employee")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("Indian", "JJ", "indian"),
            t("company", "NN", "company"),
            t("has", "VBZ", "have"),
            t("the", "DT", "the"),
            t("most", "JJS", "most"),
            t("employees", "NNS", "employee"),
            t("?", ".", "?")
        )
    }

    func testQ8() {

        // In which school did Obama's wife study?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("school", "NN", "school")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("study", "VB", "study"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.relationship(
                            .named([t("wife", "NN", "wife")]),
                            .named([t("Obama", "NNP", "obama")]),
                            token: t("'s", "POS", "'s")
                        ))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("school", "NN", "school"),
            t("did", "VBD", "do"),
            t("Obama", "NNP", "obama"),
            t("'s", "POS", "'s"),
            t("wife", "NN", "wife"),
            t("study", "VB", "study"),
            t("?", ".", "?")
        )
    }

    func testQ9() {

        // TODO:
//        // Where does Piccadilly start?
//
//        expectQuestionSuccess(
//            .other(
//                // ...
//            ),
//            t("Where", "WRB", "where"),
//            t("does", "VBZ", "do"),
//            t("Piccadilly", "NNP", "piccadilly"),
//            t("start", "VB", "start"),
//            t("?", ".", "?")
//        )
    }

    func testQ10() {

        // What is the capital of Cameroon?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("capital", "NN", "capital")
                    ]),
                    .named([t("Cameroon", "NNP", "cameroon")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("capital", "NN", "capital"),
            t("of", "IN", "of"),
            t("Cameroon", "NNP", "cameroon"),
            t("?", ".", "?")
        )
    }

    func testQ11() {

        // Who played Gus Fring in Breaking Bad?

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("played", "VBD", "play")],
                        filter: .plain(.named([
                            t("Gus", "NNP", "gus"),
                            t("Fring", "NNP", "fring")
                        ]))
                    ),
                    .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([
                                t("Breaking", "NNP", "break"),
                                t("Bad", "NNP", "bad")
                            ])
                        )
                    )
                ])
            ),
            t("Who", "WP", "who"),
            t("played", "VBD", "play"),
            t("Gus", "NNP", "gus"),
            t("Fring", "NNP", "fring"),
            t("in", "IN", "in"),
            t("Breaking", "NNP", "break"),
            t("Bad", "NNP", "bad"),
            t("?", ".", "?")
        )
    }

    func testQ12() {
        
        // Who wrote Harry Potter?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("wrote", "VBD", "write")],
                    filter: .plain(.named([
                        t("Harry", "NNP", "harry"),
                        t("Potter", "NNP", "potter")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("wrote", "VBD", "write"),
            t("Harry", "NNP", "harry"),
            t("Potter", "NNP", "potter"),
            t("?", ".", "?")
        )
    }

    func testQ13() {

        // Which actors play in Big Bang Theory?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("actors", "NNS", "actor")]),
                    property: .withFilter(
                        name: [t("play", "VBP", "play")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([
                                t("Big", "NNP", "big"),
                                t("Bang", "NNP", "bang"),
                                t("Theory", "NN", "theory")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("actors", "NNS", "actor"),
            t("play", "VBP", "play"),
            t("in", "IN", "in"),
            t("Big", "NNP", "big"),
            t("Bang", "NNP", "bang"),
            t("Theory", "NN", "theory"),
            t("?", ".", "?")
        )
    }

    func testQ14() {

        // What is the largest country in the world?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("largest", "JJS", "large"),
                        t("country", "NN", "country")
                    ]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([
                                t("the", "DT", "the"),
                                t("world", "NN", "world")
                            ])
                        )
                    )
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("largest", "JJS", "large"),
            t("country", "NN", "country"),
            t("in", "IN", "in"),
            t("the", "DT", "the"),
            t("world", "NN", "world"),
            t("?", ".", "?")
        )
    }

    func testQ15() {

        // Which states border Illinois?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("states", "N", "state")]),
                    property: .withFilter(
                        name: [t("border", "V", "border")],
                        filter: .plain(.named([
                            t("Illinois", "NNP", "illinois")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("states", "N", "state"),
            t("border", "V", "border"),
            t("Illinois", "NNP", "illinois"),
            t("?", ".", "?")
        )
    }

    func testQ16() {

        // Who is the president of Eritrea?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("president", "NN", "president")
                    ]),
                    .named([t("Eritrea", "NNP", "eritrea")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("president", "NN", "president"),
            t("of", "IN", "of"),
            t("Eritrea", "NNP", "eritrea"),
            t("?", ".", "?")
        )
    }

    func testQ17() {

        // Which computer scientist won an oscar?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("computer", "NN", "computer"),
                        t("scientist", "NN", "scientist")
                    ]),
                    property: .withFilter(
                        name: [t("won", "VBD", "win")],
                        filter: .plain(.named([
                            t("an", "DT", "an"),
                            t("oscar", "NN", "oscar")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("computer", "NN", "computer"),
            t("scientist", "NN", "scientist"),
            t("won", "VBD", "win"),
            t("an", "DT", "an"),
            t("oscar", "NN", "oscar"),
            t("?", ".", "?")
        )
    }

    func testQ18() {

        // Who created Family Guy?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("created", "VBD", "create")],
                    filter: .plain(.named([
                        t("Family", "NNP", "family"),
                        t("Guy", "NNP", "guy")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("created", "VBD", "create"),
            t("Family", "NNP", "family"),
            t("Guy", "NNP", "guy"),
            t("?", ".", "?")
        )
    }

    func testQ19() {

        // To which party does the mayor of Paris belong?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("party", "NN", "party")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("belong", "VBP", "belong")
                        ],
                        filter: .plain(
                            .relationship(
                                .named([
                                    t("the", "DT", "the"),
                                    t("mayor", "NN", "mayor")
                                ]),
                                .named([t("Paris", "NNP", "paris")]),
                                token: t("of", "IN", "of")
                            )
                        )
                    )
                )
            ),
            t("To", "TO", "to"),
            t("which", "WDT", "which"),
            t("party", "NN", "party"),
            t("does", "VBZ", "do"),
            t("the", "DT", "the"),
            t("mayor", "NN", "mayor"),
            t("of", "IN", "of"),
            t("Paris", "NNP", "paris"),
            t("belong", "VBP", "belong"),
            t("?", ".", "?")
        )
    }

    func testQ20() {

        // Who does the voice of Bart Simpson?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("does", "VBZ", "do")],
                    filter: .plain(
                        .relationship(
                            .named(
                                [t("the", "DT", "the"),
                                 t("voice", "NN", "voice")
                            ]),
                            .named([
                                t("Bart", "NNP", "bart"),
                                t("Simpson", "NNP", "simpson")
                            ]),
                            token: t("of", "IN", "of")
                        )
                    )
                )
            ),
            t("Who", "WP", "who"),
            t("does", "VBZ", "do"),
            t("the", "DT", "the"),
            t("voice", "NN", "voice"),
            t("of", "IN", "of"),
            t("Bart", "NNP", "bart"),
            t("Simpson", "NNP", "simpson"),
            t("?", ".", "?")
        )
    }

    func testQ21() {

        // Who composed the soundtrack for Cameron's Titanic?

        // TODO: improve

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("composed", "VBD", "compose")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("soundtrack", "NN", "soundtrack")
                        ]))
                    ),
                    .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("for", "IN", "for")],
                            value: .relationship(
                                .named([t("Titanic", "NNP", "titanic")]),
                                .named([t("Cameron", "NNP", "cameron")]),
                                token: t("'s", "POS", "'s")
                            )
                        )
                    )
                ])
            ),
            t("Who", "WP", "who"),
            t("composed", "VBD", "compose"),
            t("the", "DT", "the"),
            t("soundtrack", "NN", "soundtrack"),
            t("for", "IN", "for"),
            t("Cameron", "NNP", "cameron"),
            t("'s", "POS", "'s"),
            t("Titanic", "NNP", "titanic"),
            t("?", ".", "?")
        )
    }

    func testQ22() {

        // Show me all basketball players that are higher than 2 meters.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("basketball", "NN", "basketball"),
                        t("players", "NNS", "player")
                    ]),
                    property: .withFilter(
                        name: [t("are", "VBP", "be")],
                        filter: .withComparativeModifier(
                            modifier: [
                                t("higher", "JJR", "high"),
                                t("than", "IN", "than")
                            ],
                            value: .number(
                                [t("2", "CD", "2")],
                                unit: [t("meters", "NNS", "meter")]
                            )
                        )
                    )
                )
            ),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("basketball", "NN", "basketball"),
            t("players", "NNS", "player"),
            t("that", "WDT", "that"),
            t("are", "VBP", "be"),
            t("higher", "JJR", "high"),
            t("than", "IN", "than"),
            t("2", "CD", "2"),
            t("meters", "NNS", "meter"),
            t(".", ".", ".")
        )
    }

    func testQ23() {

        // What country is Sitecore from?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("country", "NN", "country")]),
                    property: .inverseWithFilter(
                        name: [
                            t("is", "VBZ", "be"),
                            t("from", "IN", "from")
                        ],
                        filter: .plain(.named([t("Sitecore", "NNP", "sitecore")]))
                    )
                )
            ),
            t("What", "WP", "what"),
            t("country", "NN", "country"),
            t("is", "VBZ", "be"),
            t("Sitecore", "NNP", "sitecore"),
            t("from", "IN", "from"),
            t("?", ".", "?")
        )
    }

    func testQ24() {

        // Which country was Bill Gates born in?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("country", "NN", "country")
                    ]),
                    property: .inverseWithFilter(
                        name: [
                            t("was", "VBD", "be"),
                            t("born", "VBN", "bear"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([
                            t("Bill", "NNP", "bill"),
                            t("Gates", "NNP", "gates")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("country", "NN", "country"),
            t("was", "VBD", "be"),
            t("Bill", "NNP", "bill"),
            t("Gates", "NNP", "gates"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("?", ".", "?")
        )
    }

    func testQ25() {

        // Who developed Slack?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("developed", "VBD", "develop")],
                    filter: .plain(.named([
                        t("Slack", "NNP", "slack")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("developed", "VBD", "develop"),
            t("Slack", "NNP", "slack"),
            t("?", ".", "?")
        )
    }

    func testQ26() {

        // In which city did Nikos Kazantzakis die?

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
                            t("Nikos", "NNP", "nikos"),
                            t("Kazantzakis", "NNP", "kazantzakis")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("city", "NN", "city"),
            t("did", "VBD", "do"),
            t("Nikos", "NNP", "nikos"),
            t("Kazantzakis", "NNP", "kazantzakis"),
            t("die", "VB", "die"),
            t("?", ".", "?")
        )
    }

    func testQ27() {

        // Which films did Stanley Kubrick direct?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("films", "NNS", "film")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("direct", "V", "direct")
                        ],
                        filter: .plain(.named([
                            t("Stanley", "NNP", "stanley"),
                            t("Kubrick", "NNP", "kubrick")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("films", "NNS", "film"),
            t("did", "VBD", "do"),
            t("Stanley", "NNP", "stanley"),
            t("Kubrick", "NNP", "kubrick"),
            t("direct", "V", "direct"),
            t("?", ".", "?")
        )
    }

    func testQ28() {

        // Show me all books in Asimov's Foundation series.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("books", "NNS", "book")]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .relationship(
                                .named([
                                    t("Foundation", "NNP", "foundation"),
                                    t("series", "NN", "series")
                                ]),
                                .named([t("Asimov", "NNP", "asimov")]),
                                token: t("'s", "POS", "'s")
                            )
                        )
                    )
                )
            ),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("books", "NNS", "book"),
            t("in", "IN", "in"),
            t("Asimov", "NNP", "asimov"),
            t("'s", "POS", "'s"),
            t("Foundation", "NNP", "foundation"),
            t("series", "NN", "series"),
            t(".", ".", ".")
        )
    }

    func testQ29() {
        // TODO: "both" ... "and" ...
//
//        // Which movies star both Liz Taylor and Richard Burton?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Which", "WDT", "which"),
//            t("movies", "NNS", "movie"),
//            t("star", "VBP", "star"),
//            t("both", "CC", "both"),
//            t("Liz", "NNP", "liz"),
//            t("Taylor", "NNP", "taylor"),
//            t("and", "CC", "and"),
//            t("Richard", "NNP", "richard"),
//            t("Burton", "NNP", "burton"),
//            t("?", ".", "?")
//        )
    }

    func testQ30() {

        // In which city are the headquarters of the United Nations?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("city", "NN", "city")]),
                    property: .inverseWithFilter(
                        name: [
                            t("are", "VBP", "be"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(
                            .relationship(
                                .named([
                                    t("the", "DT", "the"),
                                    t("headquarters", "NN", "headquarters")
                                ]),
                                .named([
                                    t("the", "DT", "the"),
                                    t("United", "NNP", "united"),
                                    t("Nations", "NNP", "nations")
                                ]),
                                token: t("of", "IN", "of")
                            )
                        )
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("city", "NN", "city"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("headquarters", "NN", "headquarters"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("United", "NNP", "united"),
            t("Nations", "NNP", "nations"),
            t("?", ".", "?")
        )
    }

    func testQ31() {

        // In which city was the president of Montenegro born?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("city", "NN", "city")]),
                    property: .inverseWithFilter(
                        name: [
                            t("was", "VBD", "be"),
                            t("born", "VBN", "bear"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(
                            .relationship(
                                .named([
                                    t("the", "DT", "the"),
                                    t("president", "NN", "president")
                                ]),
                                .named([
                                    t("Montenegro", "NNP", "montenegro")
                                ]),
                                token: t("of", "IN", "of")
                            )
                        )
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("city", "NN", "city"),
            t("was", "VBD", "be"),
            t("the", "DT", "the"),
            t("president", "NN", "president"),
            t("of", "IN", "of"),
            t("Montenegro", "NNP", "montenegro"),
            t("born", "VBN", "bear"),
            t("?", ".", "?")
        )
    }

    func testQ32() {

        // Which writers studied in Istanbul?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("writers", "NNS", "writer")]),
                    property: .withFilter(
                        name: [t("studied", "VBN", "study")],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("Istanbul", "NNP", "istanbul")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("writers", "NNS", "writer"),
            t("studied", "VBN", "study"),
            t("in", "IN", "in"),
            t("Istanbul", "NNP", "istanbul"),
            t("?", ".", "?")
        )
    }

    func testQ33() {

        // Who is the mayor of Paris?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("the", "DT", "the"), t("mayor", "NN", "mayor")]),
                    .named([t("Paris", "NNP", "paris")]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("mayor", "NN", "mayor"),
            t("of", "IN", "of"),
            t("Paris", "NNP", "paris"),
            t("?", ".", "?")
        )
    }

    func testQ34() {

        // What is the longest river in China?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("longest", "JJS", "long"),
                        t("river", "NN", "river")
                    ]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("China", "NNP", "china")])
                        )
                    )
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("longest", "JJS", "long"),
            t("river", "NN", "river"),
            t("in", "IN", "in"),
            t("China", "NNP", "china"),
            t("?", ".", "?")
        )
    }

    func testQ35() {

        // Who discovered Ceres?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("discovered", "VBD", "discover")],
                    filter: .plain(.named([t("Ceres", "NNP", "ceres")]))
                )
            ),
            t("Who", "WP", "who"),
            t("discovered", "VBD", "discover"),
            t("Ceres", "NNP", "ceres"),
            t("?", ".", "?")
        )
    }

    func testQ36() {

        // Which presidents were born in 1945?

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
                            modifier: [t("in", "IN", "in")],
                            value: .number([t("1945", "CD", "1945")])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("presidents", "NNS", "president"),
            t("were", "VBD", "be"),
            t("born", "VBN", "bear"),
            t("in", "IN", "in"),
            t("1945", "CD", "1945"),
            t("?", ".", "?")
        )
    }

    func testQ37() {

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

    func testQ38() {

        // What was the first Queen album?

        expectQuestionSuccess(
            .other(
                .named([
                    t("the", "DT", "the"),
                    t("first", "JJ", "first"),
                    t("Queen", "NNP", "queen"),
                    t("album", "NN", "album")
                ])
            ),
            t("What", "WP", "what"),
            t("was", "VBD", "be"),
            t("the", "DT", "the"),
            t("first", "JJ", "first"),
            t("Queen", "NNP", "queen"),
            t("album", "NN", "album"),
            t("?", ".", "?")
        )
    }

    func testQ39() {

        // Give me a list of all Canadians that reside in the U.S.

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("a", "DT", "a"), t("list", "NN", "list")]),
                    .withProperty(
                        .named([
                            t("all", "DT", "all"),
                            t("Canadians", "NNPS", "canadians")
                        ]),
                        property: .withFilter(
                            name: [t("reside", "VBP", "reside")],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .named([
                                    t("the", "DT", "the"),
                                    t("U.S.", "NNP", "u.s.")
                                ])
                            )
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("a", "DT", "a"),
            t("list", "NN", "list"),
            t("of", "IN", "of"),
            t("all", "DT", "all"),
            t("Canadians", "NNPS", "canadians"),
            t("that", "WDT", "that"),
            t("reside", "VBP", "reside"),
            t("in", "IN", "in"),
            t("the", "DT", "the"),
            t("U.S.", "NNP", "u.s.")
        )
    }

    func testQ40() {

        // TODO:
//        // Where is Syngman Rhee buried?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Where", "WRB", "where"),
//            t("is", "VBZ", "be"),
//            t("Syngman", "NNP", "syngman"),
//            t("Rhee", "NNP", "rhee"),
//            t("buried", "VBD", "bury"),
//            t("?", ".", "?")
//        )
    }

    func testQ41() {

        // TODO: improve

        // In which countries do people speak Japanese?

//        expectQuestionSuccess(
//            .other(
//                .withProperty(
//                    .named([t("countries", "NNS", "country")]),
//                    property: .and([
//                        .inverseWithFilter(
//                            name: [
//                                t("do", "VBP", "do"),
//                                t("speak", "VB", "speak")
//                            ],
//                            filter: .plain(.named([t("people", "NNS", "people")]))
//                        ),
//                        .withFilter(
//                            name: [],
//                            filter: .plain(.named([t("Japanese", "NNP", "japanese")]))
//                        )
//                    ])
//                )
//            ),
//            t("In", "IN", "in"),
//            t("which", "WDT", "which"),
//            t("countries", "NNS", "country"),
//            t("do", "VBP", "do"),
//            t("people", "NNS", "people"),
//            t("speak", "VB", "speak"),
//            t("Japanese", "NNP", "japanese"),
//            t("?", ".", "?")
//        )
    }

    func testQ42() {

        // Who is the king of the Netherlands?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("king", "NN", "king")
                    ]),
                    .named([
                        t("the", "DT", "the"),
                        t("Netherlands", "NNP", "netherlands")
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("king", "NN", "king"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("Netherlands", "NNP", "netherlands"),
            t("?", ".", "?")
        )
    }

    func testQ43() {

        // Who produced the most films?

        expectQuestionSuccess(
            .person(
                .withFilter(
                    name: [t("produced", "VBD", "produce")],
                    filter: .plain(.named([
                        t("the", "DT", "the"),
                        t("most", "JJS", "most"),
                        t("films", "NNS", "film")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("produced", "VBD", "produce"),
            t("the", "DT", "the"),
            t("most", "JJS", "most"),
            t("films", "NNS", "film"),
            t("?", ".", "?")
        )
    }

    func testQ44() {

        // Show me all Czech movies.

        expectQuestionSuccess(
            .other(.named([
                t("Czech", "JJ", "czech"),
                t("movies", "NNS", "movie")
            ])),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("Czech", "JJ", "czech"),
            t("movies", "NNS", "movie"),
            t(".", ".", ".")
        )
    }

    func testQ45() {

        // Which rivers flow into the North Sea?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("rivers", "NNS", "river")]),
                    property: .withFilter(
                        name: [t("flow", "VBP", "flow")],
                        filter: .withModifier(
                            modifier: [t("into", "IN", "into")],
                            value: .named([
                                t("the", "DT", "the"),
                                t("North", "NNP", "north"),
                                t("Sea", "NNP", "sea")
                            ])
                        )
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("rivers", "NNS", "river"),
            t("flow", "VBP", "flow"),
            t("into", "IN", "into"),
            t("the", "DT", "the"),
            t("North", "NNP", "north"),
            t("Sea", "NNP", "sea"),
            t("?", ".", "?")
        )
    }

    func testQ46() {

        // TODO:
//        // Where do the Red Sox play?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Where", "WRB", "where"),
//            t("do", "VBP", "do"),
//            t("the", "DT", "the"),
//            t("Red", "NNP", "red"),
//            t("Sox", "NNPS", "sox"),
//            t("play", "NN", "play"),
//            t("?", ".", "?")
//        )
    }

    func testQ47() {

        // In which time zone is Rome?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("time", "NN", "time"),
                        t("zone", "NN", "zone")
                    ]),
                    property: .inverseWithFilter(
                        name: [
                            t("is", "VBZ", "be"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([t("Rome", "NNP", "rome")]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("time", "NN", "time"),
            t("zone", "NN", "zone"),
            t("is", "VBZ", "be"),
            t("Rome", "NNP", "rome"),
            t("?", ".", "?")
        )
    }

    func testQ48() {

        // TODO:
//        // Give me a list of all critically endangered birds.
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Give", "VB", "give"),
//            t("me", "PRP", "-PRON-"),
//            t("a", "DT", "a"),
//            t("list", "NN", "list"),
//            t("of", "IN", "of"),
//            t("all", "DT", "all"),
//            t("critically", "RB", "critically"),
//            t("endangered", "VBN", "endanger"),
//            t("birds", "NNS", "bird"),
//            t(".", ".", ".")
//        )
    }

    func testQ49() {

        // What was the original occupation of the inventor of Lego?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("original", "JJ", "original"),
                        t("occupation", "NN", "occupation")
                    ]),
                    .relationship(
                        .named([
                            t("the", "DT", "the"),
                            t("inventor", "NN", "inventor")
                        ]),
                        .named([t("Lego", "NNP", "lego")]),
                        token: t("of", "IN", "of")
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WP", "what"),
            t("was", "VBD", "be"),
            t("the", "DT", "the"),
            t("original", "JJ", "original"),
            t("occupation", "NN", "occupation"),
            t("of", "IN", "of"),
            t("the", "DT", "the"),
            t("inventor", "NN", "inventor"),
            t("of", "IN", "of"),
            t("Lego", "NNP", "lego"),
            t("?", ".", "?")
        )
    }

    func testQ50() {

        // Which countries have more than ten volcanoes?

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
                                unit: [t("volcanoes", "NNS", "volcano")]
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
            t("volcanoes", "NNS", "volcano"),
            t("?", ".", "?")
        )
    }

    func testQ51() {

        // Show me all U.S. states.

        expectQuestionSuccess(
            .other(.named([
                t("U.S.", "NNP", "u.s."),
                t("states", "NNS", "state")
            ])),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("U.S.", "NNP", "u.s."),
            t("states", "NNS", "state"),
            t(".", ".", ".")
        )
    }

    func testQ52() {

        // TODO: "Game of Thrones" is an entity
//        // Who wrote the Game of Thrones theme?
//
//        expectQuestionSuccess(
//            .person(
//                //
//            ),
//            t("Who", "WP", "who"),
//            t("wrote", "VBD", "write"),
//            t("the", "DT", "the"),
//            t("Game", "NNP", "game"),
//            t("of", "IN", "of"),
//            t("Thrones", "NNPS", "thrones"),
//            t("theme", "NN", "theme"),
//            t("?", ".", "?")
//        )
    }

    func testQ53() {

        // Give me all films produced by Hal Roach.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("films", "NNS", "film")]),
                    property: .withFilter(
                        name: [t("produced", "VBN", "produce")],
                        filter: .withModifier(
                            modifier: [t("by", "IN", "by")],
                            value: .named([
                                t("Hal", "NNP", "hal"),
                                t("Roach", "NNP", "roach")
                            ])
                        )
                    )
                )
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("films", "NNS", "film"),
            t("produced", "VBN", "produce"),
            t("by", "IN", "by"),
            t("Hal", "NNP", "hal"),
            t("Roach", "NNP", "roach"),
            t(".", ".", ".")
        )
    }

    func testQ54() {

        // In which films did Julia Roberts as well as Richard Gere play?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("films", "NNS", "film")]),
                    property: .inverseWithFilter(
                        name: [
                            t("did", "VBD", "do"),
                            t("play", "VB", "play"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(
                            .and([
                                .named([
                                    t("Julia", "NNP", "julia"),
                                    t("Roberts", "NNP", "roberts")
                                ]),
                                .named([
                                    t("Richard", "NNP", "richard"),
                                    t("Gere", "NNP", "gere")
                                ])
                            ])
                        )
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("films", "NNS", "film"),
            t("did", "VBD", "do"),
            t("Julia", "NNP", "julia"),
            t("Roberts", "NNP", "roberts"),
            t("as", "RB", "as"),
            t("well", "RB", "well"),
            t("as", "IN", "as"),
            t("Richard", "NNP", "richard"),
            t("Gere", "NNP", "gere"),
            t("play", "VB", "play"),
            t("?", ".", "?")
        )
    }

    func testQ55() {

        // Show me the book that Muhammad Ali wrote.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("book", "NN", "book")
                    ]),
                    property: .and([
                        .withFilter(
                            name: [],
                            filter: .plain(.named([
                                t("Muhammad", "NNP", "muhammad"),
                                t("Ali", "NNP", "ali")
                            ]))
                        ),
                        .named([t("wrote", "VBD", "write")])
                    ])
                )
            ),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("the", "DT", "the"),
            t("book", "NN", "book"),
            t("that", "WDT", "that"),
            t("Muhammad", "NNP", "muhammad"),
            t("Ali", "NNP", "ali"),
            t("wrote", "VBD", "write"),
            t(".", ".", ".")
        )
    }

    func testQ56() {

        // Which country has the most official languages?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("country", "NN", "country")]),
                    property: .withFilter(
                        name: [t("has", "VBZ", "have")],
                        filter: .plain(.named([
                            t("the", "DT", "the"),
                            t("most", "RBS", "most"),
                            t("official", "JJ", "official"),
                            t("languages", "NNS", "language")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("country", "NN", "country"),
            t("has", "VBZ", "have"),
            t("the", "DT", "the"),
            t("most", "RBS", "most"),
            t("official", "JJ", "official"),
            t("languages", "NNS", "language"),
            t("?", ".", "?")
        )
    }

    func testQ57() {

        // TODO:
//        // How did Michael Jackson die?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("How", "WRB", "how"),
//            t("did", "VBD", "do"),
//            t("Michael", "NNP", "michael"),
//            t("Jackson", "NNP", "jackson"),
//            t("die", "VB", "die"),
//            t("?", ".", "?")
//        )
    }

    func testQ58() {

        // TODO:

        // Which space probes were sent into orbit around the sun?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("space", "NN", "space"),
                        t("probes", "NNS", "probe")]
                    ),
                    property: .and([
                        .withFilter(
                            name: [
                                t("were", "VBD", "be"),
                                t("sent", "VBN", "send")
                            ],
                            filter: .withModifier(
                                modifier: [t("into", "IN", "into")],
                                value: .named([t("orbit", "NN", "orbit")])
                            )
                        ),
                        .withFilter(
                            name: [],
                            filter: .withModifier(
                                modifier: [t("around", "IN", "around")],
                                value: .named([
                                    t("the", "DT", "the"),
                                    t("sun", "NN", "sun")
                                ])
                            )
                        )
                    ])
                )
            ),
            t("Which", "WDT", "which"),
            t("space", "NN", "space"),
            t("probes", "NNS", "probe"),
            t("were", "VBD", "be"),
            t("sent", "VBN", "send"),
            t("into", "IN", "into"),
            t("orbit", "NN", "orbit"),
            t("around", "IN", "around"),
            t("the", "DT", "the"),
            t("sun", "NN", "sun"),
            t("?", ".", "?")
        )
    }

    func testQ59() {

        // TODO: improve

        // Who produced films starring Natalie Portman?

        expectQuestionSuccess(
            .person(
                .and([
                    .withFilter(
                        name: [t("produced", "VBD", "produce")],
                        filter: .plain(.named([t("films", "NNS", "film")]))),
                    .withFilter(
                        name: [t("starring", "VBG", "star")],
                        filter: .plain(.named([
                            t("Natalie", "NNP", "natalie"),
                            t("Portman", "NNP", "portman")
                        ]))
                    )
                ])
            ),
            t("Who", "WP", "who"),
            t("produced", "VBD", "produce"),
            t("films", "NNS", "film"),
            t("starring", "VBG", "star"),
            t("Natalie", "NNP", "natalie"),
            t("Portman", "NNP", "portman"),
            t("?", ".", "?")
        )
    }

    func testQ60() {

        // What is the biggest stadium in Spain?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([
                        t("the", "DT", "the"),
                        t("biggest", "JJS", "big"),
                        t("stadium", "NN", "stadium")
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
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("biggest", "JJS", "big"),
            t("stadium", "NN", "stadium"),
            t("in", "IN", "in"),
            t("Spain", "NNP", "spain"),
            t("?", ".", "?")
        )
    }

    func testQ61() {

        // On which day is Columbus Day?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("day", "NN", "day")]),
                    property: .inverseWithFilter(
                        name: [
                            t("is", "VBZ", "be"),
                            t("on", "IN", "on")
                        ],
                        filter: .plain(.named([
                            t("Columbus", "NNP", "columbus"),
                            t("Day", "NNP", "day")
                        ]))
                    )
                )
            ),
            t("On", "IN", "on"),
            t("which", "WDT", "which"),
            t("day", "NN", "day"),
            t("is", "VBZ", "be"),
            t("Columbus", "NNP", "columbus"),
            t("Day", "NNP", "day"),
            t("?", ".", "?")
        )
    }

    func testQ62() {

        // TODO:
//        // How short is the shortest active NBA player?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("How", "WRB", "how"),
//            t("short", "JJ", "short"),
//            t("is", "VBZ", "be"),
//            t("the", "DT", "the"),
//            t("shortest", "RBS", "shortest"),
//            t("active", "JJ", "active"),
//            t("NBA", "NNP", "nba"),
//            t("player", "NN", "player"),
//            t("?", ".", "?")
//        )
    }

    func testQ63() {

        // TODO:
//        // Whom did Lance Bass marry?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Whom", "WP", "whom"),
//            t("did", "VBD", "do"),
//            t("Lance", "NNP", "lance"),
//            t("Bass", "NNP", "bass"),
//            t("marry", "VB", "marry"),
//            t("?", ".", "?")
//        )
    }

    func testQ64() {

        // TODO: improve. "form of government"

        // What form of government does Russia have?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("form", "NN", "form")]),
                    .withProperty(
                        .named([t("government", "NN", "government")]),
                        property: .inverseWithFilter(
                            name: [t("does", "VBZ", "do"), t("have", "VB", "have")],
                            filter: .plain(.named([t("Russia", "NNP", "russia")]))
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WDT", "what"),
            t("form", "NN", "form"),
            t("of", "IN", "of"),
            t("government", "NN", "government"),
            t("does", "VBZ", "do"),
            t("Russia", "NNP", "russia"),
            t("have", "VB", "have"),
            t("?", ".", "?")
        )
    }

    func testQ65() {

        // What movies does Jesse Eisenberg play in?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("movies", "NNS", "movie")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("play", "VB", "play"),
                            t("in", "RP", "in")
                        ],
                        filter: .plain(.named([
                            t("Jesse", "NNP", "jesse"),
                            t("Eisenberg", "NNP", "eisenberg")
                        ]))
                    )
                )
            ),
            t("What", "WDT", "what"),
            t("movies", "NNS", "movie"),
            t("does", "VBZ", "do"),
            t("Jesse", "NNP", "jesse"),
            t("Eisenberg", "NNP", "eisenberg"),
            t("play", "VB", "play"),
            t("in", "RP", "in"),
            t("?", ".", "?")
        )
    }

    func testQ66() {

        // Give me all soccer clubs in the Premier League.

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
                            value: .named([
                                t("the", "DT", "the"),
                                t("Premier", "NNP", "premier"),
                                t("League", "NNP", "league")
                            ])
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
            t("the", "DT", "the"),
            t("Premier", "NNP", "premier"),
            t("League", "NNP", "league"),
            t(".", ".", ".")
        )
    }

    func testQ67() {

        // Show me all museums in London.

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("museums", "NNS", "museum")]),
                    property: .withFilter(
                        name: [],
                        filter: .withModifier(
                            modifier: [t("in", "IN", "in")],
                            value: .named([t("London", "NNP", "london")])
                        )
                    )
                )
            ),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("museums", "NNS", "museum"),
            t("in", "IN", "in"),
            t("London", "NNP", "london"),
            t(".", ".", ".")
        )
    }

    func testQ68() {

        // Give me all South American countries.

        expectQuestionSuccess(
            .other(
                .named([
                    t("South", "JJ", "south"),
                    t("American", "JJ", "american"),
                    t("countries", "NNS", "country")
                ])
            ),
            t("Give", "VB", "give"),
            t("me", "PRP", "-PRON-"),
            t("all", "DT", "all"),
            t("South", "JJ", "south"),
            t("American", "JJ", "american"),
            t("countries", "NNS", "country"),
            t(".", ".", ".")
        )
    }

    func testQ69() {

        // Which pope succeeded John Paul II?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("pope", "NN", "pope")]),
                    property: .withFilter(
                        name: [t("succeeded", "VBD", "succeed")],
                        filter: .plain(.named([
                            t("John", "NNP", "john"),
                            t("Paul", "NNP", "paul"),
                            t("II", "NNP", "ii")
                        ]))
                    )
                )
            ),
            t("Which", "WDT", "which"),
            t("pope", "NN", "pope"),
            t("succeeded", "VBD", "succeed"),
            t("John", "NNP", "john"),
            t("Paul", "NNP", "paul"),
            t("II", "NNP", "ii"),
            t("?", ".", "?")
        )
    }

    func testQ70() {

        // Who is the son of Sonny and Cher?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([
                        t("the", "DT", "the"),
                        t("son", "NN", "son")
                    ]),
                    .and([
                        .named([t("Sonny", "NNP", "sonny")]),
                        .named([t("Cher", "NNP", "cher")])
                    ]),
                    token: t("of", "IN", "of")
                )
            ),
            t("Who", "WP", "who"),
            t("is", "VBZ", "be"),
            t("the", "DT", "the"),
            t("son", "NN", "son"),
            t("of", "IN", "of"),
            t("Sonny", "NNP", "sonny"),
            t("and", "CC", "and"),
            t("Cher", "NNP", "cher"),
            t("?", ".", "?")
        )
    }

    func testQ71() {

        // TODO:
//        // What are the five boroughs of New York?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("What", "WP", "what"),
//            t("are", "VBP", "be"),
//            t("the", "DT", "the"),
//            t("five", "CD", "five"),
//            t("boroughs", "NNS", "borough"),
//            t("of", "IN", "of"),
//            t("New", "NNP", "new"),
//            t("York", "NNP", "york"),
//            t("?", ".", "?")
//        )
    }

    func testQ72() {

        // Show me Hemingway's autobiography.

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("autobiography", "NN", "autobiography")]),
                    .named([t("Hemingway", "NNP", "hemingway")]),
                    token: t("\'s", "POS", "\'s")
                )
            ),
            t("Show", "VB", "show"),
            t("me", "PRP", "-PRON-"),
            t("Hemingway", "NNP", "hemingway"),
            t("'s", "POS", "'s"),
            t("autobiography", "NN", "autobiography"),
            t(".", ".", ".")
        )
    }

    func testQ73() {

        // TODO: improve. "kind of music"

        // What kind of music did Lou Reed play?

        expectQuestionSuccess(
            .other(
                .relationship(
                    .named([t("kind", "NN", "kind")]),
                    .withProperty(
                        .named([t("music", "NN", "music")]),
                        property: .inverseWithFilter(
                            name: [
                                t("did", "VBD", "do"),
                                t("play", "VB", "play")
                            ],
                            filter: .plain(.named([
                                t("Lou", "NNP", "lou"),
                                t("Reed", "NNP", "reed")
                            ]))
                        )
                    ),
                    token: t("of", "IN", "of")
                )
            ),
            t("What", "WDT", "what"),
            t("kind", "NN", "kind"),
            t("of", "IN", "of"),
            t("music", "NN", "music"),
            t("did", "VBD", "do"),
            t("Lou", "NNP", "lou"),
            t("Reed", "NNP", "reed"),
            t("play", "VB", "play"),
            t("?", ".", "?")
        )
    }

    func testQ74() {

        // In which city does Sylvester Stallone live?

        expectQuestionSuccess(
            .other(
                .withProperty(
                    .named([t("city", "NN", "city")]),
                    property: .inverseWithFilter(
                        name: [
                            t("does", "VBZ", "do"),
                            t("live", "VB", "live"),
                            t("in", "IN", "in")
                        ],
                        filter: .plain(.named([
                            t("Sylvester", "NNP", "sylvester"),
                            t("Stallone", "NNP", "stallone")
                        ]))
                    )
                )
            ),
            t("In", "IN", "in"),
            t("which", "WDT", "which"),
            t("city", "NN", "city"),
            t("does", "VBZ", "do"),
            t("Sylvester", "NNP", "sylvester"),
            t("Stallone", "NNP", "stallone"),
            t("live", "VB", "live"),
            t("?", ".", "?")
        )
    }

    func testQ75() {

        // Who was Vincent van Gogh inspired by?

        expectQuestionSuccess(
            .person(
                .inverseWithFilter(
                    name: [
                        t("was", "VBD", "be"),
                        t("inspired", "VBN", "inspire"),
                        t("by", "IN", "by")
                    ],
                    filter: .plain(.named([
                        t("Vincent", "NNP", "vincent"),
                        t("van", "NNP", "van"),
                        t("Gogh", "NNP", "gogh")
                    ]))
                )
            ),
            t("Who", "WP", "who"),
            t("was", "VBD", "be"),
            t("Vincent", "NNP", "vincent"),
            t("van", "NNP", "van"),
            t("Gogh", "NNP", "gogh"),
            t("inspired", "VBN", "inspire"),
            t("by", "IN", "by"),
            t("?", ".", "?")
        )
    }

    func testQ76() {

        // What are the zodiac signs?

        expectQuestionSuccess(
            .other(
                .named([
                    t("the", "DT", "the"),
                    t("zodiac", "NN", "zodiac"),
                    t("signs", "NNS", "sign")
                ])
            ),
            t("What", "WP", "what"),
            t("are", "VBP", "be"),
            t("the", "DT", "the"),
            t("zodiac", "NN", "zodiac"),
            t("signs", "NNS", "sign"),
            t("?", ".", "?")
        )
    }

    func testQ77() {

        // TODO:
//        // What languages do they speak in Pakistan?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("What", "WDT", "what"),
//            t("languages", "NNS", "language"),
//            t("do", "VBP", "do"),
//            t("they", "PRP", "-PRON-"),
//            t("speak", "VB", "speak"),
//            t("in", "IN", "in"),
//            t("Pakistan", "NNP", "pakistan"),
//            t("?", ".", "?")
//        )
    }

    func testQ78() {

        // TODO:
//        // Who became president after JFK died?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("Who", "WP", "who"),
//            t("became", "VBD", "become"),
//            t("president", "NN", "president"),
//            t("after", "IN", "after"),
//            t("JFK", "NNP", "jfk"),
//            t("died", "VBD", "die"),
//            t("?", ".", "?")
//        )
    }

    func testQ79() {

        // TODO: inverse

//        // In what city is the Heineken brewery?
//
//        expectQuestionSuccess(
//            .other(.named([])),
//            t("In", "IN", "in"),
//            t("what", "WP", "what"),
//            t("city", "NN", "city"),
//            t("is", "VBZ", "be"),
//            t("the", "DT", "the"),
//            t("Heineken", "NNP", "heineken"),
//            t("brewery", "NN", "brewery"),
//            t("?", ".", "?")
//        )
    }

    func testQ80() {

        // What is Elon Musk famous for?

        expectQuestionSuccess(
            .thing(
                .inverseWithFilter(
                    name: [
                        t("is", "VBZ", "be"),
                        t("famous", "JJ", "famous"),
                        t("for", "IN", "for")
                    ],
                    filter: .plain(.named([
                        t("Elon", "NNP", "elon"),
                        t("Musk", "NNP", "musk")
                    ]))
                )
            ),
            t("What", "WP", "what"),
            t("is", "VBZ", "be"),
            t("Elon", "NNP", "elon"),
            t("Musk", "NNP", "musk"),
            t("famous", "JJ", "famous"),
            t("for", "IN", "for"),
            t("?", ".", "?")
        )
    }
}

