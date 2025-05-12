import CleverAdsSolutions

class AppDelegate: UIResponder, UIApplicationDelegate{
    static let casID: String = "123456789"
    
    var window: UIWindow? // required for some mediated ads frameworks
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        initializeCAS()
        return true
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

        builder.create(withCasId: AppDelegate.casID)
    }
}
