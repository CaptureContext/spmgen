import Prelude

extension SPMGenClient.Operations.ProcessResources {
  public static func standard(render: ToString = .standard()) -> Self {
    return .init(stringOutput: render, fileOutput: .standard(render: render))
  }

  public static func standard(
    tabSize: Int,
    indentor: String,
    acronyms: Set<String>
  ) -> Self {
    let indent: SPMGenClient.Operations.IndentUp = .standard(
      tabSize: tabSize,
      indentor: indentor
    )

    let camelCase: SPMGenClient.Operations.CamelCase = .standard(
      .lowercaseFirst,
      acronyms: acronyms
    )

    return .standard(
      render: .standard(
        render: .standard(
          renderAccessor: .standard(
            indent: indent,
            camelCase: camelCase
          ),
          camelCase: camelCase,
          indent: indent
        )
      )
    )
  }
}

extension SPMGenClient.Operations.ProcessResources.ToString {
  public static func standard(
    collect: SPMGenClient.Operations.CollectResources = .standard,
    render: SPMGenClient.Operations.RenderExtensions = .standard()
  ) -> Self {
    .init { path in
      collect.apply(render)(path)
    }
  }
}
extension SPMGenClient.Operations.ProcessResources.ToFile {
  public static func standard(
    render: SPMGenClient.Operations.ProcessResources.ToString = .standard()
  ) -> Self {
    .init { input, output in
      Result {
        let processedResources = try render.call(input).get()
        let outputFile = try File(path: output, create: true)

        let disclaimer = """
        //
        // \(outputFile.name)
        // This file is generated. Do not edit!
        //
        """

        let imports = """
        import Foundation
        import PackageResourcesCore
        """

        let output = [
          disclaimer,
          imports,
          processedResources
        ].joined(separator: "\n\n")

        try outputFile.write(output)
      }
    }
  }
}

extension Function {
  fileprivate func apply<
    F: Function,
    BValue,
    CValue
  >(
    _ f: F
  ) -> Func<A, F.B> where
    B == Result<BValue, Error>,
    F.A == BValue,
    F.B == Result<CValue, Error>
  {
    return .init { a in
      Result {
        try f(call(a).get()).get()
      }
    }
  }
}
