import PackagePlugin
import Foundation
import AppKit

@main
struct SPMGenPlugin: BuildToolPlugin {
  func createBuildCommands(
    context: PluginContext,
    target: Target
  ) async throws -> [Command] {
    return [
      .prebuildCommand(
        displayName: "Run spmgen-plugin",
        executable: try context.tool(named: "spmgen").path,
        arguments: [
          "resources",
          "--input", target.directory.string,
          "--output", context.pluginWorkDirectory.appending("\(target.name)_Resources.generated.swift")
        ],
        outputFilesDirectory: context.pluginWorkDirectory
      )
    ]
  }
}
