//
//  BannerVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class BannerVC: UIViewController {
            
    @IBOutlet var loadButton: UIButton!
    @IBOutlet var bannerSizeButton: UIButton!
    @IBOutlet var bannerView: CASBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setupBannerButton()
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Banner Ad"
    }
        
    private func setupBanner() {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.impressionDelegate = self
        bannerView.casID = AppDelegate.casId
        bannerView.adSize = .getAdaptiveBanner(inContainer: view)
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
    }
        
    private func setupBannerButton() {
        let bannerMenu = UIMenu(children: [
            UIAction(title: "Adaptive", handler: { action in
                self.bannerView.adSize = .getAdaptiveBanner(inContainer: self.view)
                self.bannerSizeButton.setTitle("Adaptive", for: .normal)
            }),
            UIAction(title: "Standard 320x50", handler: { action in
                self.bannerView.adSize = .banner
                self.bannerSizeButton.setTitle("Standard", for: .normal)
            }),
            UIAction(title: "Leaderboard 728x90", handler: { action in
                self.bannerView.adSize = .leaderboard
                self.bannerSizeButton.setTitle("Leaderboard", for: .normal)
            }),
            UIAction(title: "Medium 300x250", handler: { action in
                self.bannerView.adSize = .mediumRectangle
                self.bannerSizeButton.setTitle("Medium", for: .normal)
            }),
            UIAction(title: "Smart 320x50 or 728x90", handler: { action in
                self.bannerView.adSize = .getSmartBanner()
                self.bannerSizeButton.setTitle("Smart", for: .normal)
            })
        ])
        
        bannerSizeButton.menu = bannerMenu
        bannerSizeButton.showsMenuAsPrimaryAction = true
    }
      
    @IBAction private func loadAction(_ sender: UIButton) {
        bannerView.loadAd()
    }
}

extension BannerVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension BannerVC: CASBannerDelegate {
    func bannerAdViewDidLoad(_ view: CASBannerView) {
        print(#function)
    }
    
    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        print(#function, "Error: \(error.description)")
    }
    
    func bannerAdView(_ adView: CASBannerView, willPresent impression: any CASImpression) {
        print(#function)
    }
    
    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        print(#function)
    }
}
