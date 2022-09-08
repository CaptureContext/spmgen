import ArgumentParser
import SPMGenClient
import Foundation

extension SPMGen {
  public struct Resources: ParsableCommand {
    public static var _commandName: String = "resources"

    public init() {}

    public init(
      input: String,
      output: String?,
      indentor: String = " ",
      tabSize: Int = 2
    ) {
      self.input = input
      self.output = output
      self.indentor = indentor
      self.tabSize = tabSize
    }

    @Argument(help: "Path to root directory for scanning.")
    public var input: String = "./"

    @Option(help: "Path to output file")
    public var output: String?

    @Option(help: "Indentation character")
    public var indentor: String = " "

    @Option(help: "Tab size")
    public var tabSize: Int = 2

    public func run() throws {
      let outputPath = output ?? input.appending("/Resources.generated.swift")

      let client = SPMGenClient(
        processResources: .standard(
          tabSize: tabSize,
          indentor: indentor
        )
      )

      try client.processResources(atPath: input, toFileAtPath: outputPath).get()
    }
  }

}
