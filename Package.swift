// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Some ad frameworks, such as IronSource and UnityAds, do not provide official support Swift Package Manager (SPM). 
// Instead, we created custom Package.swift definitions using the official .zip archives supplied for CocoaPods integration. 
// Below you can find the links to the cocoapods we used for configuring binaryTargets.
//
// - IronSource: https://github.com/CocoaPods/Specs/tree/master/Specs/7/7/b/IronSourceSDK/
// - UnityAds: https://github.com/CocoaPods/Specs/tree/master/Specs/2/e/8/UnityAds/
// - AudienceNetwork: https://github.com/CocoaPods/Specs/blob/master/Specs/2/1/5/FBAudienceNetwork/
// - HyprMX: https://github.com/CocoaPods/Specs/tree/master/Specs/6/7/d/HyprMX/
// - Kidoz: https://github.com/CocoaPods/Specs/tree/master/Specs/2/b/8/KidozSDK/
// - Prado: https://github.com/CocoaPods/Specs/tree/master/Specs/4/f/7/PradoSDK
// - DTExchange: https://github.com/CocoaPods/Specs/tree/master/Specs/1/7/3/Fyber_Marketplace_SDK/
// - InMobi: https://github.com/CocoaPods/Specs/tree/master/Specs/7/8/1/InMobiSDK/
// - YsoNetwork: https://github.com/CocoaPods/Specs/tree/master/Specs/8/a/a/YsoNetworkSDK/
// - Yandex Ads: https://github.com/yandexmobile/yandex-ads-sdk-ios/blob/master/Package.swift
//
// Not supported CAS Adapters:
// - Chartboost: https://github.com/CocoaPods/Specs/tree/master/Specs/5/3/e/ChartboostSDK/
// - BigoAds: https://github.com/CocoaPods/Specs/tree/master/Specs/a/5/5/BigoADS/
// - Pangle: https://github.com/CocoaPods/Specs/tree/master/Specs/d/1/c/Ads-Global/
// - Smaato
// - Ogury
// - SuperAwesome
// - Madex


let package = Package(
    name: "CleverAdsSolutions",
    
    platforms: [.iOS(.v13)],
    
    products: [
        .library(
            name: "CleverAdsSolutionsSPM",
            targets: ["CASBaseResources"]
        ),
        .library(
            name: "CASMediationExchange",
            targets: ["CASMediationExchangeTarget"]
        ),
        .library(
            name: "CASMediationCrossPromo",
            targets: ["CASPromoResources"]
        ),
        .library(
            name: "CASMediationIronSource",
            targets: ["CASMediationIronSourceTarget"]
        ),
        .library(
            name: "CASMediationUnityAds",
            targets: ["CASMediationUnityAdsTarget"]
        ),
        .library(
            name: "CASMediationHyprMX",
            targets: ["CASMediationHyprMXTarget"]
        ),
        .library(
            name: "CASMediationKidoz",
            targets: ["CASMediationKidozTarget"]
        ),
        .library(
            name: "CASMediationPrado",
            targets: ["CASMediationPradoTarget"]
        ),
        .library(
            name: "CASMediationAppLovin",
            targets: ["CASMediationAppLovinTarget"]
        ),
        .library(
            name: "CASMediationGoogleAds",
            targets: ["CASMediationGoogleAdsTarget"]
        ),
        .library(
            name: "CASMediationLiftoffMonetize",
            targets: ["CASMediationLiftoffMonetizeTarget"]
        ),
        .library(
            name: "CASMediationAudienceNetwork",
            targets: ["CASMediationAudienceNetworkTarget"]
        ),
        .library(
            name: "CASMediationStartIO",
            targets: ["CASMediationStartIOTarget"]
        ),
        .library(
            name: "CASMediationMintegral",
            targets: ["CASMediationMintegralTarget"]
        ),
        .library(
            name: "CASMediationDTExchange",
            targets: ["CASMediationDTExchangeTarget"]
        ),
        .library(
            name: "CASMediationInMobi",
            targets: ["CASMediationInMobiTarget"]
        ),
        .library(
            name: "CASMediationYandexAds",
            targets: ["CASMediationYandexAdsTarget"]
        ),
        .library(
            name: "CASMediationYsoNetwork",
            targets: ["CASMediationYsoNetworkTarget"]
        ),
        .library(
            name: "CASMediationPangle",
            targets: ["CASMediationPangleTarget"]
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "12.7.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.5.1"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "7.7.8"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.3.1"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "7.2.0-release.5"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", exact: "5.0.0"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.10.5"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.11.0"..<"6.0.0"),
    ],
    
    targets: [
        .target(
            name: "CASBaseResources",
            dependencies: [
                .target(name: "CleverAdsSolutions"),
            ],
            path: "SPMSources/CASBaseResources",
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreLocation"),
                .linkedFramework("Foundation"),
                .linkedFramework("Network"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("UIKit"),
                .linkedFramework("WebKit")
            ]
        ),
        .target(
            name: "CASPromoResources",
            dependencies: [
                .target(name: "CASMediationCrossPromo"),
                .target(name: "CASBaseResources")
            ],
            path: "SPMSources/CASPromoResources",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CASMediationExchangeTarget",
            dependencies: [
                .target(name: "CASMediationExchange"),
                .target(name: "CASBaseResources")
            ],
            path: "Adapters/CASExchange",
            linkerSettings: [
                .linkedFramework("SafariServices"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreLocation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("QuartzCore")
            ]
        ),

        .target(
            name: "IronSourceSPMTarget",
            dependencies: [
                .target(name: "IronSourceSPM")
            ],
            path: "SPMSources/IronSourceSPMTarget",
            linkerSettings: [
                .linkedFramework("AdSupport"),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CFNetwork"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("Foundation"),
                .linkedFramework("MobileCoreServices"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("Security"),
                .linkedFramework("StoreKit"),
                .linkedFramework("SystemConfiguration"),
                .linkedLibrary("z")
            ]
        ),
        .target(
            name: "CASMediationIronSourceTarget",
            dependencies: [
                .target(name: "IronSourceSPMTarget"),
                .target(name: "CASMediationIronSource"),
                .target(name: "CASBaseResources")                
            ],
            path: "Adapters/IronSource"
        ),
        
        .target(
            name: "UnityAdsSPMTarget",
            dependencies: [
                .target(name: "UnityAdsSPM")
            ],
            path: "SPMSources/UnityAdsSPMTarget",
            linkerSettings: [
                .linkedFramework("AdSupport"),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("WebKit"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Foundation"),
                .linkedFramework("MobileCoreServices"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("Network"),
                .linkedFramework("StoreKit"),
                .linkedFramework("AVFAudio"),
                .linkedFramework("SystemConfiguration")
            ]
        ),
        .target(
            name: "CASMediationUnityAdsTarget",
            dependencies: [
                .target(name: "UnityAdsSPMTarget"),
                .target(name: "CASMediationUnityAds"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget")
            ],
            path: "Adapters/UnityAds"
        ),
        
        .target(
            name: "AudienceNetworkSPMTarget",
            dependencies: [
                .target(name: "AudienceNetworkSPM")
            ],
            path: "SPMSources/AudienceNetworkSPMTarget",
            linkerSettings: [
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AppTrackingTransparency"),
                .linkedFramework("StoreKit"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("Security"),
                .linkedFramework("CoreImage"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("AdSupport"),
                .linkedFramework("CFNetwork"),
                .linkedFramework("CoreMotion"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("LocalAuthentication"),
                .linkedFramework("SafariServices"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("VideoToolbox"),
                .linkedFramework("WebKit"),
                .linkedLibrary("c++"),
                .linkedLibrary("xml2"),
                .linkedLibrary("z")
            ]
        ),
        .target(
            name: "CASMediationAudienceNetworkTarget",
            dependencies: [
                .target(name: "AudienceNetworkSPMTarget"),
                .target(name: "CASMediationAudienceNetwork"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationGoogleAdsTarget")
            ],
            path: "Adapters/AudienceNetwork"
        ),

        .target(
            name: "HyprMXSPMTarget",
            dependencies: [
                .target(name: "HyprMXSPM")
            ],
            path: "SPMSources/HyprMXSPMTarget"
        ),
        .target(
            name: "CASMediationHyprMXTarget",
            dependencies: [
                .target(name: "CASMediationHyprMX"),
                .target(name: "HyprMXSPMTarget"),
                .target(name: "CASBaseResources")                
            ],
            path: "Adapters/HyprMX"
        ),
        .target(
            name: "KidozSPMTarget",
            dependencies: [
                .target(name: "KidozSPM")
            ],
            path: "SPMSources/KidozSPMTarget",
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
        .target(
            name: "CASMediationKidozTarget",
            dependencies: [
                .target(name: "CASMediationKidoz"),
                .target(name: "KidozSPMTarget"),
                .target(name: "CASBaseResources"),
            ],
            path: "Adapters/Kidoz"
        ),

        .target(
            name: "PradoSPMTarget",
            dependencies: [
                .target(name: "PradoSPM")
            ],
            path: "SPMSources/PradoSPMTarget",
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
        .target(
            name: "CASMediationPradoTarget",
            dependencies: [
                .target(name: "CASMediationPrado"),
                .target(name: "PradoSPMTarget"),
                .target(name: "CASBaseResources"),
            ],
            path: "Adapters/Prado"
        ),
        
        .target(
            name: "CASMediationAppLovinTarget",
            dependencies: [
                .target(name: "CASMediationAppLovin"),
                .target(name: "CASBaseResources"),
                .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package")
            ],
            path: "Adapters/AppLovin"
        ),
        .target(
            name: "CASMediationGoogleAdsTarget",
            dependencies: [
                .target(name: "CASMediationGoogleAds"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Adapters/GoogleAds"
        ),
        .target(
            name: "CASMediationLiftoffMonetizeTarget",
            dependencies: [
                .target(name: "CASMediationLiftoffMonetize"),
                .target(name: "CASBaseResources"),
                .product(name: "VungleAdsSDK", package: "VungleAdsSDK-SwiftPackageManager")
            ],
            path: "Adapters/LiftoffMonetize"
        ),
        
        .target(
            name: "CASMediationStartIOTarget",
            dependencies: [
                .target(name: "CASMediationStartIO"),
                .target(name: "CASBaseResources"),
                .product(name: "StartApp", package: "StartAppSDK-SwiftPackage")
            ],
            path: "Adapters/StartIO"
        ),
        .target(
            name: "CASMediationMintegralTarget",
            dependencies: [
                .target(name: "CASMediationMintegral"),
                .target(name: "CASBaseResources"),
                .product(name: "MintegralAdSDK", package: "MintegralAdSDK-Swift-Package")
            ],
            path: "Adapters/Mintegral"
        ),
        
        .target(
            name: "DTExchangeSPMTarget",
            dependencies: [
                .target(name: "DTExchangeSPM")
            ],
            path: "SPMSources/DTExchangeSPMTarget"
        ),
        .target(
            name: "CASMediationDTExchangeTarget",
            dependencies: [
                .target(name: "DTExchangeSPMTarget"),
                .target(name: "CASMediationDTExchange"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget")
            ],
            path: "Adapters/DTExchange"
        ),
        
        .target(
            name: "InMobiSPMTarget",
            dependencies: [
                .target(name: "InMobiSPM")
            ],
            path: "SPMSources/InMobiSPMTarget",
            linkerSettings: [
                .linkedLibrary("sqlite3.0"),
                .linkedFramework("WebKit")
            ]
        ),
        .target(
            name: "CASMediationInMobiTarget",
            dependencies: [
                .target(name: "InMobiSPMTarget"),
                .target(name: "CASMediationInMobi"),
                .target(name: "CASBaseResources")                
            ],
            path: "Adapters/InMobi"
        ),
        
        .target(
            name: "YandexAdsSPMTarget",
            dependencies: [
                .target(name: "YandexAdsSPM"),
                
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade")
            ],
            path: "SPMSources/YandexAdsSPMTarget",
            resources: [
                .process("Resources")
            ],
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("AdSupport"),
                .linkedFramework("AppTrackingTransparency"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreImage"),
                .linkedFramework("CoreLocation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("CoreText"),
                .linkedFramework("Foundation"),
                .linkedFramework("Network"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("StoreKit"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("UIKit"),
                .linkedFramework("WebKit")
            ]
        ),
        .target(
            name: "CASMediationYandexAdsTarget",
            dependencies: [
                .target(name: "YandexAdsSPMTarget"),
                .target(name: "CASMediationYandexAds"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget")
            ],
            path: "Adapters/YandexAds"
        ),
                                
        .target(
            name: "YsoNetworkSPMTarget",
            dependencies: [
                .target(name: "YsoNetworkSPM")
            ],
            path: "SPMSources/YsoNetworkSPMTarget"
        ),
        .target(
            name: "CASMediationYsoNetworkTarget",
            dependencies: [
                .target(name: "YsoNetworkSPMTarget"),
                .target(name: "CASMediationYsoNetwork"),
                .target(name: "CASBaseResources")                
            ],
            path: "Adapters/YsoNetwork"
        ),

        .target(
            name: "CASMediationPangleTarget",
            dependencies: [
                .target(name: "CASMediationPangle"),
                .target(name: "CASBaseResources"),
                .product(name: "AdsGlobalPackage", package: "AdsGlobalPackage")
            ],
            path: "Adapters/Pangle"
        ),
                        
        .binaryTarget(
            name: "CleverAdsSolutions",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CleverAdsSolutions-4.2.1.zip",
            checksum: "04678c92eb90a7f0d75d24d84e0fd41287796bec183dfeafdd9684a473321ad5"
        ),
                
        .binaryTarget(
            name: "IronSourceSPM",
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/8.10.0/IronSource8.10.0.zip",
            checksum: "75f6acb4803e3c4574be3fd5a2fdeff9e0c33526bb37e772153d2c5df5141c49"
        ),
        .binaryTarget(
            name: "CASMediationIronSource",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationIronSource-8.10.0.0.zip",
            checksum: "9ae626420c3f93f7449cc1e5c3fccd1c12b523c805ee9bad448788c53fc09157"
        ),
        
        .binaryTarget(
            name: "UnityAdsSPM",
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.15.1/UnityAds.zip",
            checksum: "14bf337196be779f91f894c6bc919b3394cf599a6c3a2e3da434773906b68a68"
        ),
        .binaryTarget(
            name: "CASMediationUnityAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationUnityAds-4.15.1.0.zip",
            checksum: "83cdcbf2c63fb9acb95718225b292a56edc0a76b2246cd0347653ffa7361ca32"
        ),
        
        .binaryTarget(
            name: "HyprMXSPM",
            url: "https://s3.amazonaws.com/cocoapods-files/HyprMX/6.4.3/HyprMX_iOS_v6-4-3.zip",
            checksum: "c2c67e12607f01532b608690743e39f1d747b6d92eccf56d3d41085e14393f99"
        ),
        .binaryTarget(
            name: "CASMediationHyprMX",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationHyprMX-6.4.3.0.zip",
            checksum: "ede6b8d272fc8845745e1811804746fb15b3c29d80da792d05a77c5b96395614"
        ),
        
        .binaryTarget(
            name: "KidozSPM",
            url: "https://github.com/Kidoz-SDK/kidoz-ios-frameworks/raw/main/KidozSDK/10.0.3/KidozSDK-10.0.3.zip",
            checksum: "39f86c116b28b3c036293e9a1a16b321ea3af73698179a8b7cbc37f91b44a7cc"
        ),
        .binaryTarget(
            name: "CASMediationKidoz",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.2/CASMediationKidoz-10.0.3.0.zip",
            checksum: "1b5d544c32308ddf4cfb1d8a8c9391ea978f393f99c35a9b82ba4332e674d37b"
        ),

        .binaryTarget(
            name: "PradoSPM",
            url: "https://github.com/Prado-SDK/prado-ios-frameworks/raw/main/PradoSDK/10.0.3/PradoSDK-10.0.3.zip",
            checksum: "83e82bf43feef381d0fac39153af6a9db0977e9bb8b7578322ead43bf7e1887b"
        ),
        .binaryTarget(
            name: "CASMediationPrado",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.2/CASMediationPrado-10.0.3.0.zip",
            checksum: "2f468ae5242cf8b7d00ecc46b7a49bdfb3085866e5a5b2f0add25a9a7b3a4fff"
        ),
        
        .binaryTarget(
            name: "CASMediationAppLovin",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationAppLovin-13.3.1.2.zip",
            checksum: "b397716ec4eec569c108a5f5cb3edfa5c71b6c4be25e27c315f52363911cbf6e"
        ),
        .binaryTarget(
            name: "CASMediationGoogleAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationGoogleAds-12.7.0.0.zip",
            checksum: "7fc801d65141cde7845d3ff166e91e98b218752d21508b6227c941777082272f"
        ),
        .binaryTarget(
            name: "CASMediationLiftoffMonetize",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationLiftoffMonetize-7.5.1.1.zip",
            checksum: "36f2258078f065802284542b27b1f7adefb9b32351595c200282e0f00a198c1e"
        ),
        
        .binaryTarget(
            name: "CASMediationStartIO",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationStartIO-4.10.5.1.zip",
            checksum: "ef4782d5bc96d77704c26ac0cadbc5c4571fe8c185993baab006088e9f9b6f56"
        ),
        .binaryTarget(
            name: "CASMediationMintegral",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationMintegral-7.7.8.2.zip",
            checksum: "4db1531bb084fd97ffbd7880d397ecfc9f0e469b439e99874db1af4c1c1b288f"
        ),
        .binaryTarget(
            name: "DTExchangeSPM",
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.3.7.zip",
            checksum: "bbf3ec0949f89c5b4a7922c4584417293bf56e8489725118a757d3e5dea0fe8a"
        ),
        .binaryTarget(
            name: "CASMediationDTExchange",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationDTExchange-8.3.7.1.zip",
            checksum: "b9d2f606bf765b970ceda5df2367781569f6c3ddb230c4e3d3ce276cd2425a06"
        ),
        .binaryTarget(
            name: "CASMediationExchange",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationExchange-4.2.0.0.zip",
            checksum: "37d4f32c3d5accd5e9a8e62836df3089f70a53d1a453cedbcba66c5c5a3d7c80"
        ),
        .binaryTarget(
            name: "CASMediationCrossPromo",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationCrossPromo-4.1.0.0.zip",
            checksum: "ddd50c5be23d1da33b1ac7799d3e12d08635687425055e07bb9a2a387b8a32e0"
        ),
        .binaryTarget(
            name: "InMobiSPM",
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-10.8.3.zip",
            checksum: "faeeb442837927a744951511db9f5a554032e47a12a235fd8368c84496db6cf6"
        ),
        .binaryTarget(
            name: "CASMediationInMobi",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationInMobi-10.8.3.2.zip",
            checksum: "1bf58ff3c5d22069bacc4a7a252030085d3396092673763a6d3aef9e0ef0ad3c"
        ),
        
        .binaryTarget(
            name: "YandexAdsSPM",
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.14.1/YandexMobileAds.zip",
            checksum: "efa9f7b3885615d843f6ab5720c70b12cbf35bf2766df8c6de6cc7160ac1d92c"
        ),
        .binaryTarget(
            name: "CASMediationYandexAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationYandexAds-7.14.1.0.zip",
            checksum: "d1eba2c39bbbf5812142abd2ee5f0bd7eae006362e2667b0827d2bede9af209a"
        ),

        .binaryTarget(
            name: "YsoNetworkSPM",
            url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk/get/794e6daf0ed2dc2f237714f4e86d24de7a888a63.zip",
            checksum: "237087e30b6382f0ff11b53b2c892f213d0fb34e6bf5aec3810316a3728dc978"
        ),
        .binaryTarget(
            name: "CASMediationYsoNetwork",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationYsoNetwork-1.1.31.2.zip",
            checksum: "a8b70539b115757e8784fbc0109884e6c7451ca2d50c3bcb03e858e96921c561"
        ),

        .binaryTarget(
            name: "AudienceNetworkSPM",
            url: "https://developers.facebook.com/resources/FBAudienceNetwork-6.20.0.zip",
            checksum: "718083a8c51d11983a297689a26825a1f77f767cfb43f71a7d0bc6c58037d576"
        ),
        .binaryTarget(
            name: "CASMediationAudienceNetwork",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationAudienceNetwork-6.20.0.2.zip",
            checksum: "f502fc936f3ea2c975b5122aa2aa0d0f79e15c87eaf9348805e88d5588f6f709"
        ),

        .binaryTarget(
            name: "CASMediationPangle",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationPangle-7.4.0.8.1.zip",
            checksum: "be01b8abaa31ea54f6cd859f23bbb0adf5e9316f74b7e9f9edc58fbd6190bbdc"
        )
    ]
)
