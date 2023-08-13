import PackagePlugin
import Foundation
import AppKit

@main
struct SPMGenPlugin: BuildToolPlugin {
  func createBuildCommands(
    context: PluginContext,
    target: Target
  ) async throws -> [Command] {
    guard let target = target as? SourceModuleTarget else { return [] }

    let outputDirectoryPath = context.pluginWorkDirectory
        .appending(subpath: target.name)

    try FileManager.default.createDirectory(
      atPath: outputDirectoryPath.string,
      withIntermediateDirectories: true
    )

    let outputPath = outputDirectoryPath
      .appending(subpath: "Resources.generated.swift")

    return [
      .buildCommand(
        displayName: "Run spmgen-plugin for \(target.name)",
        executable: try context.tool(named: "spmgen").path,
        arguments: [
          "resources", target.directory.string,
          "--output", outputPath
        ],
        outputFiles: [
          outputPath
        ]
      )
    ]
  }
}
