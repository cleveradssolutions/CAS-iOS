// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Integration of some SDKs (e.g. IronSource, UnityAds, HyprMX, Kidoz, DTExchange, InMobi, YandexAds, YsoNetwork)
// is not done through ready-made SPM packages, but using .zip archives from official sources.
// Below are the links to the sources used to configure binaryTarget:
//
// - IronSource:
//   Taken from the official GitHub repository:
//   https://github.com/ironsource-mobile/iOS-sdk/tree/master/8.8.0
//   Archive: IronSource8.8.0.zip
//
// - UnityAds:
//   Taken from official GitHub Releases:
//   https://github.com/Unity-Technologies/unity-ads-ios/releases/tag/4.14.2
//   Archive: UnityAds.zip
//
// - HyprMX:
//   Available from official site:
//   https://www.hyprmx.com
//   Archive: HyprMX.zip
//
// - Kidoz:
//   Available from official site:
//   https://www.kidoz.net
//   Archive: KidozSDK.zip
//
// - DTExchange (Digital Turbine):
//   Available from official site:
//   https://www.digitalturbine.com
//   Archive: DTExchangeSDK.zip
//
// - InMobi:
//   Available from official site:
//   https://www.inmobi.com/sdk
//   Archive: InMobiSDK.zip
//
// - Yandex Ads:
//   Available from official GitHub repo (releases section):
//   https://github.com/yandexmobile/yandex-ads-sdk-ios/releases
//   Archive: YandexMobileAds.zip
//
// - YsoNetwork:
//   SDK distributed privately (contact required): https://www.ysonetwork.com
//   Archive: YsoNetworkSDK.zip
//
// These archives were downloaded manually and added to the project using `binaryTarget`
// as allowed by Swift Package Manager.


let package = Package(
    name: "CleverAdsSolutions",
    
    platforms: [.iOS(.v13)],
    
    products: [
        .library(
            name: "CleverAdsSolutionsSPM",
            targets: ["CASBaseResources"]
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
            name: "CASMediationAppLovin",
            targets: ["CASMediationAppLovinTarget"]
        ),
        .library(
            name: "CASMediationGoogleAds",
            targets: ["CASMediationGoogleAdsTarget"]
        ),
        .library(
            name: "CASMediationVungle",
            targets: ["CASMediationVungleTarget"]
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
            name: "CASMediationExchange",
            targets: ["CASMediationExchangeTarget"]
        ),
        .library(
            name: "CASMediationCrossPromo",
            targets: ["CASPromoResources"]
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
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "12.3.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.4.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "7.7.7"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.2.0"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", exact: "4.6.1"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", "5.10.0"..<"6.0.0"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.10.5"),
    ],
    
    targets: [
    
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
            path: "SPMSources/CASMediationIronSourceTarget"
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
                .target(name: "CASBaseResources")
            ],
            path: "SPMSources/CASMediationUnityAdsTarget"
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
            ],
            path: "SPMSources/CASMediationHyprMXTarget"
        ),
        .target(
            name: "KidozSPMTarget",
            dependencies: [
                .target(name: "KidozSPM")
            ],
            path: "SPMSources/KidozSPMTarget"
        ),
        .target(
            name: "CASMediationKidozTarget",
            dependencies: [
                .target(name: "CASMediationKidoz"),
                .target(name: "KidozSPMTarget"),
                .target(name: "CASBaseResources"),
            ],
            path: "SPMSources/CASMediationKidozTarget"
        ),
        
        .target(
            name: "CASMediationAppLovinTarget",
            dependencies: [
                .target(name: "CASMediationAppLovin"),
                .target(name: "CASBaseResources"),
                .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package")
            ],
            path: "SPMSources/CASMediationAppLovinTarget"
        ),
        .target(
            name: "CASMediationGoogleAdsTarget",
            dependencies: [
                .target(name: "CASMediationGoogleAds"),
                .target(name: "CASBaseResources"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "SPMSources/CASMediationGoogleAdsTarget"
        ),
        .target(
            name: "CASMediationVungleTarget",
            dependencies: [
                .target(name: "CASMediationVungle"),
                .target(name: "CASBaseResources"),
                .product(name: "VungleAdsSDK", package: "VungleAdsSDK-SwiftPackageManager")
            ],
            path: "SPMSources/CASMediationVungleTarget"
        ),
        
        .target(
            name: "CASMediationStartIOTarget",
            dependencies: [
                .target(name: "CASMediationStartIO"),
                .target(name: "CASBaseResources"),
                .product(name: "StartApp", package: "StartAppSDK-SwiftPackage")
            ],
            path: "SPMSources/CASMediationStartIOTarget"
        ),
        .target(
            name: "CASMediationMintegralTarget",
            dependencies: [
                .target(name: "CASMediationMintegral"),
                .target(name: "CASBaseResources"),
                .product(name: "MintegralAdSDK", package: "MintegralAdSDK-Swift-Package")
            ],
            path: "SPMSources/CASMediationMintegralTarget"
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
                .target(name: "CASBaseResources")
            ],
            path: "SPMSources/CASMediationDTExchangeTarget"
        ),
    
        .target(
            name: "CASMediationExchangeTarget",
            dependencies: [
                .target(name: "CASMediationExchange"),
                .target(name: "CASBaseResources")
            ],
            path: "SPMSources/CASMediationExchangeTarget",
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
            path: "SPMSources/CASMediationInMobiTarget"
        ),
        
        .target(
            name: "CASBaseResources",
            dependencies: [
                .target(name: "CleverAdsSolutionsSPM"),
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
            path: "SPMSources/CASMediationYsoNetworkTarget"
        ),
                        
        .target(
            name: "CASMediationYandexAdsTarget",
            dependencies: [
                .target(name: "YandexAdsSPMTarget"),
                .target(name: "CASMediationYandexAds"),
                .target(name: "CASBaseResources")
            ],
            path: "SPMSources/CASMediationYandexAdsTarget"
        ),
                        
        .binaryTarget(
            name: "CleverAdsSolutionsSPM",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CleverAdsSolutions-4.0.2.1.zip",
            checksum: "1b8dd73cda9d35b04b411847d969f5c3b6d45561978f2dd0964655d52dc9e7dc"
        ),
                
        .binaryTarget(
            name: "IronSourceSPM",
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/8.8.0/IronSource8.8.0.zip",
            checksum: "e278dded76ed9cb23bc0b51ffce134dd5dc75572e84deeeeae053f07fe77d806"
        ),
        .binaryTarget(
            name: "CASMediationIronSource",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationIronSource-8.8.0.0.zip",
            checksum: "e2d7d59ad24441b2ebe870a97eccea6497336637adc68ec17e785d829bcbe62a"
        ),
        
        .binaryTarget(
            name: "UnityAdsSPM",
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.14.2/UnityAds.zip",
            checksum: "4e695f438393edd8c7fb8af3f14dcdfa21ce5c52259c7d37696129db7000493f"
        ),
        .binaryTarget(
            name: "CASMediationUnityAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationUnityAds-4.14.2.0.zip",
            checksum: "65dc10aafd25fee41ac7160cffec648ab5a7f9e89aeaa73b00b3961fe10c188a"
        ),
        
        .binaryTarget(
            name: "HyprMXSPM",
            url: "https://s3.amazonaws.com/cocoapods-files/HyprMX/6.4.2/HyprMX_iOS_v6-4-2.zip",
            checksum: "a6e22accd79ddedb82c497f7d0c0c331a40d8d8b52daf9468dd95a434e9c56c1"
        ),
        .binaryTarget(
            name: "CASMediationHyprMX",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationHyprMX-6.4.2.0.zip",
            checksum: "0d6d83a302d7d77e73d16d5418106477f36c67911001cfda5d32d54f7f53fb2b"
        ),
        
        .binaryTarget(
            name: "KidozSPM",
            url: "https://github.com/Kidoz-SDK/kidoz-ios-frameworks/raw/refs/heads/main/KidozSDK/9.2.0/KidozSDK-9.2.0.zip",
            checksum: "498a360a7af9dedcdf6501425b7e1decafcbd843596bc434ebe06af07bfe067a"
        ),
        .binaryTarget(
            name: "CASMediationKidoz",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationKidoz-9.2.0.0.zip",
            checksum: "da69d436d5016d9acc8337ce8c6634879a375505733f0d7469e3b08d2f717289"
        ),
        
        .binaryTarget(
            name: "CASMediationAppLovin",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationAppLovin-13.2.0.0.zip",
            checksum: "28f5451630c120eaf6e2d10d87924b17f9317dcd20f0a858102570f904c83414"
        ),
        .binaryTarget(
            name: "CASMediationGoogleAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationGoogleAds-12.3.0.0.zip",
            checksum: "e8bee8ef3294f6eb691efa74ff0c2e8911dd00ea18d65c928967f1dac89a4073"
        ),
        .binaryTarget(
            name: "CASMediationVungle",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationLiftoffMonetize-7.5.0.0.zip",
            checksum: "9d73620b7f37a5e4aba51feb5366fdaa0713c3178f6e3f43740cdd7f53734f02"
        ),
        
        .binaryTarget(
            name: "CASMediationStartIO",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationStartIO-4.10.5.0.zip",
            checksum: "65b8b61967b31f911c0378f9dde1a9950380ada2e744016499ede8810fd519b5"
        ),
        .binaryTarget(
            name: "CASMediationMintegral",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationMintegral-7.7.7.0.zip",
            checksum: "f77a5b71727563cdfb2f58c061b9b272840e128cfc376c93aabc4cd6b206fa40"
        ),
        .binaryTarget(
            name: "DTExchangeSPM",
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.3.7.zip",
            checksum: "bbf3ec0949f89c5b4a7922c4584417293bf56e8489725118a757d3e5dea0fe8a"
        ),
        .binaryTarget(
            name: "CASMediationDTExchange",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationDTExchange-8.3.6.0.zip",
            checksum: "ac2d3cb1ffbefef6078441260cf216ad7d2b8d4af959a0abd2bb7fc369c083f0"
        ),
        .binaryTarget(
            name: "CASMediationExchange",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationExchange-4.0.2.0.zip",
            checksum: "b8870a26bc4e6884872039c3d4e1b8258a2739330078c8d28c1806c3293a3e1a"
        ),
        .binaryTarget(
            name: "CASMediationCrossPromo",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationCrossPromo-4.0.2.0.zip",
            checksum: "a35bf1503a571a67bcb70d093a923535b29c3afedf7de605540ead09b6164913"
        ),
        .binaryTarget(
            name: "InMobiSPM",
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-10.8.2.zip",
            checksum: "49de08f1913ca9a9193cf84964ccad1475e7dc5fd00dc4a9e050219e80d48b6b"
        ),
        .binaryTarget(
            name: "CASMediationInMobi",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationInMobi-10.8.2.0.zip",
            checksum: "36e64115da94fd479160743a65c6470b1c41fec03e1874b95df2f637bae3304e"
        ),
        
        .binaryTarget(
            name: "YandexAdsSPM",
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.12.1/YandexMobileAds.zip",
            checksum: "bcfabdfab8713f87280988f63ce7c3d6659e9b77bc1ce3666f5c18eeaef758a7"
        ),
        .binaryTarget(
            name: "CASMediationYandexAds",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationYandexAds-7.12.1.0.zip",
            checksum: "b45e29db5dac0970697bffd3f51e54ac01dea1c4ce9e24843525d6a500063c04"
        ),
        .binaryTarget(
            name: "YsoNetworkSPM",
            url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk/get/794e6daf0ed2dc2f237714f4e86d24de7a888a63.zip",
            checksum: "237087e30b6382f0ff11b53b2c892f213d0fb34e6bf5aec3810316a3728dc978"
        ),
        .binaryTarget(
            name: "CASMediationYsoNetwork",
            url: "https://github.com/cleveradssolutions/cas-ios-spm/releases/download/v1.0.0/CASMediationYsoNetwork-1.1.31.0.zip",
            checksum: "719b5a6f93ba1a54880fcb63288b1f460b09e64752eda7c4f40e1219bfd2793a"
        )
    ]
)
