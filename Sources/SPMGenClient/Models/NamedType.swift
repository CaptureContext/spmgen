protocol NamedType {
  static var typeName: String { get }
}

extension NamedType {
  var typeName: String { Self.typeName }
}
