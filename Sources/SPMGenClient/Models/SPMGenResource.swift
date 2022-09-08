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
    case .color: return ColorResource.self
    case .font: return FontResource.self
    case .image: return ImageResource.self
    case .nib: return NibResource.self
    case .scene: return SCNSceneResource.self
    case .storyboard: return StoryboardResource.self
    }
  }
}

protocol SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { get }
  var resourceType: NamedType.Type { get }
}

public struct SPMGenColorResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .color(self) }
  var resourceType: NamedType.Type { ColorResource.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenFontResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .font(self) }
  var resourceType: NamedType.Type { FontResource.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenImageResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .image(self) }
  var resourceType: NamedType.Type { ImageResource.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}

public struct SPMGenNibResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .nib(self) }
  var resourceType: NamedType.Type { NibResource.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}


public struct SPMGenSCNSceneResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .scene(self) }
  var resourceType: NamedType.Type { SCNSceneResource.self }

  public init(name: String, catalog: String?) {
    self.name = name
    self.catalog = catalog
  }

  public var name: String
  public var catalog: String?
}

public struct SPMGenStoryboardResource: Equatable, SPMGenResourceConvertible {
  var spmGenResource: SPMGenResource { .storyboard(self) }
  var resourceType: NamedType.Type { StoryboardResource.self }

  public init(name: String) {
    self.name = name
  }

  public var name: String
}
