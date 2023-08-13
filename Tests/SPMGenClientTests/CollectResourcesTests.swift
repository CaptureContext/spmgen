import XCTest
@testable import SPMGenClient

final class CollectResourcesTests: XCTestCase {
  func testMain() throws {
    let actual = try SPMGenClient.Operations.CollectResources.standard(
      atPath: testResourcesDirectoryPath
    ).get()

    let expected: [SPMGenResource] = [
      .font(.init(name: "Arimo-Bold")),
      .font(.init(name: "Montserrat-Black")),
      .storyboard(.init(name: "Main")),
      .nib(.init(name: "Main")),
      .color(.init(name: "ColorExample")),
      .image(.init(name: "ImageExample")),
      .scene(.init(name: "DefaultScene", catalog: "SCNCatalog")),
    ]

    XCTAssertEqual(actual, expected)
  }
}
