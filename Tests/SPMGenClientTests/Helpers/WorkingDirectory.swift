let workingDirectoryPath: String = #file
  .components(separatedBy: "/")
  .dropLast() // File name
  .dropLast() // Helpers directory
  .joined(separator: "/")

let testResourcesDirectoryPath: String =
workingDirectoryPath.appending("/_Resources")
