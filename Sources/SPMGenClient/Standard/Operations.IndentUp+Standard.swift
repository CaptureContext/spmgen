extension SPMGenClient.Operations.IndentUp {
  public static func standard(tabSize: Int = 2, indentor: String = " ") -> Self {
    let _indentor = String(repeating: indentor, count: tabSize)
    return .init { level in
      return { source in
        source.components(separatedBy: .newlines)
          .map { String(repeating: _indentor, count: level) + $0 }
          .joined(separator: "\n")
      }
    }
  }
}
