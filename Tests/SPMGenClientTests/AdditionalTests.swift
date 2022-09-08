import XCTest
@testable import SPMGenClient

final class AdditionalTests: XCTestCase {
  func testSome() {
    XCTAssertEqual(
      ["U", "R", "L", "Session"].mergingSeparatedReserved(),
      ["URL", "Session"]
    )
  }

  func testCamelCase() {
    XCTAssertEqual("u".camelCased(), "u")
    XCTAssertEqual("lowercase".camelCased(), "lowercase")
    XCTAssertEqual("UPPERCASE".camelCased(.lowercaseFirst), "uPPERCASE")
    XCTAssertEqual("Almost.Correct.Case".camelCased(), "AlmostCorrectCase")
    XCTAssertEqual("normalCamelCase".camelCased(.uppercaseFirst), "NormalCamelCase")
    XCTAssertEqual("_normalCamelCase".camelCased(), "_normalCamelCase")
    XCTAssertEqual("URLReserved".camelCased(.lowercaseFirst), "urlReserved")
    XCTAssertEqual("idReserved".camelCased(), "idReserved")
    XCTAssertEqual("reserved-id".camelCased(), "reservedID")
    XCTAssertEqual("reserved-id-middle".camelCased(), "reservedIDMiddle")
    XCTAssertEqual("Spm-reserved".camelCased(), "SPMReserved")
    XCTAssertEqual("$$$normalCamelCase".camelCased(), "normalCamelCase")
    XCTAssertEqual("1numbered".camelCased(), "_1numbered")
    XCTAssertEqual("_1numbered".camelCased(), "_1numbered")
    XCTAssertEqual("_unknown.symbols_found".camelCased(.uppercaseFirst), "_UnknownSymbolsFound")
    XCTAssertEqual("trailingSymbol$".camelCased(), "trailingSymbol")
    XCTAssertEqual("testImage.1".camelCased(), "testImage_1")
    XCTAssertEqual("testImage.1.2.3".camelCased(), "testImage_1_2_3")
  }
}
