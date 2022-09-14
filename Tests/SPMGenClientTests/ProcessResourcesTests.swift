import XCTest
@testable import SPMGenClient

final class ProcessResourcesStringTests: XCTestCase {
  func testMain() throws {
    let actual = try SPMGenClient.Operations.ProcessResources.standard()(
      atPath: "/Users/maximkrouk/Developer/CaptureContext/Apps/spmgen/Example/Example"
    ).get()!

    let expected = """
    extension ColorResource {
      public static var accentColor: ColorResource {
        return .init(name: "AccentColor", bundle: .module)
      }

      public static var srgbWhite: ColorResource {
        return .init(name: "srgb-white", bundle: .module)
      }
    }

    extension FontResource {
      public static var robotoBold: FontResource {
        return .init(name: "Roboto-Bold", bundle: .module)
      }

      public static var sfProDisplayRegular: FontResource {
        return .init(name: "SF-Pro-Display-Regular", bundle: .module)
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
