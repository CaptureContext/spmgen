protocol NamedType {}
extension NamedType {
  static var typeName: String { String(describing: self) }
  var typeName: String { Self.typeName }
}
