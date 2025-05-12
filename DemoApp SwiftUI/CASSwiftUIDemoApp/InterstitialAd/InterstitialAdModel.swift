import CleverAdsSolutions

final class InterstitialAdModel: NSObject, ObservableObject {
    let interstitial = CASInterstitial(casID: AppDelegate.casID)
        
    override init() {
        super.init()
        interstitial.delegate = self
        interstitial.impressionDelegate = self
        interstitial.isAutoloadEnabled = false // by default
        interstitial.isAutoshowEnabled = false // by default
        interstitial.minInterval = 0 // by default
    }
    
    func loadAd() {
        interstitial.loadAd()
    }
    
    func presentAd() {
        interstitial.present(from: nil)
    }
}

extension InterstitialAdModel: CASScreenContentDelegate {
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

extension InterstitialAdModel: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function)
    }
}
