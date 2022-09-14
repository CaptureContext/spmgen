import ArgumentParser
import Foundation

// MARK: - Command

public struct App: ParsableCommand {
  public static var _commandName: String = "spmgen"

  public static let configuration = CommandConfiguration(
    subcommands: [Resources.self]
  )
  
  @Flag(help: "Display version of the app")
  var version = false

  public init() {}

  public func run() throws {
    if version {
      print("2.1.0")
    } else {
      throw _Error("No command found. Run --help to explore available commands.")
    }
  }
}
