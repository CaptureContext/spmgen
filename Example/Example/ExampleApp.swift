import SwiftUI
import AppFeature

@main
struct ExampleApp: App {
  #if os(iOS)
  @UIApplicationDelegateAdaptor
  var appDelegate: AppDelegate
  #elseif os(macOS)
  @NSApplicationDelegateAdaptor
  var appDelegate: AppDelegate
  #endif

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
