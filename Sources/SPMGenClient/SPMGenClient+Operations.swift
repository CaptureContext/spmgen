import Prelude
import Foundation
import PackageResourcesCore

protocol SyncClientOperation: SyncFunction {
  var call: SyncSignature { get }
}

extension SyncClientOperation {
  public func callAsFunction(_ input: Input) -> Output {
    return call(input)
  }
}

extension SPMGenClient {
  public enum Operations {}
}

extension SPMGenClient.Operations {
  public struct IndentUp: SyncClientOperation {
    public typealias Input = Int
    public typealias Output = (String) -> String

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature

    public func callAsFunction(level: Int) -> Output {
      return call(level)
    }
  }

  public struct CamelCase: SyncClientOperation {
    public typealias Input = String
    public typealias Output = String

    public enum Policy {
      case uppercaseFirst
      case lowercaseFirst
      case keepFirst
    }

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature
  }

  public struct CollectResources: SyncClientOperation, SyncFunction {
    public typealias Input = String
    public typealias Output = Result<[SPMGenResource], Error>

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature

    func callAsFunction(atPath path: Input) -> Output {
      return call(path)
    }
  }

  public struct RenderResourceAccessor: SyncClientOperation, SyncFunction {
    public typealias Input = SPMGenResource
    public typealias Output = Result<RenderedAccessor, Error>

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature

    func callAsFunction(for resource: Input) -> Output {
      return call(resource)
    }
  }

  public struct RenderExtensions: SyncClientOperation {
    public typealias Input = [SPMGenResource]
    public typealias Output = Result<String, Error>

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature

    func callAsFunction(for resources: Input) -> Output {
      return call(resources)
    }
  }

  public struct ProcessResources: SyncClientOperation {
    public enum OutputFormat {
      case file(atPath: String, completion: (Result<Void, Error>) -> Void = { _ in })
      case string((Result<String, Error>) -> Void)
    }

    public typealias Input = (String, OutputFormat)
    public typealias Output = Void

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature

    public func callAsFunction(
      atPath input: String
    ) -> Result<String?, Error> {
      var result: Result<String?, Error> = .success(nil)
      call((input, .string { output in
        result = output.map(String?.some)
      }))
      return result
    }

    public func callAsFunction(
      atPath input: String,
      toFileAtPath output: String
    ) -> Result<Void, Error> {
      var result: Result<Void, Error> = .success(())
      call((input, .file(atPath: output) { output in
        result = output
      }))
      return result
    }

    public func callAsFunction(
      atPath input: String,
      to output: OutputFormat
    ) -> Output {
      return call((input, output))
    }
  }
}

extension SPMGenClient.Operations.ProcessResources {
  public init(
    stringOutput: ToString,
    fileOutput: ToFile
  ) {
    self.init { path, output in
      switch output {
      case let .string(handler):
        handler(stringOutput(path))
      case let .file(outputPath, handler):
        handler(fileOutput((path, outputPath)))
      }
    }
  }

  public struct ToString: SyncClientOperation {
    public typealias Input = String
    public typealias Output = Result<String, Error>

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature
  }

  public struct ToFile: SyncClientOperation {
    public typealias Input = (String, String)
    public typealias Output = Result<Void, Error>

    public init(_ call: @escaping SyncSignature) {
      self.call = call
    }

    public var call: SyncSignature
  }
}
