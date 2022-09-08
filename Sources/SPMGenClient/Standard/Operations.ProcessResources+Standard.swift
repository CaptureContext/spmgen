import Prelude

extension SPMGenClient.Operations.ProcessResources {
  public static func standard(render: ToString = .standard()) -> Self {
    return .init(stringOutput: render, fileOutput: .standard(render: render))
  }

  public static func standard(
    tabSize: Int,
    indentor: String
  ) -> Self {
    let indent: SPMGenClient.Operations.IndentUp = .standard(
      tabSize: tabSize,
      indentor: indentor
    )

    return .standard(
      render: .standard(
        render: .standard(
          renderAccessor: .standard(
            indent: indent
          ),
          indent: indent
        )
      )
    )
  }
}

extension SPMGenClient.Operations.ProcessResources.ToString {
  public static func standard(
    collect: SPMGenClient.Operations.CollectResources = .standard,
    render: SPMGenClient.Operations.RenderAccessorStrings = .standard()
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
        try outputFile.write(disclaimer + "\n\n" + processedResources)
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
