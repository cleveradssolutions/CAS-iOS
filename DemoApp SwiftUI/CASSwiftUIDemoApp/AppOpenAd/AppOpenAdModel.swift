import CleverAdsSolutions

final class AppOpenAdModel: NSObject, ObservableObject {
    let appOpen = CASAppOpen(casID: AppDelegate.casID)
        
    override init() {
        super.init()
        appOpen.delegate = self
        appOpen.impressionDelegate = self
        appOpen.isAutoloadEnabled = false // by default
        appOpen.isAutoshowEnabled = false // by default
    }
    
    func loadAd() {
        appOpen.loadAd()
    }
    
    func presentAd() {
        appOpen.present(from: nil)
    }
}

extension AppOpenAdModel: CASScreenContentDelegate {
    func screenAdDidLoadContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAd(_ ad: any CASScreenContent, didFailToLoadWithError error: AdError) {
        print(#function, "Error: \(error.description)")
        
        // isAutoloadEnabled can do retry with delay automatically
    }
    
    func screenAdWillPresentContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAd(_ ad: any CASScreenContent, didFailToPresentWithError error: AdError) {
        print(#function, "Error: \(error.description)")
    }
    
    func screenAdDidClickContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAdDidDismissContent(_ ad: any CASScreenContent) {
        print(#function)
    }
}

extension AppOpenAdModel: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function)
    }
}
