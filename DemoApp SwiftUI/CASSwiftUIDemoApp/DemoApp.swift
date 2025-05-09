import CleverAdsSolutions
import SwiftUI

@main
struct CASSwiftUIDemoAppApp: App {
    static let casID = "demo"

    init() {
        initializeCAS()
    }

    func initializeCAS() {
        let builder = CAS.buildManager()
        builder.withCompletionHandler { config in
            let _: String? = config.error
            let _: String? = config.countryCode
            let _: Bool = config.isConsentRequired
            let _: Bool = config.isATTrackingAuthorized
            let _: CASConsentFlowStatus = config.consentFlowStatus
        }
        #if DEBUG
            builder.withTestAdMode(true)
        #endif

        builder.create(withCasId: CASSwiftUIDemoAppApp.casID)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
