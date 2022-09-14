import Prelude

extension SPMGenClient.Operations.CamelCase {
  /// Standard acronyms to be treated as a single symbol
  public static let standardAcronyms: Set<String> = [
    "uri", "Uri", "URI",
    "url", "Url", "URL",
    "spm", "Spm", "SPM",
    "npm", "Npm", "NPM",
    "id", "Id", "ID",
    "uuid", "Uuid", "UUID",
    "ulid", "Ulid", "ULID",
    "idfa", "Idfa", "IDFA",
    "json", "Json", "JSON",
    "xml", "Xml", "XML",
    "yaml", "Yaml", "YAML",
    "sf", "SF",
    "ns", "NS",
    "ui", "UI",
    "ux", "UX",
    "sk", "SK" // todo: add more system prefixes
  ]

  public static func standard(
    _ policy: Policy = .keepFirst,
    acronyms: Set<String> = standardAcronyms
  ) -> Self {
    let reservedAcronyms = Set(acronyms.map { $0[...] })
    return .init { input in
      return camelCase(
        input[...],
        policy: policy,
        acronyms: reservedAcronyms
      )
    }
  }
}
