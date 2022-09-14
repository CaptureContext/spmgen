import XCTest
@testable import SPMGenClient

extension String {
  func spmgenCamelCased(
    _ policy: SPMGenClient.Operations.CamelCase.Policy = .keepFirst
  ) -> String {
    return SPMGenClient.Operations.CamelCase
      .standard(policy)
      .call(self)
  }
}

final class CamelCaseTests: XCTestCase {
  func testMain() {
    XCTAssertEqual("u".spmgenCamelCased(), "u")
    XCTAssertEqual("lowercase".spmgenCamelCased(), "lowercase")
    XCTAssertEqual("UPPERCASE".spmgenCamelCased(.lowercaseFirst), "uPPERCASE")
    XCTAssertEqual("Almost.Correct.Case".spmgenCamelCased(), "AlmostCorrectCase")
    XCTAssertEqual("Almost.Correct.Case.1.0".spmgenCamelCased(), "AlmostCorrectCase_1_0")
    XCTAssertEqual("normalCamelCase".spmgenCamelCased(.uppercaseFirst), "NormalCamelCase")
    XCTAssertEqual("_normalCamelCase".spmgenCamelCased(), "_normalCamelCase")
    XCTAssertEqual("URLReserved".spmgenCamelCased(.lowercaseFirst), "urlReserved")
    XCTAssertEqual("idReserved".spmgenCamelCased(), "idReserved")
    XCTAssertEqual("reserved-id".spmgenCamelCased(), "reservedID")
    XCTAssertEqual("reserved-id-middle".spmgenCamelCased(), "reservedIDMiddle")
    XCTAssertEqual("Spm-reserved".spmgenCamelCased(), "SPMReserved")
    XCTAssertEqual("$$$normalCamelCase".spmgenCamelCased(), "normalCamelCase")
    XCTAssertEqual("1numbered".spmgenCamelCased(), "_1numbered")
    XCTAssertEqual("_1numbered".spmgenCamelCased(), "_1numbered")
    XCTAssertEqual("_unknown.symbols_found".spmgenCamelCased(.uppercaseFirst), "_UnknownSymbolsFound")
    XCTAssertEqual("trailingSymbol$".spmgenCamelCased(), "trailingSymbol")
    XCTAssertEqual("testImage.1".spmgenCamelCased(), "testImage_1")
    XCTAssertEqual("testImage.1.2.3".spmgenCamelCased(), "testImage_1_2_3")
    XCTAssertEqual(
      "__IDIdentifierSome_random-stringOf.Cases.1.23.idfaUuid".spmgenCamelCased(.lowercaseFirst),
      "__idIdentifierSomeRandomStringOfCases_1_23_IDFAUUID"
    )
  }
}
