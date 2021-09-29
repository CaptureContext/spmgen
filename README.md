# SPMGen

Code generator for Swift.

## Installation

### Makefile

```bash
# Download repo
git clone https://github.com/capturecontext/spmgen.git

# Navigate to repo directory
cd spmgen

# Build and install using Make
make install

# You can also delete spmgen using `make uninstall` command
```

## Resources command

SPMGen provides static resource factories for various resource types.

Supported resources:

| Resource           | Extensions        | Is reliable |
| ------------------ | ----------------- | ----------- |
| ColorResource      | `.xcassets`       | true        |
| FontResource       | `.ttf` `.otf`     | true        |
| ImageResource      | `.xcassets`       | true        |
| NibResource        | `.xib`            | not used    |
| StoryboardResource | `.storyboard`     | not used    |
| SCNSceneResource   | `.scnassets/.scn` | true        |

### Integration

Add [PackageResources](https://github.com/capturecontext/swift-package-resources) dependency to your package

```swift
.package(
  name: "swift-package-resources",
  url: "https://github.com/capturecontext/swift-package-resources.git", 
  .upToNextMajor(from: "1.0.0")
)
```

Create `Resources` target with a following structure

```plaintext
Sources
  Resources
    Resources
      <#Assets#>
```

Specify resource processing and add SPMResources dependency to your target

```swift
.target(
  name: "Resources",
  dependencies: [
    .product(
      name: "PackageResources",
      package: "swift-package-resources"
    )
  ],
  resources: [
    .process("Resources")
  ]
)
```

Add a script to your `Run Script` target build phases

```bash
spmgen resources "$SRCROOT/Sources/Resources/Resources" \
  --output "$SRCROOT/Sources/Resources/Resources.generated.swift" \
  --indentor " " \
  --indentation-width 2

# You can also add `--disable-exports` flag to disable `@_exported` attribute
# for `import PackageResources` declaration in generated file
```

Add `<#Project#>Resources` target as a dependency to other targets

```swift
.target(
  name: "<#Project#>Module",
  dependencies: [
    .target(name: "Resources")
  ]
)
```

### Usage

Import your `<#Project#>Resources` package and initialize objects using `.resource()` static factory

```swift
import Resources
import UIKit

let label = UILabel()
label.backgroundColor = .resource(.accentColor)
label.textColor = .resource(.primaryText)
label.font = .primary(ofSize: 12, weight: .semibold, style: .italic)

let imageView = UIImageView(image: .resource(.logo))
```

> **Note: Fonts require additional setup**
>
> For example you want to add `Monsterrat` and `Arimo` fonts with different styles
>
> - Download fonts and add them to `Sources/<#Project#>Resources/Resources` folder
>
> - Add a static factories for your custom fonts (_[Example](https://gist.github.com/maximkrouk/5bcccc5db12f0347676be5a776c309a8)_)
> - Register custom fonts on app launch (_in AppDelegate, for example_) 
>   - `UIFont.bootstrap()` if you are using code from the example above.
