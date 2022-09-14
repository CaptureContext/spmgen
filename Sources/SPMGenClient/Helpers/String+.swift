import Foundation
import Prelude

extension String {
  var escapedUsingQuotes: String { "\"\(self)\"" }
}

// MARK: - CamelCase

typealias CamelCasingPolicy = SPMGenClient.Operations.CamelCase.Policy

func camelCase(
  _ string: Substring,
  policy: CamelCasingPolicy = .keepFirst,
  acronyms: Set<Substring>
) -> String {
  let collectedParts = camelCase_collectParts(
    from: string.first?.isNumber == true
      ? "_" + string
      : string,
    acronyms: acronyms
  )

  let leadingUnderscores = collectedParts.first.flatMap { first in
    first.allSatisfy { $0 == "_" } ? first : nil
  }

  let parts = leadingUnderscores == nil
    ? collectedParts[...]
    : collectedParts.dropFirst()

  let first: Substring = parts.first.map { part in
    switch policy {
    case .keepFirst:
      if acronyms.contains(part) {
        guard let first = part.first else { return "" }
        return first.isLowercase
        ? part.lowercased()[...]
        : part.uppercased()[...]
      }
      return part
    case .lowercaseFirst:
      if acronyms.contains(part) {
        return part.lowercased()[...]
      }
      return lowercaseFirst(part, acronyms: acronyms)
    case .uppercaseFirst:
      if acronyms.contains(part) {
        return part.uppercased()[...]
      }
      return uppercaseFirst(part, acronyms: acronyms)
    }
  } ?? ""

  let rest = parts.dropFirst().map { part in
    return acronyms.contains(part)
    ? part.uppercased()[...]
    : uppercaseFirst(part, acronyms: acronyms)
  }

  return ([leadingUnderscores ?? ""] + [first] + rest).joined()
}

func camelCase_collectParts(
  from string: Substring,
  acronyms: Set<Substring>
) -> [Substring] {
  guard !string.isEmpty else { return [] }

  func index(after currentIndex: String.Index) -> (value: String.Index, character: Character)? {
    let index = string.index(after: currentIndex)
    return index < string.endIndex
    ? (value: index, character: string[index] )
    : nil
  }

  func index(before currentIndex: String.Index) -> (value: String.Index, character: Character)? {
    guard currentIndex > string.startIndex else { return nil }
    let index = string.index(before: currentIndex)
    return (value: index, character: string[index] )
  }

  var collectedParts: [Substring] = []

  var currentWindow: Range<Substring.Index> = .init(uncheckedBounds: (
    lower: string.startIndex,
    upper: string.index(after: string.startIndex)
  ))
  var currentBuffer: Substring {
    string[currentWindow]
  }
  var currentIndex: (value: String.Index, character: Character) {
    let index = string.index(before: currentWindow.upperBound)
    return (
      value: index,
      character: string[index]
    )
  }

  var currentWindowWithNext: Range<Substring.Index> {
    currentWindow.lowerBound ..< string.index(after: string.index(after: currentWindow.upperBound))
  }
  var currentBufferWithNext: Substring {
    string[currentWindowWithNext]
  }

  func move(_ window: inout Range<String.Index>) {
    guard window.upperBound < string.endIndex else { return }
    window = .init(uncheckedBounds: (
      lower: window.upperBound,
      upper: string.index(after: window.upperBound)
    ))
  }

  func extend(_ window: inout Range<String.Index>) {
    window = .init(uncheckedBounds: (
      lower: window.lowerBound,
      upper: string.index(after: window.upperBound)
    ))
  }

  func collect(_ window: inout Range<String.Index>) {
    let buffer = string[window]
    guard !buffer.isEmpty else { return move(&window) }
    collectedParts.append(buffer)
    move(&window)
  }

  // collect leading underscores
  collectedParts.append(string.prefix(while: { $0 == "_" }))
  while currentIndex.character == "_" {
    move(&currentWindow)
  }

  while let nextIndex = index(after: currentIndex.value) {
    // lookup for reserved acronyms
    var lookupSucceed = false
    var lookupWindow = currentWindow
    var lookupBuffer: Substring { string[lookupWindow] }

    while
      index(after: lookupWindow.upperBound) != nil,
      acronyms.contains(where: { $0.hasPrefix(lookupBuffer) })
    {
      guard !acronyms.contains(lookupBuffer) else {
        if !string[lookupWindow.upperBound].isLowercaseAlphanumeric {
          currentWindow = lookupWindow
          collect(&currentWindow)
          lookupSucceed = true
        }
        break
      }
      extend(&lookupWindow)
    }

    guard !lookupSucceed
    else { continue }

    // add number-letter underscore separator
    if
      let index = index(before: currentIndex.value),
      index.character.isNumber,
      !currentIndex.character.isAlphanumeric,
      nextIndex.character.isLetter
    {
      move(&currentWindow)
      collectedParts.append("_")
      continue
    }

    // process aA, bB, cC, AA, BB, CC, a., b_, C- ... cases
    if
      (
        currentIndex.character.isAlphanumeric
        && nextIndex.character.isAlphanumeric
        && nextIndex.character.isUppercaseAlphanumeric
      )
        ||
      (
        currentIndex.character.isAlphanumeric
        && !nextIndex.character.isAlphanumeric
      )
    {
      collect(&currentWindow)
      continue
    }

    // process Aa, Bb, Cc, 10, 20, 30 ... cases
    if
      (
        currentIndex.character.isAlphanumeric
        && nextIndex.character.isAlphanumeric
        && nextIndex.character.isLowercaseAlphanumeric
      )
        ||
      (
        currentIndex.character.isNumber
        && nextIndex.character.isNumber
      )
    {
      extend(&currentWindow)
      continue
    }

    // process a1, A2, b1, B2 ... cases
    if
      currentIndex.character.isLetter
      && nextIndex.character.isNumber
    {
      collect(&currentWindow)
      collectedParts.append("_")
      continue
    }

    // process .1, _2, -3 ... cases
    if
      !currentIndex.character.isNumber,
      nextIndex.character.isNumber
    {
      collectedParts.append("_")
      move(&currentWindow)
      continue
    }

    // process ., _, - ... cases
    if
      !currentIndex.character.isAlphanumeric
    {
      move(&currentWindow)
      continue
    }

    // process other cases
    if
      !nextIndex.character.isAlphanumeric
    {
      collect(&currentWindow)
      continue
    }
  }

  if currentBuffer.allSatisfy(\.isAlphanumeric) {
    collect(&currentWindow)
  }

  return collectedParts
}

private func uppercaseFirst(
  _ string: Substring,
  acronyms: Set<Substring>
) -> Substring {
  return acronyms.contains(string)
  ? string[...]
  : string.prefix(1).uppercased() + string.dropFirst()
}

private func lowercaseFirst(
  _ string: Substring,
  acronyms: Set<Substring>
) -> Substring {
  return acronyms.contains(string)
  ? string[...]
  : string.prefix(1).lowercased() + string.dropFirst()
}

fileprivate extension Character {
  var isAlphanumeric: Bool { (isLetter || isNumber) }
  var isUppercaseAlphanumeric: Bool { isAlphanumeric && isUppercase }
  var isLowercaseAlphanumeric: Bool { isAlphanumeric && isLowercase }
}
