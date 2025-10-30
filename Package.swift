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
// - Yango Ads: https://github.com/yandexmobile/yandex-ads-sdk-ios/blob/master/Package.swift
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
            name: "CASMediationYangoAds",
            targets: ["CASMediationYangoAdsTarget"]
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
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "12.12.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.6.1"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "7.7.9"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.5.0"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "7.6.0-release.6"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", .upToNextMinor(from: "5.2.0")),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.11.0"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "5.12.1")),
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
                .target(name: "IronSourceSPM"),
                .target(name: "IronSourceAdQualitySPM")
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
            name: "YangoAdsSPMTarget",
            dependencies: [
                .target(name: "YangoAdsSPM"),
                
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade")
            ],
            path: "SPMSources/YangoAdsSPMTarget",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "CASMediationYangoAdsTarget",
            dependencies: [
                .target(name: "YangoAdsSPMTarget"),
                .target(name: "CASMediationYangoAds"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget")
            ],
            path: "Adapters/YangoAds"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CleverAdsSolutions-4.4.1.zip",
            checksum: "4534108492a71c4dadc92a7bd3570ae9457d2d1c1098d19ea6526eca4b404bf7"
        ),
                
        .binaryTarget(
            name: "IronSourceSPM",
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/9.0.0/IronSource9.0.0.zip",
            checksum: "f3453207612eac8c9fc9e6c335e6818580d1ad203675e066725414b381d2684a"
        ),
        .binaryTarget(
            name: "IronSourceAdQualitySPM",
            url: "https://github.com/ironsource-mobile/iOS-adqualitysdk/releases/download/9.0.2/IronSourceAdQualitySDK-ios-v9.0.2.zip",
            checksum: "f8f2648e1e029ec2607710dc80006f7deaf5fa287f9e3139adbe619cde9bba30"
        ),
        .binaryTarget(
            name: "CASMediationIronSource",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationIronSource-9.0.0.0.zip",
            checksum: "bc4c7fe4cb5ddb2980d26940cb247b6d210bde6c23c2aac784cfbe146da795a3"
        ),
        
        .binaryTarget(
            name: "UnityAdsSPM",
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.16.3/UnityAds.zip",
            checksum: "d1f5a008e85ac068d15c176845378ff4d98f4b719e27c3935d3a39ba428b3843"
        ),
        .binaryTarget(
            name: "CASMediationUnityAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationUnityAds-4.16.3.0.zip",
            checksum: "61b0e94c8c54f0e893f77f034b2c0cf12a4b8db93e175dcb9247f26c2609d47a"
        ),
        
        .binaryTarget(
            name: "HyprMXSPM",
            url: "https://s3.amazonaws.com/cocoapods-files/HyprMX/6.4.4/HyprMX_iOS_v6-4-4.zip",
            checksum: "9faea82aea9635683f785d211f0761198f5b7c3c514a56651fdab80c07fdc59d"
        ),
        .binaryTarget(
            name: "CASMediationHyprMX",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationHyprMX-6.4.4.0.zip",
            checksum: "fd6f555b83059e696c233f1077c2562c4b511f1189d3e4d7ab51687ec22c6d94"
        ),
        
        .binaryTarget(
            name: "KidozSPM",
            url: "https://github.com/Kidoz-SDK/kidoz-ios-frameworks/raw/main/KidozSDK/10.1.0/KidozSDK-10.1.0.zip",
            checksum: "d2adb1d556df2ed6b1718a827d20d6752bc44d71fd1afdde69f7a689da19999c"
        ),
        .binaryTarget(
            name: "CASMediationKidoz",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationKidoz-10.1.0.0.zip",
            checksum: "d16f3e7b821e7a67af1d250cb279fdc514687ed43496447054edfea4b35d8fac"
        ),

        .binaryTarget(
            name: "PradoSPM",
            url: "https://github.com/Prado-SDK/prado-ios-frameworks/raw/main/PradoSDK/10.1.0/PradoSDK-10.1.0.zip",
            checksum: "13d0cefef65c66867c2f5f316eb7e94032c3870d7d99e16160d02f613e4b34ec"
        ),
        .binaryTarget(
            name: "CASMediationPrado",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationPrado-10.1.0.0.zip",
            checksum: "10e4b578ad500d75ce8833093f2d3f33f016f7076a28ad8be9b0e9ea60b16f88"
        ),
        
        .binaryTarget(
            name: "CASMediationAppLovin",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationAppLovin-13.5.0.0.zip",
            checksum: "4efb67401cef67b1adf1010f01e65bb97ddda84a75f4e0d7ee20c28417362318"
        ),
        .binaryTarget(
            name: "CASMediationGoogleAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationGoogleAds-12.12.0.0.zip",
            checksum: "f432efed1775d34f9bb07a4da53cddfc05607d0678cf57db90decd92c40b76b1"
        ),
        .binaryTarget(
            name: "CASMediationLiftoffMonetize",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationLiftoffMonetize-7.6.1.0.zip",
            checksum: "65aff944bb8ed3eb86dae17ea52df938151203aa8586968c17c0f01f33cda080"
        ),
        
        .binaryTarget(
            name: "CASMediationStartIO",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.0-rc1/CASMediationStartIO-4.11.0.0.zip",
            checksum: "e1dd3236327493564e22c68b50662b6860e73fe0c7915f414dc1dc398ded18eb"
        ),
        .binaryTarget(
            name: "CASMediationMintegral",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.3.0/CASMediationMintegral-7.7.9.0.zip",
            checksum: "ba5b699572ba19858be80531cd893ae1f488df2c5d3c3cc7f894f49c4cdfadc5"
        ),
        .binaryTarget(
            name: "DTExchangeSPM",
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.4.1.zip",
            checksum: "9b1739895a39f83bfaf1ccae92cb37a036a1d0acedd4399556b082bc89cb4d31"
        ),
        .binaryTarget(
            name: "CASMediationDTExchange",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationDTExchange-8.4.1.0.zip",
            checksum: "9717ebe73815d6b1f8850dd775f06792adfec6eced322510dc23c0301495d5c3"
        ),
        .binaryTarget(
            name: "CASMediationExchange",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.3.0/CASMediationExchange-4.3.0.0.zip",
            checksum: "65035f70cc2210595a3577aed1fccea22c5ba7810925f99408ed19269c433e69"
        ),
        .binaryTarget(
            name: "CASMediationCrossPromo",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationCrossPromo-4.1.0.0.zip",
            checksum: "ddd50c5be23d1da33b1ac7799d3e12d08635687425055e07bb9a2a387b8a32e0"
        ),
        .binaryTarget(
            name: "InMobiSPM",
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-10.8.8.zip",
            checksum: "638166a04eb3940b2caa968fc4f5cbbc42336416db430cab45db95070d78817b"
        ),
        .binaryTarget(
            name: "CASMediationInMobi",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationInMobi-10.8.8.0.zip",
            checksum: "f815adb18daf624862d3a0a55428084bc65503cb0366e996aaa3621d6814dd38"
        ),
        
        .binaryTarget(
            name: "YangoAdsSPM",
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.16.2/YandexMobileAds.zip",
            checksum: "8459e28ed7d32f32050b18676d8ab11765dd769a0e184511f54a8f2ef017f0e1"
        ),
        .binaryTarget(
            name: "CASMediationYangoAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationYangoAds-7.16.2.0.zip",
            checksum: "b7f39778e1971368100c8d999b42fab364712b9f9ff45d8c6eee9a1c426d04b9"
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
            url: "https://developers.facebook.com/resources/FBAudienceNetwork-6.20.1.zip",
            checksum: "7e6560c585a8f224643500e89e053b909793a266ec483384d4c98215f0e870e4"
        ),
        .binaryTarget(
            name: "CASMediationAudienceNetwork",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationAudienceNetwork-6.20.1.1.zip",
            checksum: "504e5b71f627b9b3d05b396a6f17aaeef649f175acb993095f14228245e3f2ab"
        ),

        .binaryTarget(
            name: "CASMediationPangle",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationPangle-7.7.0.6.0.zip",
            checksum: "88df6cacdc66352598e008ba30428d0381bd4f4b7cd9fa7b1e8bfe4e94816094"
        )
    ]
)
