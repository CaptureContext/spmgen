import ArgumentParser
import Foundation

// MARK: - Command

public struct App: ParsableCommand {
  public static let _commandName: String = "spmgen"
  public static let _version = "3.0.0"

  public static let configuration = CommandConfiguration(
    subcommands: [Resources.self, Version.self]
  )
  
  @Flag(help: "Display version of the app")
  var version = false

  public init() {}

  public func run() throws {
    if version {
      print(Self._version)
    } else {
      throw CleanExit.helpRequest(self)
    }
  }
}
