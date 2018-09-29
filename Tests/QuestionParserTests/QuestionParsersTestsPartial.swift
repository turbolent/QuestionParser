import XCTest
import SwiftParserCombinators
@testable import QuestionParser

final class QuestionParsersTestsPartial: XCTestCase {

    func testWhichWhat() {
        let p = QuestionParsers.whichWhat

        expectSuccess(p, Unit.empty,
                      t("which", "WDT", "which"))

        expectSuccess(p, Unit.empty,
                      t("what", "WDT", "what"))

        expectSuccess(p, Unit.empty,
                      t("in", "IN", "in"),
                      t("what", "WDT", "what"))
    }

    func testWhoWhatBe() {
        let p = QuestionParsers.whoWhatBe

        expectSuccess(p, Unit.empty,
                      t("who", "WP", "who"),
                      t("is", "V", "be"))

        expectSuccess(p, Unit.empty,
                      t("what", "WDT", "what"),
                      t("are", "V", "be"))

        expectSuccess(p, Unit.empty,
                      t("who", "WP", "who"),
                      t("were", "V", "be"))
    }

    func testFindListGiveShow() {
        let p = QuestionParsers.findListGiveShow

        expectSuccess(p, Unit.empty,
                      t("find", "V", "find"))

        expectSuccess(p, Unit.empty,
                      t("list", "V", "list"))

        expectSuccess(p, Unit.empty,
                      t("show", "V", "show"),
                      t("me", "PRP", ""))
    }

    func testSomeAllAny() {
        let p = QuestionParsers.someAllAny

        expectSuccess(p, Unit.empty,
                      t("all", "DT", "all"))

        expectSuccess(p, Unit.empty,
                      t("some", "DT", "some"),
                      t("of", "IN", "of"))

        expectSuccess(p, Unit.empty,
                      t("a", "DT", "a"),
                      t("couple", "NN", "couple"))
    }

    func testNamedValue() {
        let p = QuestionParsers.namedValue

        expectSuccess(p,
                      .named([
                          t("Europe", "NNP", "europe")
                      ]),
                      t("Europe", "NNP", "europe"))

        expectSuccess(p,
                      .named([
                          t("people", "NNS", "people")
                      ]),
                      t("people", "NNS", "people"))

        expectSuccess(p,
                      .named([
                          t("the", "DT", "the"),
                          t("US", "NNP", "us")
                      ]),
                      t("the", "DT", "the"),
                      t("US", "NNP", "us"))

        expectSuccess(p,
                      .named([
                          t("green", "JJ", "green"),
                          t("paintings", "NNS", "painting")
                      ]),
                      t("green", "JJ", "green"),
                      t("paintings", "NNS", "painting"))

        expectSuccess(p,
                      .named([
                          t("the", "DT", "the"),
                          t("19th", "JJ", "19th"),
                          t("century", "NN", "century")
                      ]),
                      t("the", "DT", "the"),
                      t("19th", "JJ", "19th"),
                      t("century", "NN", "century"))
    }

    func testNumericValue() {
        let p = QuestionParsers.numericValue

        expectSuccess(p,
                      .number([
                          t("100", "CD", "100")
                      ]),
                      t("100", "CD", "100"))

        expectSuccess(p,
                      .number([
                          t("thousand", "CD", "thousand")
                      ]),
                      t("thousand", "CD", "thousand"))

        expectSuccess(p,
                      .number([
                          t("1", "CD", "1"),
                          t("million", "CD", "million")
                      ]),
                      t("1", "CD", "1"),
                      t("million", "CD", "million"))

        expectSuccess(p,
                      .number(
                          [
                              t("42", "CD", "42")
                          ],
                          unit: [
                              t("meters", "NNS", "meter")
                          ]),
                      t("42", "CD", "42"),
                      t("meters", "NNS", "meter"))

        expectSuccess(p,
                      .number(
                          [
                            t("2", "CD", "2"),
                            t("million", "CD", "million")
                          ],
                          unit: [
                            t("inhabitants", "NNS", "inhabitant")
                          ]),
                      t("2", "CD", "2"),
                      t("million", "CD", "million"),
                      t("inhabitants", "NNS", "inhabitant"))
    }

    func testNamedValues() {
        let p = QuestionParsers.namedValues

        expectSuccess(p,
                      .relationship(
                          .named([t("mothers", "NNS", "mother")]),
                          .relationship(
                              .named([t("children", "NNS", "child")]),
                              .named([t("Obama", "NNP", "obama")]),
                              token: t("'s", "POS", "'s")
                          ),
                          token: t("'s", "POS", "'s")
                      ),
                      t("Obama", "NNP", "obama"),
                      t("'s", "POS", "'s"),
                      t("children", "NNS", "child"),
                      t("'s", "POS", "'s"),
                      t("mothers", "NNS", "mother"))
    }

    func testFilter() {
        let p = QuestionParsers.filter

        expectSuccess(p,
                      .withModifier(
                          modifier: [t("before", "IN", "before")],
                          value: .number([t("1900", "CD", "1900")])
                      ),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"))

        expectSuccess(p,
                      .withModifier(
                          modifier: [t("in", "IN", "in")],
                          value: .named([t("Europe", "NNP", "europe")])
                      ),
                      t("in", "IN", "in"),
                      t("Europe", "NNP", "europe"))

        expectSuccess(p,
                      .withComparativeModifier(
                          modifier: [
                              t("larger", "JJR", "larger"),
                              t("than", "IN", "than")
                          ],
                          value: .named([t("Europe", "NNP", "europe")])
                      ),
                      t("larger", "JJR", "larger"),
                      t("than", "IN", "than"),
                      t("Europe", "NNP", "europe"))

        expectSuccess(p,
                      .withComparativeModifier(
                          modifier: [
                              t("larger", "JJR", "larger"),
                              t("than", "IN", "than")
                          ],
                          value: .and([
                              .named([t("Europe", "NNP", "europe")]),
                              .named([
                                  t("the", "DT", "the"),
                                  t("US", "NNP", "us")
                              ])
                          ])
                      ),
                      t("larger", "JJR", "larger"),
                      t("than", "IN", "than"),
                      t("Europe", "NNP", "europe"),
                      t("and", "CC", "and"),
                      t("the", "DT", "the"),
                      t("US", "NNP", "us"))
    }

    func testFilters() {
        let p = QuestionParsers.filters

        expectSuccess(p,
                      .withModifier(
                          modifier: [t("before", "IN", "before")],
                          value: .number([t("1900", "CD", "1900")])
                      ),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"))

        expectSuccess(p,
                      .or([
                          .withModifier(
                              modifier: [t("before", "IN", "before")],
                              value: .number([t("1900", "CD", "1900")])
                          ),
                          .withModifier(
                              modifier: [t("after", "IN", "after")],
                              value: .number([t("1910", "CD", "1910")])
                          )
                      ]),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"),
                      t("or", "CC", "or"),
                      t("after", "IN", "after"),
                      t("1910", "CD", "1910"))
    }

    func testProperty() {
        let p = QuestionParsers.property

        expectSuccess(p,
                      .named([t("died", "VBD", "die")]),
                      t("died", "VBD", "die"))

        expectSuccess(p,
                      .withFilter(
                          name: [t("died", "VBD", "die")],
                          filter: .or([
                              .withModifier(
                                  modifier: [t("before", "IN", "before")],
                                  value: .number([t("1900", "CD", "1900")])
                              ),
                              .withModifier(
                                  modifier: [t("after", "IN", "after")],
                                  value: .number([t("1910", "CD", "1910")])
                              )
                          ])
                      ),
                      t("died", "VBD", "die"),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"),
                      t("or", "CC", "or"),
                      t("after", "IN", "after"),
                      t("1910", "CD", "1910"))

        expectSuccess(p,
                      .withFilter(
                          name: [],
                          filter: .withModifier(
                              modifier: [t("by", "IN", "by")],
                              value: .named([
                                  t("George", "NNP", "george"),
                                  t("Orwell", "NNP", "orwell")
                              ])
                          )
                      ),
                      t("by", "IN", "by"),
                      t("George", "NNP", "george"),
                      t("Orwell", "NNP", "orwell"))

        expectSuccess(p,
                      .inverseWithFilter(
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
                      ),
                      t("did", "VBD", "do"),
                      t("George", "NNP", "george"),
                      t("Orwell", "NNP", "orwell"),
                      t("write", "VB", "write"))

        expectSuccess(p,
                      .inverseWithFilter(
                          name: [
                              t("did", "VBD", "do"),
                              t("star", "VB", "star"),
                              t("in", "IN", "in")
                          ],
                          filter: .plain(
                            .named([
                                t("Obama", "NNP", "obama")
                            ])
                          )
                      ),
                      t("did", "VBD", "do"),
                      t("Obama", "NNP", "obama"),
                      t("star", "VB", "star"),
                      t("in", "IN", "in"))
    }

    func testProperties() {
        let p = QuestionParsers.properties

        expectSuccess(p,
                      .or([
                          .withFilter(
                            name: [t("died", "VBD", "die")],
                            filter: .or([
                                .withModifier(
                                    modifier: [t("before", "IN", "before")],
                                    value: .number([t("1900", "CD", "1900")])
                                ),
                                .withModifier(
                                    modifier: [t("after", "IN", "after")],
                                    value: .number([t("1910", "CD", "1910")])
                                )
                            ])
                          ),
                          .withFilter(
                            name: [
                                t("were", "VBD", "be"),
                                t("born", "VBN", "bear")
                            ],
                            filter: .withModifier(
                                modifier: [t("in", "IN", "in")],
                                value: .number([t("1923", "CD", "1923")])
                            )
                          )
                      ]),
                      t("died", "VBD", "die"),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"),
                      t("or", "CC", "or"),
                      t("after", "IN", "after"),
                      t("1910", "CD", "1910"),
                      t("or", "CC", "or"),
                      t("were", "VBD", "be"),
                      t("born", "VBN", "bear"),
                      t("in", "IN", "in"),
                      t("1923", "CD", "1923"))

        expectSuccess(p,
                      .and([
                          .withFilter(
                              name: [t("written", "VBN", "write")],
                              filter: .withModifier(
                                  modifier: [t("by", "IN", "by")],
                                  value: .named([t("Orwell", "NNP", "orwell")])
                              )
                          ),
                          .withFilter(
                              name: [t("were", "VBD", "be")],
                              filter: .withComparativeModifier(
                                  modifier: [
                                      t("longer", "JJR", "long"),
                                      t("than", "IN", "than")
                                  ],
                                  value: .number(
                                      [t("200", "CD", "200")],
                                      unit: [t("pages", "NNS", "page")]
                                  )
                              )
                          )
                      ]),
                      t("written", "VBN", "write"),
                      t("by", "IN", "by"),
                      t("Orwell", "NNP", "orwell"),
                      t("were", "VBD", "be"),
                      t("longer", "JJR", "long"),
                      t("than", "IN", "than"),
                      t("200", "CD", "200"),
                      t("pages", "NNS", "page"))
    }

    func testNamedQuery() {
        let p = QuestionParsers.namedQuery

        expectSuccess(p,
                      .named([
                          t("youngest", "JJS", "young"),
                          t("children", "NNS", "child")
                      ]),
                      t("youngest", "JJS", "young"),
                      t("children", "NNS", "child"))


        expectSuccess(p,
                      .named([
                          t("the", "DT", "the"),
                          t("largest", "JJS", "large"),
                          t("cities", "NNS", "city")
                      ]),
                      t("the", "DT", "the"),
                      t("largest", "JJS", "large"),
                      t("cities", "NNS", "city"))

        expectSuccess(p,
                      .named([
                          t("main", "JJ", "main"),
                          t("actor", "NN", "actor")
                      ]),
                      t("main", "JJ", "main"),
                      t("actor", "NN", "actor"))
    }

    func testQueries() {
        let p = QuestionParsers.queries

        expectSuccess(p,
                      .and([
                          .named([t("children", "NNS", "child")]),
                          .named([t("grandchildren", "NNS", "grandchild")])
                      ]),
                      t("children", "NNS", "child"),
                      t("and", "CC", "and"),
                      t("grandchildren", "NNS", "grandchild"))

        expectSuccess(p,
                      .and([
                          .named([t("China", "NNP", "china")]),
                          .named([
                              t("the", "DT", "the"),
                              t("USA", "NNP", "usa")
                          ]),
                          .named([t("Japan", "NNP", "japan")])
                      ]),
                      t("China", "NNP", "china"),
                      t(",", ",", ","),
                      t("the", "DT", "the"),
                      t("USA", "NNP", "usa"),
                      t(",", ",", ","),
                      t("and", "CC", "and"),
                      t("Japan", "NNP", "japan"))
    }

    func testQueryRelationships() {
        let p = QuestionParsers.queryRelationships

        expectSuccess(p,
                      .named([t("Clinton", "NNP", "clinton")]),
                      t("Clinton", "NNP", "clinton"))

        expectSuccess(p,
                      .relationship(
                          .named([t("children", "NNS", "child")]),
                          .named([t("Clinton", "NNP", "clinton")]),
                          token: t("'s", "POS", "'s")
                      ),
                      t("Clinton", "NNP", "clinton"),
                      t("'s", "POS", "'s"),
                      t("children", "NNS", "child"))

        expectSuccess(p,
                      .relationship(
                          .named([
                              t("population", "NN", "population"),
                              t("sizes", "NNS", "size")
                          ]),
                          .relationship(
                              .named([t("cities", "NNS", "city")]),
                              .named([t("California", "NNP", "california")]),
                              token: t("'s", "POS", "'s")
                          ),
                          token: t("'", "POS", "'")
                      ),
                      t("California", "NNP", "california"),
                      t("'s", "POS", "'s"),
                      t("cities", "NNS", "city"),
                      t("'", "POS", "'"),
                      t("population", "NN", "population"),
                      t("sizes", "NNS", "size"))

        expectSuccess(p,
                      .relationship(
                        .and([
                            .named([t("children", "NNS", "child")]),
                            .named([t("grandchildren", "NNS", "grandchild")])
                        ]),
                        .named([t("Clinton", "NNP", "clinton")]),
                        token: t("'s", "POS", "'s")
                      ),
                      t("Clinton", "NNP", "clinton"),
                      t("'s", "POS", "'s"),
                      t("children", "NNS", "child"),
                      t("and", "CC", "and"),
                      t("grandchildren", "NNS", "grandchild"))

    }

    func testFullQuery() {
        let p = QuestionParsers.fullQuery

        expectSuccess(p,
                      .named([t("people", "NNS", "people")]),
                      t("people", "NNS", "people"))

        expectSuccess(p,
                      .named([t("engineers", "NNS", "engineer")]),
                      t("engineers", "NNS", "engineer"),
                      t("which", "WDT", "which"))

        expectSuccess(p,
                      .named([
                          t("largest", "JJS", "large"),
                          t("cities", "NNS", "city")
                      ]),
                      t("largest", "JJS", "large"),
                      t("cities", "NNS", "city"),
                      t("that", "WDT", "that"))

        expectSuccess(p,
                      .relationship(
                          .named([t("cities", "NNS", "city")]),
                          .named([t("California", "NNP", "california")]),
                          token: t("of", "IN", "of")
                      ),
                      t("cities", "NNS", "city"),
                      t("of", "IN", "of"),
                      t("California", "NNP", "california"))

         expectSuccess(p,
                      .relationship(
                          .named([t("cities", "NNS", "city")]),
                          .named([t("California", "NNP", "california")]),
                          token: t("'s", "POS", "'s")
                      ),
                      t("California", "NNP", "california"),
                      t("'s","POS","'s"),
                      t("cities", "NNS", "city"))

        expectSuccess(p,
                      .relationship(
                          .named([t("population", "NN", "population")]),
                          .named([
                              t("the", "DT", "the"),
                              t("USA", "NNP", "usa")
                          ]),
                          token: t("of", "IN", "of")
                      ),
                      t("population", "NN", "population"),
                      t("of", "IN", "of"),
                      t("the", "DT", "the"),
                      t("USA", "NNP", "usa"))

        expectSuccess(p,
                      .withProperty(
                          .named([t("actors", "NNS", "actor")]),
                          property: .withFilter(
                              name: [t("died", "VBD", "die")],
                              filter: .withModifier(
                                  modifier: [t("in", "IN", "in")],
                                  value: .named([t("Berlin", "NNP", "berlin")])
                              )
                          )
                      ),
                      t("actors", "NNS", "actor"),
                      t("that", "WDT", "that"),
                      t("died", "VBD", "die"),
                      t("in", "IN", "in"),
                      t("Berlin", "NNP", "berlin"))

    }

    func testListQuestionStart() {
        let p = QuestionParsers.listQuestionStart

        expectSuccess(p,
                      Unit.empty,
                      t("which", "WDT", "which"))

        expectSuccess(p,
                      Unit.empty,
                      t("what", "WP", "are"),
                      t("are", "VBP", "be"))

        expectSuccess(p,
                      Unit.empty,
                      t("find", "VB", "find"),
                      t("all", "DT", "all"))

        expectSuccess(p,
                      Unit.empty,
                      t("find", "VB", "find"),
                      t("all", "DT", "all"))

        expectSuccess(p,
                      Unit.empty,
                      t("give", "VB", "give"),
                      t("me", "PRP", "-PRON-"),
                      t("a", "DT", "a"),
                      t("few", "JJ", "few"))
    }

    func testListQuestion() {
        let p = QuestionParsers.listQuestion

        expectSuccess(p,
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
                      t("which", "WDT", "which"),
                      t("presidents", "NNS", "president"),
                      t("were", "VBD", "be"),
                      t("born", "VBN", "bear"),
                      t("before", "IN", "before"),
                      t("1900", "CD", "1900"))

        expectSuccess(p,
                      .other(
                          .withProperty(
                              .named([t("actors", "NNS", "actor")]),
                              property: .withFilter(
                                  name: [t("born", "VBN", "bear")],
                                  filter: .withModifier(
                                      modifier: [t("in", "IN", "in")],
                                      value: .and([
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
                      t("give", "VB", "give"),
                      t("me", "PRP", "-PRON-"),
                      t("all", "DT", "all"),
                      t("actors", "NNS", "actor"),
                      t("born", "VBN", "bear"),
                      t("in", "IN", "in"),
                      t("Berlin", "NNP", "berlin"),
                      t("and", "CC", "and"),
                      t("San", "NNP", "san"),
                      t("Francisco", "NNP", "francisco"))
    }

    func testPersonQuestion() {
        let p = QuestionParsers.personQuestion

        expectSuccess(p,
                      .person(
                          .withFilter(
                              name: [t("died", "VBD", "die")],
                              filter: .withModifier(
                                  modifier: [t("in", "IN", "in")],
                                  value: .number([t("1900", "CD", "1900")])
                              )
                          )
                      ),
                      t("who", "WP", "who"),
                      t("died", "VBD", "die"),
                      t("in", "IN", "in"),
                      t("1900", "CD", "1900"))

        expectSuccess(p,
                      .person(
                          .and([
                              .withFilter(
                                  name: [
                                      t("was", "VBD", "be"),
                                      t("born", "VBN", "bear")
                                  ],
                                  filter: .withModifier(
                                      modifier: [t("in", "IN", "in")],
                                      value: .named([t("Europe", "NNP", "europe")])
                                  )
                              ),
                              .withFilter(
                                  name: [t("died", "VBD", "die")],
                                  filter: .withModifier(
                                      modifier: [t("in", "IN", "in")],
                                      value: .named([
                                          t("the", "DT", "the"),
                                          t("US", "NNP", "us")])
                                  )
                              )
                          ])
                      ),
                      t("who", "WP", "who"),
                      t("was", "VBD", "be"),
                      t("born", "VBN", "bear"),
                      t("in", "IN", "in"),
                      t("Europe", "NNP", "europe"),
                      t("and", "CC", "and"),
                      t("died", "VBD", "die"),
                      t("in", "IN", "in"),
                      t("the", "DT", "the"),
                      t("US", "NNP", "us"))
    }

     func testThingQuestion() {
        let p = QuestionParsers.thingQuestion

        expectSuccess(p,
                      .thing(
                          .inverseWithFilter(
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
                      ),
                      t("what", "WP", "what"),
                      t("did", "VBD", "do"),
                      t("George", "NNP", "george"),
                      t("Orwell", "NNP", "orwell"),
                      t("write", "VB", "write"))

        expectSuccess(p,
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
                      t("what", "WP", "what"),
                      t("was", "VBD", "be"),
                      t("authored", "VBN", "author"),
                      t("by", "IN", "by"),
                      t("George", "NNP", "george"),
                      t("Orwell", "NNP", "orwell"))
    }
}
