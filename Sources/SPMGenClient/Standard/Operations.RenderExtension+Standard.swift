import PackageResourcesCore
import Prelude

extension SPMGenClient.Operations.RenderExtensions {
  public static func standard(
    renderAccessor: SPMGenClient.Operations.RenderResourceAccessor? = nil,
    camelCase: SPMGenClient.Operations.CamelCase = .standard(.lowercaseFirst),
    indent: SPMGenClient.Operations.IndentUp = .standard()
  ) -> SPMGenClient.Operations.RenderExtensions {
    let renderAccessor = renderAccessor ?? .standard(
      indent: indent,
      camelCase: camelCase
    )
    return .init { resources in
      Result {
        let grouppedResources = resources.groupped(by: { $0.resourceType.typeName })

        let grouppedAccessors: [(type: String, accessors: [RenderedAccessor])]
        grouppedAccessors = try grouppedResources.map { key, resources in
          return try (key, resources.map { try renderAccessor($0).get() })
        }.sorted(by: unpack(pipe(scope(\.type), <)))

        return grouppedAccessors.compactMap { group in
          guard not(group.accessors.isEmpty) else { return nil }

          var renderedGroup = ""

          if group.type == PackageResources.Font.typeName {
            let fontAccessorsList = group.accessors
              .map(\.initialResource.name)
              .sorted(by: <)
              .map { ".\(camelCase($0))," }
              .map(indent(2))
              .joined(separator: "\n")

            renderedGroup += """
            extension Array where Element == \(group.type) {
            \(indent(1)("public static var _spmgen: Self {["))
            \(fontAccessorsList)
            \(indent(1)("]}"))
            }
            """ + "\n\n"
          }

          let accessors = group.accessors
            .map(\.stringValue)
            .sorted(by: <)
            .map(indent(1))
            .joined(separator: "\n\n")

          renderedGroup += """
          extension \(group.type) {
          \(accessors)
          }
          """

          return renderedGroup
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
