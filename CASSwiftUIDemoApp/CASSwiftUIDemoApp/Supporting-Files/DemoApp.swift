import CleverAdsSolutions
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    var adManager: CASMediationManager!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        CAS.settings.debugMode = true
        CAS.settings.taggedAudience = .notChildren

        adManager = AppDelegate.createAdManager(forTest: true)

        return true
    }

    static func createAdManager(forTest testMode: Bool = true) -> CASMediationManager {
        return CAS.buildManager()
            .withTestAdMode(testMode)
            .create(withCasId: "demo")
    }
}

@main
struct CASSwiftUIDemoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(
                adViewState: AdViewState(manager: appDelegate.adManager)
            )
        }
    }
}
