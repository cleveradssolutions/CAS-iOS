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
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "12.6.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.5.1"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "7.7.8"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.3.0"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", exact: "4.6.1"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.10.0"..<"6.0.0"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.10.5"),
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
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationAppLovinTarget")
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
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationAppLovinTarget")
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
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationAppLovinTarget")
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
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationAppLovinTarget")
            ],
            path: "Adapters/YsoNetwork"
        ),
                        
        .binaryTarget(
            name: "CleverAdsSolutions",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CleverAdsSolutions-4.1.0.zip",
            checksum: "26a2d904a6cfecd3eb21a96a5e95602bbbda85d836034adb84d2f89efbaba315"
        ),
                
        .binaryTarget(
            name: "IronSourceSPM",
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/8.9.1/IronSource8.9.1.zip",
            checksum: "7ce31a68b35e112b22f88a7741c5b7b5da3a7d9f5e4e4e8a03850a5fe2572bbe"
        ),
        .binaryTarget(
            name: "CASMediationIronSource",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationIronSource-8.9.1.0.zip",
            checksum: "26ba257143e9f226a62f908b1d4a97b56848554fdf4f77e044c4d521d1ed9840"
        ),
        
        .binaryTarget(
            name: "UnityAdsSPM",
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.15.0/UnityAds.zip",
            checksum: "5c110ceb0ed9ac91d45a727d4feac7a79d0762428bce62bdc3ebedbacbf2d3d7"
        ),
        .binaryTarget(
            name: "CASMediationUnityAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationUnityAds-4.15.0.0.zip",
            checksum: "103f7fa45c3dbcc1abbcfaed243efef4b0cf8cc379b9fe0a610aecf28f53c1cc"
        ),
        
        .binaryTarget(
            name: "HyprMXSPM",
            url: "https://s3.amazonaws.com/cocoapods-files/HyprMX/6.4.2/HyprMX_iOS_v6-4-2.zip",
            checksum: "a6e22accd79ddedb82c497f7d0c0c331a40d8d8b52daf9468dd95a434e9c56c1"
        ),
        .binaryTarget(
            name: "CASMediationHyprMX",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationHyprMX-6.4.2.1.zip",
            checksum: "7326866f789961a107168195dbf0e0d8fb490d766c9558b229b711667da42534"
        ),
        
        .binaryTarget(
            name: "KidozSPM",
            url: "https://github.com/Kidoz-SDK/kidoz-ios-frameworks/raw/main/KidozSDK/10.0.2/KidozSDK-10.0.2.zip",
            checksum: "196bd374aa8f700f145ade387db7732cb1f2d77f12fefa1ce28c58374c988b8f"
        ),
        .binaryTarget(
            name: "CASMediationKidoz",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationKidoz-10.0.2.0.zip",
            checksum: "92ca516f8347541059be9e18136f023a845ba847efba4e1662b9907e15ec015c"
        ),

        .binaryTarget(
            name: "PradoSPM",
            url: "https://github.com/Prado-SDK/prado-ios-frameworks/raw/main/PradoSDK/10.0.2/PradoSDK-10.0.2.zip",
            checksum: "ad1bdc0cdab5601c58772ed961b53879c0dd7c83e70b3d0666874bca1636749c"
        ),
        .binaryTarget(
            name: "CASMediationPrado",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationPrado-10.0.2.0.zip",
            checksum: "9fe23f958807454958e0068b83e8a863fc5806cd624cf7bd5fb0b04429d86877"
        ),
        
        .binaryTarget(
            name: "CASMediationAppLovin",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationAppLovin-13.3.0.0.zip",
            checksum: "d2c92ecd33c17497b6eb64ee4d734c2b2481f48a1ce6a2bc7a5818f01465bff9"
        ),
        .binaryTarget(
            name: "CASMediationGoogleAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationGoogleAds-12.6.0.0.zip",
            checksum: "98e34a6c64f81cb2dd52321742268ae9d8574e3860d7cc20de57601f32e1a9a8"
        ),
        .binaryTarget(
            name: "CASMediationLiftoffMonetize",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationLiftoffMonetize-7.5.1.0.zip",
            checksum: "07ce57f97a5162e237ed5d4f6c2b8c37a7464988eb44ffcd5c740729b301b084"
        ),
        
        .binaryTarget(
            name: "CASMediationStartIO",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationStartIO-4.10.5.1.zip",
            checksum: "ef4782d5bc96d77704c26ac0cadbc5c4571fe8c185993baab006088e9f9b6f56"
        ),
        .binaryTarget(
            name: "CASMediationMintegral",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationMintegral-7.7.8.0.zip",
            checksum: "773ec9d2029ab02a207092dade5bc9a05521fdffc7fde502fe6995576cb0879c"
        ),
        .binaryTarget(
            name: "DTExchangeSPM",
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.3.7.zip",
            checksum: "bbf3ec0949f89c5b4a7922c4584417293bf56e8489725118a757d3e5dea0fe8a"
        ),
        .binaryTarget(
            name: "CASMediationDTExchange",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationDTExchange-8.3.7.0.zip",
            checksum: "100f1bff33d32c951a3a72f1a29b90979035110522d0b5261b5341329c818661"
        ),
        .binaryTarget(
            name: "CASMediationExchange",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationExchange-4.1.0.0.zip",
            checksum: "76866156aa0c819cb9360e64b2609374434ae64f4757b67338789d01eeb6ac82"
        ),
        .binaryTarget(
            name: "CASMediationCrossPromo",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationCrossPromo-4.1.0.0.zip",
            checksum: "5a593513d3b0897ff8f919ca60f9e960c673f93b8eb64819b8ab824cfc9db66f"
        ),
        .binaryTarget(
            name: "InMobiSPM",
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-10.8.3.zip",
            checksum: "faeeb442837927a744951511db9f5a554032e47a12a235fd8368c84496db6cf6"
        ),
        .binaryTarget(
            name: "CASMediationInMobi",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationInMobi-10.8.3.0.zip",
            checksum: "f92350f932b7b955aa23b643093afbeb3677ab88fa60ac909ad46fd456e03b9b"
        ),
        
        .binaryTarget(
            name: "YandexAdsSPM",
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.13.0/YandexMobileAds.zip",
            checksum: "313c0f94d7b639b62e7aff0f93b7ed76d5d409d1219b7834739934470920c3b4"
        ),
        .binaryTarget(
            name: "CASMediationYandexAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationYandexAds-7.13.0.0.zip",
            checksum: "948a6aed091583764081184592a1d1fbc7c95d27a863631676acfabda31f2b77"
        ),

        .binaryTarget(
            name: "YsoNetworkSPM",
            url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk/get/794e6daf0ed2dc2f237714f4e86d24de7a888a63.zip",
            checksum: "237087e30b6382f0ff11b53b2c892f213d0fb34e6bf5aec3810316a3728dc978"
        ),
        .binaryTarget(
            name: "CASMediationYsoNetwork",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationYsoNetwork-1.1.31.1.zip",
            checksum: "d3fcd136f0434b87c3136611e347c11df26f4e9e0eea711105d334d7b6e6a9d0"
        ),

        .binaryTarget(
            name: "AudienceNetworkSPM",
            url: "https://developers.facebook.com/resources/FBAudienceNetwork-6.17.1.zip",
            checksum: "1e8f840a946a4692950e00e4da7eaea2cfaecee9fd7ae168624e15fc7e02fe43"
        ),
        .binaryTarget(
            name: "CASMediationAudienceNetwork",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.1/CASMediationAudienceNetwork-6.17.1.1.zip",
            checksum: "3f1024c2fff1eafce9cf007425dc1539adb575a34248e181f2e5eb667b33a750"
        )
    ]
)
