import PackageResourcesCore

extension SPMGenClient.Operations.CollectResources {
  public static var standard: Self {
    .init { path in
      Result {
        try Folder(path: path).compactMapContents(recursive: true) { (content) -> [SPMGenResource]? in
          var output: [SPMGenResource] = []

          func collect(_ resources: SPMGenResourceConvertible?...) {
            output.append(contentsOf: resources.compactMap(\.?.spmGenResource))
          }

          switch content {
          case let .file(file):
            collect(
              font(from: file),
              nib(from: file),
              scene(from: file),
              storyboard(from: file)
            )

          case let .folder(folder):
            collect(
              color(from: folder),
              image(from: folder)
            )
          }

          return output
        }
        .flatMap { $0 }
      }
    }
  }
}

fileprivate func color(from folder: Folder) -> SPMGenColorResource? {
  guard ["colorset"].contains(folder.extension)
  else { return nil }

  return SPMGenColorResource(name: folder.nameExcludingExtension)
}

fileprivate func font(from file: File) -> SPMGenFontResource? {
  guard ["otf", "ttf"].contains(file.extension)
  else { return nil }

  return SPMGenFontResource(name: file.nameExcludingExtension)
}

fileprivate func image(from folder: Folder) -> SPMGenImageResource? {
  guard ["imageset"].contains(folder.extension)
  else { return nil }

  return SPMGenImageResource(name: folder.nameExcludingExtension)
}

fileprivate func nib(from file: File) -> SPMGenNibResource? {
  guard ["xib"].contains(file.extension)
  else { return nil }

  return SPMGenNibResource(name: file.nameExcludingExtension)
}

fileprivate func scene(from file: File) -> SPMGenSCNSceneResource? {
  guard ["scn"].contains(file.extension)
  else { return nil }

  let parent = file.parent

  let catalog = ["scnassets"].contains(parent?.extension)
  ? parent?.nameExcludingExtension
  : nil

  return SPMGenSCNSceneResource(
    name: file.nameExcludingExtension,
    catalog: catalog
  )
}

fileprivate func storyboard(from file: File) -> SPMGenStoryboardResource? {
  guard ["storyboard"].contains(file.extension)
  else { return nil }

  return SPMGenStoryboardResource(name: file.nameExcludingExtension)
}
