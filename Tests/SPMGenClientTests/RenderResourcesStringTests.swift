import XCTest
@testable import SPMGenClient

final class RenderResourcesStringTests: XCTestCase {
  func testMain() throws {
    let resources: [SPMGenResource] = [
      .color(.init(name: "AccentColor")),
      .image(.init(name: "some-image")),
      .font(.init(name: "Roboto-Bold")),
      .nib(.init(name: "View")),
      .scene(.init(name: "DefaultScene", catalog: "SCNCatalog")),
      .storyboard(.init(name: "Storyboard")),
    ]

    let actual = try SPMGenClient.Operations.RenderExtensions.standard().call(
      resources
    ).get()

    let expected = """
    extension PackageResources.Color {
      public static var accentColor: Self {
        return .init(name: "AccentColor", bundle: .module)
      }
    }

    extension Array where Element == PackageResources.Font {
      public static var _spmgen: Self {[
        .robotoBold,
      ]}
    }

    extension PackageResources.Font {
      public static var robotoBold: Self {
        return .init(name: "Roboto-Bold")
      }
    }

    extension PackageResources.Image {
      public static var someImage: Self {
        return .init(name: "some-image", bundle: .module)
      }
    }

    extension PackageResources.Nib {
      public static var view: Self {
        return .init(name: "View", bundle: .module)
      }
    }

    extension PackageResources.SCNScene {
      public static var defaultScene: Self {
        return .init(name: "DefaultScene", catalog: "SCNCatalog")
      }
    }

    extension PackageResources.Storyboard {
      public static var storyboard: Self {
        return .init(name: "Storyboard", bundle: .module)
      }
    }
    """

    XCTAssertEqual(actual, expected)
  }
}
