import PackageResourcesCore

public enum SPMGenResource: Equatable, SPMGenResourceConvertible {
  case color(SPMGenColorResource)
  case font(SPMGenFontResource)
  case image(SPMGenImageResource)
  case nib(SPMGenNibResource)
  case scene(SPMGenSCNSceneResource)
  case storyboard(SPMGenStoryboardResource)

  var spmGenResource: SPMGenResource { self }

  var resourceType: NamedType.Type {
    switch self {
    case .color: return PackageResources.Color.self
    case .font: return PackageResources.Font.self
    case .image: return PackageResources.Image.self
    case .nib: return PackageResources.Nib.self
    case .scene: return PackageResources.SCNScene.self
    case .storyboard: return PackageResources.Storyboard.self
    }
  }

  var name: String {
    switch self {
    case let .color(resource): return resource.name
    case let .font(resource): return resource.name
    case let .image(resource): return resource.name
    case let .nib(resource): return resource.name
    case let .scene(resource): return resource.name
    case let .storyboard(resource): return resource.name
    }
  }
}

protocol SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { get }
  var resourceType: NamedType.Type { get }
}

public struct SPMGenColorResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .color(self) }
  var resourceType: NamedType.Type { PackageResources.Color.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenFontResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .font(self) }
  var resourceType: NamedType.Type { PackageResources.Font.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenImageResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .image(self) }
  var resourceType: NamedType.Type { PackageResources.Image.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenNibResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .nib(self) }
  var resourceType: NamedType.Type { PackageResources.Nib.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}


public struct SPMGenSCNSceneResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .scene(self) }
  var resourceType: NamedType.Type { PackageResources.SCNScene.self }

  public init(name: String, catalog: String?) {
    self.name = name
    self.catalog = catalog
  }

  public var name: String
  public var catalog: String?
}

public struct SPMGenStoryboardResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .storyboard(self) }
  var resourceType: NamedType.Type { PackageResources.Storyboard.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}
