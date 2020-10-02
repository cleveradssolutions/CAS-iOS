//
//  ViewController.swift
//  CASSample
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

class ViewController: UIViewController, CASLoadDelegate {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var lastBannerLabel: UILabel!
    @IBOutlet var lastInterstitialLabel: UILabel!
    @IBOutlet var lastRewardedInfo: UILabel!
    @IBOutlet var bannerView: CASBannerView!

    private var bannerDelegate = AdDelegate(type: .banner)
    private var interDelegate = AdDelegate(type: .interstitial)
    private var rewardDelegate = AdDelegate(type: .rewarded)

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = CAS.getSDKVersion()
        CAS.manager?.adLoadDelegate = self

//        bannerView = CASBannerView(manager: CAS.manager!)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.rootViewController = self
        bannerView.delegate = bannerDelegate
//        view.addSubview(bannerView)

//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            NSLayoutConstraint.activate([
//                bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
//                bannerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
//            ])
//        } else {
//            NSLayoutConstraint.activate([
//                bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//                bannerView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            ])
//        }

        bannerView.adPostion = CASPosition.bottomCenter

        bannerDelegate.lastInfo = lastBannerLabel
        interDelegate.lastInfo = lastInterstitialLabel
        rewardDelegate.lastInfo = lastRewardedInfo

        lastBannerLabel.text = CAS.manager?.getLastActiveMediation(type: .banner)
        lastInterstitialLabel.text = CAS.manager?.getLastActiveMediation(type: .interstitial)
        lastRewardedInfo.text = CAS.manager?.getLastActiveMediation(type: .rewarded)
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
        CAS.manager?.show(fromRootViewController: self, type: .interstitial, callback: interDelegate)
    }

    @IBAction func showRewarded(_ sender: Any) {
        CAS.manager?.show(fromRootViewController: self, type: .rewarded, callback: rewardDelegate)
    }

    func onAdLoaded(_ adType: CASType) {
        print("[CAS Sample] \(adType.description) Ad loaded and ready to show")
    }

    func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        print("[CAS Sample] \(adType.description) Ad failed to load with error: \(String(describing: error))")
    }
}
