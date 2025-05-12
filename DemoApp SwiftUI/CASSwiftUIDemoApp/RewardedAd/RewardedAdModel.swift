import CleverAdsSolutions

final class RewardedAdModel: NSObject, ObservableObject {
    let rewarded = CASRewarded(casID: AppDelegate.casID)
    
    override init() {
        super.init()
        rewarded.delegate = self
        rewarded.impressionDelegate = self
        rewarded.isAutoloadEnabled = false // by default
        rewarded.isExtraFillInterstitialAdEnabled = true // by default
    }
    
    func loadAd() {
        rewarded.loadAd()
    }
    
    func presentAd(userDidEarnRewardHandler: @escaping CASUserDidEarnRewardHandler) {
        rewarded.present(from: nil, userDidEarnRewardHandler: userDidEarnRewardHandler)
    }
}

extension RewardedAdModel: CASScreenContentDelegate {
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

extension RewardedAdModel: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function)
    }
}
