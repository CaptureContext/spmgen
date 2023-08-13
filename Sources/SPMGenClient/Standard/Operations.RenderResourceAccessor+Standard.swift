import PackageResourcesCore
import Prelude

extension SPMGenClient.Operations.RenderResourceAccessor {
  public static func standard(
    indent: SPMGenClient.Operations.IndentUp = .standard(),
    camelCase: SPMGenClient.Operations.CamelCase = .standard(.lowercaseFirst)
  ) -> SPMGenClient.Operations.RenderResourceAccessor {
    return .init { resource in
      Result {
        RenderedAccessor(
          initialResource: resource,
          stringValue: {
            switch resource {
            case let .color(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )

            case let .image(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )

            case let .font(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )

            case let .nib(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )

            case let .scene(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )

            case let .storyboard(resource):
              return accessor(
                for: resource,
                indent: indent.call,
                camelCase: camelCase.call
              )
            }
          }()
        )
      }
    }
  }
}

fileprivate func accessor(
  for resource: SPMGenColorResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName), bundle: .module)"))
  \(indent(0)("}"))
  """
}

fileprivate func accessor(
  for resource: SPMGenImageResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName), bundle: .module)"))
  \(indent(0)("}"))
  """
}

fileprivate func accessor(
  for resource: SPMGenFontResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName))"))
  \(indent(0)("}"))
  """
}

fileprivate func accessor(
  for resource: SPMGenNibResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName), bundle: .module)"))
  \(indent(0)("}"))
  """
}

fileprivate func accessor(
  for resource: SPMGenSCNSceneResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  let catalog = resource.catalog.map { ", catalog: \($0.escapedUsingQuotes)" } ?? ""
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName)\(catalog))"))
  \(indent(0)("}"))
  """
}

fileprivate func accessor(
  for resource: SPMGenStoryboardResource,
  indent: SPMGenClient.Operations.IndentUp.Signature,
  camelCase: SPMGenClient.Operations.CamelCase.Signature
) -> String {
  let accessorName = camelCase(resource.name)
  let resourceName = resource.name.escapedUsingQuotes
  return """
  \(indent(0)("public static var \(accessorName): Self {"))
  \(indent(1)("return .init(name: \(resourceName), bundle: .module)"))
  \(indent(0)("}"))
  """
}
