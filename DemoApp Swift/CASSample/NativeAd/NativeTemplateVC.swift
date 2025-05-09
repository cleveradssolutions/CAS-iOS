//
//  NativeTemplateVC.swift
//  CASSample
//
//  Copyright © 2025 Clever Ads Solutions. All rights reserved.
//

import UIKit
import CleverAdsSolutions

class NativeTemplateVC: UIViewController {
    
    @IBOutlet var loadButton: UIButton!
    @IBOutlet weak var adView: CASNativeView!
    
    private var nativeLoader = CASNativeLoader(casID: AppDelegate.casId)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sizeSetup()
        loaderSetup()
        customizeAdViewAppearance()
        //
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Native Template Ad"
    }
    
    private func sizeSetup() {
        let size = AdSize.mediumRectangle
        adView.setAdTemplateSize(size)
    }
    
    private func loaderSetup() {
        nativeLoader.delegate = self
        nativeLoader.adChoicesPlacement = AdChoicesPlacement.topRight // by default
        nativeLoader.isStartVideoMuted = true
    }
    
    private func customizeAdViewAppearance() {
        // Default values are shown below:
        adView.backgroundColor = UIColor.white
        adView.headlineView?.textColor = UIColor.red
    }
    
    @IBAction private func loadAction(_ sender: UIButton) {
        nativeLoader.loadAd()
    }
}

extension NativeTemplateVC: CASImpressionDelegate {
    func adDidRecordImpression(info: AdContentInfo) {
        print(#function, "Ad Source: \(info.sourceName)")
    }
}

extension NativeTemplateVC: CASNativeLoaderDelegate {
    func nativeAdDidLoadContent(_ ad: NativeAdContent) {
        ad.delegate = self
        ad.impressionDelegate = self
        ad.rootViewController = self
        adView.setNativeAd(ad)
        print(#function)
    }
  
    func nativeAdDidFailToLoad(error: AdError) {
        print(#function, "Error: \(error.description)")
    }
}

extension NativeTemplateVC: CASNativeContentDelegate {
    func nativeAd(_ ad: NativeAdContent, didFailToPresentWithError error: AdError) {
        print(#function, "Error: \(error.description)")
    }
    
    func nativeAdDidClickContent(_ ad: NativeAdContent) {
        print(#function)
    }
}
