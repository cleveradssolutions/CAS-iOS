//
//  ViewController.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

class ViewController: UIViewController, CASLoadDelegate, CASAppReturnDelegate {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var lastBannerLabel: UILabel!
    @IBOutlet var lastInterstitialLabel: UILabel!
    @IBOutlet var lastRewardedInfo: UILabel!
    @IBOutlet var bannerView: CASBannerView!
    
    @IBOutlet var statusAppReturnLabel: UILabel!
    @IBOutlet var enableAppReturnButton: UIButton!
    
    private let bannerDelegate = AdContentDelegate(type: .banner)
    private let interDelegate = AdContentDelegate(type: .interstitial)
    private let rewardDelegate = AdContentDelegate(type: .rewarded)
    
    private var isAppReturnEnabled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = CAS.getSDKVersion()

        // Get last initialized CAS Manager.
        let manager = CAS.manager!

        manager.adLoadDelegate = self

        // CASBannerView created in Storyboard else use createBannerAdView() to create
        // createBannerAdView(manager)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = self
        bannerView.delegate = bannerDelegate

        bannerDelegate.infoLabel = lastBannerLabel
        interDelegate.infoLabel = lastInterstitialLabel
        rewardDelegate.infoLabel = lastRewardedInfo

        lastBannerLabel.text = manager.getLastActiveMediation(type: .banner)
        lastInterstitialLabel.text = manager.getLastActiveMediation(type: .interstitial)
        lastRewardedInfo.text = manager.getLastActiveMediation(type: .rewarded)
    }

    func createBannerAdView(_ manager: CASMediationManager) {
        bannerView = CASBannerView(manager: manager)
        view.addSubview(bannerView)

        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                bannerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bannerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        }
    }

    @IBAction func showBanner(_ sender: Any) {
        bannerView.isHidden = false
    }

    @IBAction func hideBanner(_ sender: Any) {
        bannerView.isHidden = true
    }

    @IBAction func setBannerSize(_ sender: Any) {
        bannerView.adSize = .banner
    }

    @IBAction func setLeaderboardSize(_ sender: Any) {
        bannerView.adSize = .leaderboard
    }

    @IBAction func setMrecSize(_ sender: Any) {
        bannerView.adSize = .mediumRectangle
    }

    @IBAction func setAdaptiveSize(_ sender: Any) {
        bannerView.adSize = .getAdaptiveBanner(inContainer: view)
    }

    @IBAction func setSmartSize(_ sender: Any) {
        bannerView.adSize = .getSmartBanner()
    }

    @IBAction func showInterstitial(_ sender: Any) {
        CAS.manager?.presentInterstitial(fromRootViewController: self, callback: interDelegate)
    }

    @IBAction func showRewarded(_ sender: Any) {
        CAS.manager?.presentRewardedAd(fromRootViewController: self, callback: rewardDelegate)
    }
    
    @IBAction func changeStateOfAppReturn(_ sender: Any) {
        if (isAppReturnEnabled) {
            enableAppReturnButton.setTitle("Enable", for: UIControl.State.normal)
            statusAppReturnLabel.text = "Disabled"
            CAS.manager?.disableAppReturnAds()
            isAppReturnEnabled = false
        } else {
            enableAppReturnButton.setTitle("Disable", for: UIControl.State.normal)
            statusAppReturnLabel.text = "Enabled"
            CAS.manager?.enableAppReturnAds(with: self)
            isAppReturnEnabled = true
        }
    }
    
    func onAdLoaded(_ adType: CASType) {
        print("[CAS Sample] \(adType.description) Ad loaded and ready to show")
    }

    func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        print("[CAS Sample] \(adType.description) Ad failed to load with error: \(String(describing: error))")
    }
    
    // Implement the method to pass active UIViewController
    func viewControllerForPresentingAppReturnAd() -> UIViewController {
        return self
    }
}
