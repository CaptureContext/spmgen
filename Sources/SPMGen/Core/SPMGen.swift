import ArgumentParser
import Foundation

// MARK: - Command

public struct SPMGen: ParsableCommand {
  public static var _commandName: String = "spmgen"

  public static let configuration = CommandConfiguration(
    subcommands: [Resources.self]
  )

  public init() {}

  public func run() throws {
    throw _Error("No command found. Run --help to explore available commands.")
  }
}
