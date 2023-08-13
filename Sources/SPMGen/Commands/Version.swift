import ArgumentParser
import SPMGenClient
import Foundation

extension App {
  public struct Version: ParsableCommand {
    public static let _commandName: String = "version"
    public static let _value = "3.0.0"

    public init() {}

    public func run() throws {
      print(Self._value)
    }
  }

}
