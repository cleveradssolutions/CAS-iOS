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
// - DTExchange: https://github.com/CocoaPods/Specs/tree/master/Specs/1/7/3/Fyber_Marketplace_SDK/
// - InMobi: https://github.com/CocoaPods/Specs/tree/master/Specs/7/8/1/InMobiSDK/
// - YsoNetwork: https://github.com/CocoaPods/Specs/tree/master/Specs/8/a/a/YsoNetworkSDK/
// - YangoAds: https://github.com/yandexmobile/yandex-ads-sdk-ios/blob/master/Package.swift
//
// Not supported CAS Adapters:
// - Chartboost: https://github.com/CocoaPods/Specs/tree/master/Specs/5/3/e/ChartboostSDK/
// - BigoAds: https://github.com/CocoaPods/Specs/tree/master/Specs/a/5/5/BigoADS/
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
        ),
        .library(
            name: "CASMediationMaticoo",
            targets: ["CASMediationMaticooTarget"]
        ),
        .library(
            name: "CASMediationPubMatic",
            targets: ["CASMediationPubMaticTarget"]
        )
    ],
    
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "12.14.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.6.3"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "8.0.4"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.5.1"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "7.6.0-release.6"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", .upToNextMinor(from: "5.2.1")),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.11.0"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "5.14.0")),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package", exact: "4.10.0"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package", exact: "10.1.3"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package", exact: "10.1.3"),
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
            name: "CASMediationHyprMXTarget",
            dependencies: [
                .target(name: "HyprMXSPM"),
                .target(name: "CASMediationHyprMX"),
                .target(name: "CASBaseResources")
            ],
            path: "Adapters/HyprMX"
        ),
        .target(
            name: "CASMediationKidozTarget",
            dependencies: [
                .target(name: "CASMediationKidoz"),
                .target(name: "CASBaseResources"),
                .product(name: "KidozSDK", package: "kidoz-sdk-swift-package"),
            ],
            path: "Adapters/Kidoz",
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),

        .target(
            name: "CASMediationPradoTarget",
            dependencies: [
                .target(name: "CASMediationPrado"),
                .target(name: "CASBaseResources"),
                .product(name: "PradoSDK", package: "kidoz-sdk-swift-package"),
            ],
            path: "Adapters/Prado",
            linkerSettings: [
                .linkedLibrary("c++")
            ]
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
            name: "CASMediationDTExchangeTarget",
            dependencies: [
                .target(name: "DTExchangeSPM"),
                .target(name: "CASMediationDTExchange"),
                .target(name: "CASBaseResources"),
                .target(name: "CASMediationIronSourceTarget")
            ],
            path: "Adapters/DTExchange"
        ),
        
        .target(
            name: "CASMediationInMobiTarget",
            dependencies: [
                .target(name: "InMobiSPM"),
                .target(name: "CASMediationInMobi"),
                .target(name: "CASBaseResources")                
            ],
            path: "Adapters/InMobi",
            linkerSettings: [
                .linkedLibrary("sqlite3.0"),
                .linkedFramework("WebKit")
            ]
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
            name: "CASMediationYsoNetworkTarget",
            dependencies: [
                .target(name: "YsoNetworkSPM"),
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
        
        .target(
            name: "CASMediationMaticooTarget",
            dependencies: [
                .target(name: "MaticooSPM"),
                .target(name: "CASMediationMaticoo"),
                .target(name: "CASBaseResources")
            ],
            path: "Adapters/Maticoo"
        ),

        .target(
            name: "CASMediationPubMaticTarget",
            dependencies: [
                .target(name: "CASMediationPubMatic"),
                .target(name: "CASMediationAppLovinTarget"),
                .product(name: "OpenWrapSDK", package: "OpenWrapSDK-Swift-Package")
            ],
            path: "Adapters/PubMatic"
        ),
                        
        .binaryTarget(
            name: "CleverAdsSolutions",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.4/CleverAdsSolutions-4.5.4.zip",
            checksum: "0a1af5ddf3f1e214e83bfa2e83fc1d663124e7f2b78ece38da095fd4b8617669"
        ),
                
        .binaryTarget(
            name: "IronSourceSPM",
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/9.2.0/IronSource9.2.0.zip",
            checksum: "d61a524cb6e304dea88509765a2fe01e0353b9cac935f39c6e6535971667d9d7"
        ),
        .binaryTarget(
            name: "IronSourceAdQualitySPM",
            url: "https://github.com/ironsource-mobile/iOS-adqualitysdk/releases/download/9.1.1/IronSourceAdQualitySDK-ios-v9.1.1.zip",
            checksum: "a0ec4c791feee794d09a759d0e2ffb8b7da3f847ac7a083f4ce30667510a0815"
        ),
        .binaryTarget(
            name: "CASMediationIronSource",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationIronSource-9.2.0.0.zip",
            checksum: "1d324b73220510eaedf592779bb93b51eab4c6bd5b97a351bbadd769a7063c46"
        ),
        
        .binaryTarget(
            name: "UnityAdsSPM",
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.16.5/UnityAds.zip",
            checksum: "40b2dceb61335093548cf86fee2658391509c7d8c16fea5335813b76dbfb3089"
        ),
        .binaryTarget(
            name: "CASMediationUnityAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationUnityAds-4.16.5.0.zip",
            checksum: "7db77e119d8b130d54afbc895b908f16d1335e42b1155ba680bac8e3fdd97331"
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
            name: "CASMediationKidoz",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationKidoz-10.1.3.0.zip",
            checksum: "44692659f6006d2a3e46f24220673bdf9a1bbb68511861fe85b7a1d629de1393"
        ),

        .binaryTarget(
            name: "CASMediationPrado",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationPrado-10.1.3.0.zip",
            checksum: "4e80d7d8a26a31643a039e5ee0509841e9fe3c46f2b0d0fd6f950ff9f5ff4e3c"
        ),
        
        .binaryTarget(
            name: "CASMediationAppLovin",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.0/CASMediationAppLovin-13.5.1.0.zip",
            checksum: "b9af87012732307962ca8f09a8964e05e6e6482333200b49c4c3bcbe415caa6a"
        ),
        .binaryTarget(
            name: "CASMediationGoogleAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.0/CASMediationGoogleAds-12.14.0.0.zip",
            checksum: "01dca391cc3949dd1bd414c942b7096fe2b205a0cf2bd0431c59c64857b6d138"
        ),
        .binaryTarget(
            name: "CASMediationLiftoffMonetize",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationLiftoffMonetize-7.6.3.0.zip",
            checksum: "f969e45ed781cbc9acc67e8ba1e4e7c82a45db55135f8b1d5f185641e8c926c5"
        ),
        
        .binaryTarget(
            name: "CASMediationStartIO",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.0-rc1/CASMediationStartIO-4.11.0.0.zip",
            checksum: "e1dd3236327493564e22c68b50662b6860e73fe0c7915f414dc1dc398ded18eb"
        ),
        .binaryTarget(
            name: "CASMediationMintegral",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationMintegral-8.0.4.0.zip",
            checksum: "7da848d5cafb8c9530fa37b28fe4ea159ee301bb751ea818ce864629d69f47a1"
        ),
        .binaryTarget(
            name: "DTExchangeSPM",
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.4.2.zip",
            checksum: "c3b2a3c3855a01e994102d5dcfbe1f0bb2896f4589970b02f293af5febeb69f2"
        ),
        .binaryTarget(
            name: "CASMediationDTExchange",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationDTExchange-8.4.2.1.zip",
            checksum: "1ed5c572eaac90bb522a6cc80b5bd2dd1f7767165d094fe67d0eb9c608379bcc"
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
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-11.1.0.zip",
            checksum: "94ee97c3fc99e0111db5dd89cc872ab52a88c52b2af96fa6cd246021a114a4ef"
        ),
        .binaryTarget(
            name: "CASMediationInMobi",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.0/CASMediationInMobi-11.1.0.0.zip",
            checksum: "86089051668146739b8ba3e8079afca08e82491f83cb463d76c673c166e98848"
        ),
        
        .binaryTarget(
            name: "YangoAdsSPM",
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.18.1/YandexMobileAds.zip",
            checksum: "a5f84d1091b18a20911efa1fef5a8b808c340659d1eeee3f96c1e04bde8c68b7"
        ),
        .binaryTarget(
            name: "CASMediationYangoAds",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationYangoAds-7.18.1.0.zip",
            checksum: "703f8f346ae87f1f1e5059dca5cd650853964a0cbfc77817daf6121d7a03c086"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.4/CASMediationPangle-7.8.0.7.0.zip",
            checksum: "475a2b395135a2adaed3c98df12ce2a38def4d6d28f281fed8f2c0b23c82c3ef"
        ),
        
        .binaryTarget(
            name: "MaticooSPM",
            url: "https://github.com/cloudadrd/zMaticooPodSpec/archive/refs/tags/1.5.4.5.zip",
            checksum: "4f7000845797150931c7428affd298f835d9a38f12d13735601fd6ddd5c93c20"
        ),
        .binaryTarget(
            name: "CASMediationMaticoo",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationMaticoo-1.5.4.5.zip",
            checksum: "01c1765c2218b609789baf7eaff7648046a7cefba07bb50556d6fb44f11a1be2"
        ),

        .binaryTarget(
            name: "CASMediationPubMatic",
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.2/CASMediationPubMatic-4.10.0.0.zip",
            checksum: "01a8dcde7f0537c91ea7bab3c9d05c1bde6ae4028f4fa4cea041655d0faef08e"
        )
    ]
)
