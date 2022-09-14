import XCTest
@testable import SPMGenClient

final class CollectResourcesTests: XCTestCase {
  func testMain() throws {
    let actual = try SPMGenClient.Operations.CollectResources.standard(
      atPath: "/Users/maximkrouk/Developer/CaptureContext/Apps/spmgen/Example/Example"
    ).get()

    let expected: [SPMGenResource] = [
      .color(.init(name: "AccentColor")),
      .image(.init(name: "some-image")),
      .color(.init(name: "srgb-white")),
      .font(.init(name: "Roboto-Bold")),
      .font(.init(name: "SF-Pro-Display-Regular")),
      .storyboard(.init(name: "Storyboard")),
      .nib(.init(name: "View")),
      .scene(.init(name: "DefaultScene", catalog: "SCNCatalog"))
    ]

    XCTAssertEqual(actual, expected)
  }
}
