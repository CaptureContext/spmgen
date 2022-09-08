import Foundation
import Prelude

extension String {
  var escapedUsingQuotes: String { "\"\(self)\"" }
}

// MARK: - CamelCase

extension String {
  public enum CamelCaseFirstLetterCustomizationFlag {
    case uppercaseFirst
    case lowercaseFirst
    case keepFirst
  }

  private func uppercasedFirst() -> String {
    return prefix(1).uppercased() + dropFirst()
  }

  private func lowercasedFirst() -> String {
    return prefix(1).lowercased() + dropFirst()
  }

  public func camelCased(
    _ firstLetterCustomizationFlag: CamelCaseFirstLetterCustomizationFlag = .keepFirst
  ) -> String {
    let underscorePrefix = prefix(while: { $0 == "_" })

    var result = String(dropFirst(underscorePrefix.count))

    if result.isEmpty { return String(underscorePrefix) }

    var allowedSet: CharacterSet = .alphanumerics
    if rangeOfCharacter(from: .decimalDigits) != nil {
      allowedSet.insert(".")
    }

    let words = result
      .components(separatedBy: allowedSet.inverted)
      .filter { !$0.isEmpty }
      .mergingSeparatedReserved()

    let first = words.first.map { word in
        switch firstLetterCustomizationFlag {
        case .keepFirst:
          return word
        case .lowercaseFirst:
          return word.lowercasedFirst()
        case .uppercaseFirst:
          return word.uppercasedFirst()
        }
      } ?? ""

    let rest = words.dropFirst()
      .map { String($0) }
      .map { $0.uppercasedFirst() }

    result = ([first] + rest).joined(separator: "")

    if underscorePrefix.isEmpty, result.first?.isNumber == true {
      result = "_\(result)"
    }

    return (underscorePrefix + result).replacingOccurrences(of: ".", with: "_")
  }
}

extension Array where Element == String {
  func mergingSeparatedReserved() -> [String] {
    var output: [String] = []
    let reserved = [
      "url", "spm", "id",
      "Url", "Spm", "Id",
      "URL", "SPM", "ID",
    ]
    var candidates: [(word: String, processingIndex: String.Index)] = []
    var backupCache: [String] = []
    func backup() {
      output.append(contentsOf: backupCache)
    }

    func save(_ word: String) {
      output.append(word)
      backupCache.removeAll()
      candidates.removeAll()
    }

    for word in self {
      guard word.count == 1, let char = word.first else {
        save(word)
        continue
      }

      backupCache.append(word)

      if candidates.isEmpty {
        candidates = reserved.compactMap {
          guard $0[$0.startIndex] == char else { return nil }
          return ($0, $0.startIndex)
        }
      } else {
        candidates = candidates.compactMap { candidate, index in
          let newIndex = candidate.index(after: index)
          return candidate[newIndex] == char ? (candidate, newIndex) : nil
        }
      }

      if candidates.isEmpty { backup() }
      else if let candidate = candidates.first(where: { word, processingIndex in
        word.index(before: word.endIndex) == processingIndex
      }) { save(candidate.word) }
    }
    return output
  }
}
