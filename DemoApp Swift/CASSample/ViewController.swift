//
//  ViewController.swift
//  CASSample
//
//  Copyright © 2022 Clever Ads Solutions. All rights reserved.
//

import CleverAdsSolutions
import UIKit

class ViewController: UIViewController, CASLoadDelegate, CASAppReturnDelegate {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var bannerView: CASBannerView!

    @IBOutlet var statusBannerLabel: UILabel!
    @IBOutlet var statusInterstitialLabel: UILabel!
    @IBOutlet var statusRewardedLabel: UILabel!
    @IBOutlet var statusAppReturnLabel: UILabel!
    @IBOutlet var enableAppReturnButton: UIButton!

    private var manager: CASMediationManager!

    private let bannerDelegate = BannerAdDelegate()
    private let interDelegate = AdContentDelegate(type: .interstitial)
    private let rewardDelegate = AdContentDelegate(type: .rewarded)

    private var isAppReturnEnabled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = CAS.getSDKVersion()

        // Get last initialized CAS Manager.
        let lastManager = AppDelegate.mediationManager!
        manager = lastManager
        lastManager.adLoadDelegate = self

        // CASBannerView created in Storyboard else use createBannerAdView() to create
        // createBannerAdView(lastManager)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adSize = CASSize.getSmartBanner()
        bannerView.adDelegate = bannerDelegate
        bannerView.rootViewController = self

        bannerDelegate.infoLabel = statusBannerLabel

        statusBannerLabel.text = bannerView.isAdReady ? "Ready" : "Laoding"
        statusInterstitialLabel.text = lastManager.isInterstitialReady ? "Ready" : "Laoding"
        statusRewardedLabel.text = lastManager.isRewardedAdReady ? "Ready" : "Laoding"
    }

    func createBannerAdView(_ manager: CASMediationManager) {
        bannerView = CASBannerView(adSize: CASSize.getSmartBanner(), manager: manager)
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
        manager.presentInterstitial(fromRootViewController: self,
                                    callback: interDelegate)
    }

    @IBAction func showRewarded(_ sender: Any) {
        manager.presentRewardedAd(fromRootViewController: self,
                                  callback: rewardDelegate)
    }

    @IBAction func changeStateOfAppReturn(_ sender: Any) {
        if isAppReturnEnabled {
            enableAppReturnButton.setTitle("Enable", for: UIControl.State.normal)
            statusAppReturnLabel.text = "Disabled"
            manager?.disableAppReturnAds()
            isAppReturnEnabled = false
        } else {
            enableAppReturnButton.setTitle("Disable", for: UIControl.State.normal)
            statusAppReturnLabel.text = "Enabled"
            manager?.enableAppReturnAds(with: self)
            isAppReturnEnabled = true
        }
    }

    // MARK: CASLoadDelegate implementation

    func onAdLoaded(_ adType: CASType) {
        // CASLoadDelegate called from background thread. To use UI API we switch to main thread.
        DispatchQueue.main.async {
            switch adType {
            case .interstitial:
                print("[CAS Sample] Interstitial Ad loaded and ready to present")
                self.statusInterstitialLabel.text = "Ready"
            case .rewarded:
                print("[CAS Sample] Rewarded Ad loaded and ready to present")
                self.statusRewardedLabel.text = "Ready"
            case .banner:
                // CASLoadDelegate protocol should be used to listen Interstitial and Rewarded Ads only.
                // Listen Banner ads by CASBannerDelegate protocol.
                break
            default: break
            }
        }
    }

    func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        // CASLoadDelegate called from background thread. To use UI API we switch to main thread.
        DispatchQueue.main.async {
            switch adType {
            case .interstitial:
                print("[CAS Sample] Interstitial Ad failed to load with error: \(String(describing: error))")
                self.statusInterstitialLabel.text = error ?? "Failed"
            case .rewarded:
                print("[CAS Sample] Rewarded Ad failed to load with error: \(String(describing: error))")
                self.statusRewardedLabel.text = error ?? "Failed"
            case .banner:
                // CASLoadDelegate protocol should be used to listen Interstitial and Rewarded Ads only.
                // Listen Banner ads by CASBannerDelegate protocol.
                break
            default: break
            }
        }
    }

    // MARK: CASAppReturnDelegate implementation

    // Implement the method to pass active UIViewController
    func viewControllerForPresentingAppReturnAd() -> UIViewController {
        return self
    }
}
