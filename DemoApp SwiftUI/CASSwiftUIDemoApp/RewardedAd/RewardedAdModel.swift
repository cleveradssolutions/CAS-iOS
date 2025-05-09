import CleverAdsSolutions

final class RewardedAdModel: NSObject, ObservableObject {
    
    let rewarded = CASRewarded(casID: CASSwiftUIDemoAppApp.casID)
    
    override init() {
        super.init()
        rewarded.delegate = self
        rewarded.isAutoloadEnabled = false
        rewarded.impressionDelegate = self
    }
    
    func loadAd() {
        rewarded.loadAd()
    }
    
    func presentAd(userDidEarnRewardHandler: @escaping CASUserDidEarnRewardHandler) {
        rewarded.present(from: nil, userDidEarnRewardHandler: userDidEarnRewardHandler)
    }
}

extension RewardedAdModel: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function)
    }
}

extension RewardedAdModel: CASScreenContentDelegate {
    func screenAdDidLoadContent(_ ad: any CASScreenContent) {
        print(#function)
    }
    
    func screenAd(_ ad: any CASScreenContent, didFailToLoadWithError error: AdError) {
        print(#function, "Error: \(error.description)")
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
