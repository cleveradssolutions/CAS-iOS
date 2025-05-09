//
//  NativeVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class NativeVC: UIViewController {
            
    @IBOutlet var loadButton: UIButton!
    // Native UI
    @IBOutlet var nativeContainerView: CASNativeView!
    @IBOutlet var adStackView: UIStackView!
    @IBOutlet var adLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var mediaView: CASMediaView!
    @IBOutlet var actionButton: UIButton!
            
    private var nativeLoader = CASNativeLoader(casID: AppDelegate.casId)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderSetup()
        registerAssetViews()
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Native Ad"
    }        
        
    private func loaderSetup() {
        nativeLoader.delegate = self
        nativeLoader.adChoicesPlacement = AdChoicesPlacement.topRight // by default
        nativeLoader.isStartVideoMuted = true // by default
    }
  
    private func registerAssetViews() {
        nativeContainerView.headlineView = headlineLabel
        nativeContainerView.bodyView = bodyLabel
        nativeContainerView.iconView = iconView
        nativeContainerView.mediaView = mediaView
        nativeContainerView.callToActionView = actionButton
    }
    
    @IBAction private func loadAction(_ sender: UIButton) {
        nativeLoader.loadAd()
    }
}

extension NativeVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension NativeVC: CASNativeLoaderDelegate {
    func nativeAdDidLoadContent(_ ad: NativeAdContent) {
        ad.delegate = self
        ad.impressionDelegate = self
        ad.rootViewController = self
        nativeContainerView.setNativeAd(ad)
        print(#function)
    }
  
    func nativeAdDidFailToLoad(error: AdError) {
        print(#function, "Error: \(error.description)")
    }
}

extension NativeVC: CASNativeContentDelegate {
    func nativeAd(_ ad: NativeAdContent, didFailToPresentWithError error: AdError) {
        print(#function, "Error: \(error.description)")
    }
    
    func nativeAdDidClickContent(_ ad: NativeAdContent) {
        print(#function)
    }
}
