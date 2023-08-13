import XCTest
@testable import SPMGenClient

final class ProcessResourcesStringTests: XCTestCase {
  func testMain() throws {
    let actual = try SPMGenClient.Operations.ProcessResources.standard()(
      atPath: testResourcesDirectoryPath
    ).get()!

    let expected = """
    extension PackageResources.Color {
      public static var colorExample: Self {
        return .init(name: "ColorExample", bundle: .module)
      }
    }

    extension Array where Element == PackageResources.Font {
      public static var _spmgen: Self {[
        .arimoBold,
        .montserratBlack,
      ]}
    }

    extension PackageResources.Font {
      public static var arimoBold: Self {
        return .init(name: "Arimo-Bold")
      }

      public static var montserratBlack: Self {
        return .init(name: "Montserrat-Black")
      }
    }

    extension PackageResources.Image {
      public static var imageExample: Self {
        return .init(name: "ImageExample", bundle: .module)
      }
    }

    extension PackageResources.Nib {
      public static var main: Self {
        return .init(name: "Main", bundle: .module)
      }
    }

    extension PackageResources.SCNScene {
      public static var defaultScene: Self {
        return .init(name: "DefaultScene", catalog: "SCNCatalog")
      }
    }

    extension PackageResources.Storyboard {
      public static var main: Self {
        return .init(name: "Main", bundle: .module)
      }
    }
    """

    XCTAssertEqual(actual, expected)
  }
}
