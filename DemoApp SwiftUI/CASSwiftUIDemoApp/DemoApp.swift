import CleverAdsSolutions
import SwiftUI

@main
struct CASSwiftUIDemoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
