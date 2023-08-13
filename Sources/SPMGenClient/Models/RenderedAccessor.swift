public struct RenderedAccessor: Equatable {
  public let initialResource: SPMGenResource
  public let stringValue: String

  public init(
    initialResource: SPMGenResource,
    stringValue: String
  ) {
    self.initialResource = initialResource
    self.stringValue = stringValue
  }
}
