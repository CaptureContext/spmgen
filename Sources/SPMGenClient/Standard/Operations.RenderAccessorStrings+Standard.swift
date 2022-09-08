import PackageResourcesCore
import Prelude

extension SPMGenClient.Operations.RenderAccessorStrings {
  public static func standard(
    renderAccessor: SPMGenClient.Operations.RenderAccessorString? = nil,
    indent: SPMGenClient.Operations.IndentUp = .standard()
  ) -> SPMGenClient.Operations.RenderAccessorStrings {
    let renderAccessor = renderAccessor ?? .standard(indent: indent)
    return .init { resources in
      Result {
        let grouppedResources = resources.groupped(by: { $0.resourceType.typeName })

        let grouppedAccessors: [(type: String, accessors: [String])]
        grouppedAccessors = try grouppedResources.map { key, resources in
          return try (key, resources.map { try renderAccessor($0).get() })
        }.sorted(by: unpack(pipe(scope(\.type), <)))

        return grouppedAccessors.compactMap { group in
          guard not(group.accessors.isEmpty) else { return nil }
          return """
          extension \(group.type) {
          \(group.accessors.sorted(by: <).map(indent(1)).joined(separator: "\n\n"))
          }
          """
        }.joined(separator: "\n\n")
      }
    }
  }
}

extension Array {
  fileprivate func groupped<GroupID: Hashable>(
    by groupID: (Element) -> GroupID
  ) -> [GroupID: [Element]] {
    reduce(into: [GroupID: [Element]]()) { buffer, element in
      let _groupID = groupID(element)
      if buffer[_groupID] == nil { buffer[_groupID] = [element] }
      else { buffer[_groupID]?.append(element) }
    }
  }
}
