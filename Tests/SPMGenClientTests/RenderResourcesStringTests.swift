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

    let actual = try SPMGenClient.Operations.RenderAccessorStrings.standard().call(
      resources
    ).get()

    let expected = """
    extension ColorResource {
      public static var accentColor: ColorResource {
        return .init(name: "AccentColor", bundle: .module)
      }
    }

    extension FontResource {
      public static var robotoBold: FontResource {
        return .init(name: "Roboto-Bold", bundle: .module)
      }
    }

    extension ImageResource {
      public static var someImage: ImageResource {
        return .init(name: "some-image", bundle: .module)
      }
    }

    extension NibResource {
      public static var view: NibResource {
        return .init(name: "View", bundle: .module)
      }
    }

    extension SCNSceneResource {
      public static var defaultScene: SCNSceneResource {
        return .init(name: "DefaultScene", catalog: "SCNCatalog")
      }
    }

    extension StoryboardResource {
      public static var storyboard: StoryboardResource {
        return .init(name: "Storyboard", bundle: .module)
      }
    }
    """

    XCTAssertEqual(actual, expected)
  }
}
