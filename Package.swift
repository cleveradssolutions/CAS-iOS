// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Some ad frameworks, such as IronSource and UnityAds, do not provide official support for
// Swift Package Manager (SPM).
// Instead, we define custom Package.swift configurations using the official .zip archives
// provided for CocoaPods integration.
// Below are the CocoaPods links used to configure the binaryTargets.

let baseTarget = "CASBaseResources"
let baseBinary = "CASBase"

enum CAS: String, CaseIterable {
    case Exchange
    case CrossPromo

    /// https://github.com/CocoaPods/Specs/blob/master/Specs/7/7/b/IronSourceSDK/9.3.0.0/IronSourceSDK.podspec.json
    case IronSource

    /// https://github.com/CocoaPods/Specs/blob/master/Specs/2/e/8/UnityAds/4.16.6/UnityAds.podspec.json
    case UnityAds

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/6/7/d/HyprMX/
    case HyprMX

    /// https://github.com/Kidoz-SDK/kidoz-sdk-swift-package
    case Kidoz

    /// https://github.com/Prado-SDK/prado-sdk-swift-package
    case Prado

    /// https://github.com/AppLovin/AppLovin-MAX-Swift-Package
    case AppLovin

    /// https://github.com/googleads/swift-package-manager-google-mobile-ads
    case GoogleAds

    /// https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager
    case LiftoffMonetize

    /// https://github.com/CocoaPods/Specs/blob/master/Specs/2/1/5/FBAudienceNetwork/
    case AudienceNetwork

    /// https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage
    case StartIO

    /// https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package
    case Mintegral

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/1/7/3/Fyber_Marketplace_SDK/
    case DTExchange

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/7/8/1/InMobiSDK/
    case InMobi

    /// https://github.com/yandexmobile/yandex-ads-sdk-ios/blob/master/Package.swift
    /// https://github.com/divkit/divkit-ios-facade
    /// https://github.com/appmetrica/appmetrica-sdk-ios
    case YangoAds

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/8/a/a/YsoNetworkSDK/
    case YsoNetwork

    /// https://github.com/bytedance/AdsGlobalPackage
    /// https://github.com/bytedance/Bytedance-UnionAD/blob/master/Ads-Global/Ads-Global.podspec
    case Pangle

    /// https://github.com/cloudadrd/zMaticooPodSpec/blob/main/zMaticoo.podspec
    case Maticoo

    /// https://github.com/PubMatic/OpenWrapSDK-Swift-Package
    case PubMatic

    /// https://github.com/Ogury/ogury-sdk-spm
    case Ogury
    /// https://github.com/CocoaPods/Specs/blob/master/Specs/5/3/e/ChartboostSDK/9.11.0/ChartboostSDK.podspec.json
    case Chartboost

    /// https://github.com/vervegroup/hybid-ios-spm-sdk
    case Verve

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/a/5/5/Bigo/
    case Bigo

    /// Not supported:  Many separate frameworks
    //case Smaato

    /// Not supported: Has no compiled frameworks
    //case SuperAwesome

    /// Not supported:  Many separate frameworks
    //case Madex

    var product: Product {
        return Product.library(name: "CASMediation" + rawValue, targets: [target])
    }

    static var allProducts: [Product] {
        var products = [
            Product.library(name: "CleverAdsSolutionsSPM", targets: [baseTarget])
        ]
        allCases.forEach { products.append($0.product) }
        return products
    }

    var target: String { "CASMediation" + rawValue + "Target" }
    var binaryAdapter: String { "CASMediation" + rawValue }
    var targetSDK: String { binarySDK + "Target" }
    var binarySDK: String { rawValue + "SPM" }
    var pathAdapter: String {
        if self == CAS.Exchange {
            return "Adapters/CAS" + rawValue
        }
        return "Adapters/" + rawValue
    }
}

let package = Package(
    name: "CleverAdsSolutions",
    platforms: [.iOS(.v13)],
    products: CAS.allProducts,
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "13.3.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.7.2"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package", exact: "10.1.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "8.1.1"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.6.2"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "7.9.0-release.8"),
        .package(url: "https://github.com/divkit/divkit-ios-facade", .upToNextMinor(from: "5.2.1")),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "5.14.0")),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.13.1"),
        .package(url: "https://github.com/JunGroupProductions/HyprMX-SDK-SPM", exact: "6.4.6"),
        .package(url: "https://github.com/Ogury/ogury-sdk-spm", exact: "5.2.2"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package", exact: "10.1.5"),
        .package(url: "https://github.com/vervegroup/hybid-ios-spm-sdk", exact: "3.8.0"),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package", exact: "5.1.0"),
    ],

    targets: [
        // MARK: - CAS Base

        .target(
            name: baseTarget,
            dependencies: [
                .target(name: baseBinary)
            ],
            path: "Adapters/Base",
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
                .linkedFramework("WebKit"),
            ]
        ),
        .binaryTarget(
            name: baseBinary,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CleverAdsSolutions-4.6.6.zip",
            checksum: "d7395f7d86f90b15546ec892b1443c512c0925b774e65014df7e86464bc13a78"
        ),

        // MARK: - IronSource

        .target(
            name: CAS.IronSource.target,
            dependencies: [
                .target(name: CAS.IronSource.binarySDK),
                .target(name: "IronSourceAdQualitySPM"),
                .target(name: CAS.IronSource.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.IronSource.pathAdapter,
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
                .linkedLibrary("z"),
            ]
        ),
        .binaryTarget(
            name: CAS.IronSource.binarySDK,
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/9.4.0/IronSource9.4.0.zip",
            checksum: "6b6915e09e4738bf2badc03ba2b91a622fba4624dc2c084cd9b330c58def9133"
        ),
        .binaryTarget(
            name: "IronSourceAdQualitySPM",
            url: "https://github.com/ironsource-mobile/iOS-adqualitysdk/releases/download/9.4.0/IronSourceAdQualitySDK-ios-v9.4.0.zip",
            checksum: "7ebb23b7615c00a5d24a378e0422f62babdb5caa3b10cad6783fdac41dd4f8e7"
        ),
        .binaryTarget(
            name: CAS.IronSource.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationIronSource-9.4.0.1.zip",
            checksum: "be5dc78e41e6a4bf2f6f4601170f8dbbf444aa494d840a7a6f2656677050d1bb"
        ),

        // MARK: - UnityAds

        .target(
            name: CAS.UnityAds.target,
            dependencies: [
                .target(name: CAS.UnityAds.binarySDK),
                .target(name: CAS.UnityAds.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
            ],
            path: CAS.UnityAds.pathAdapter,
            linkerSettings: [
                .linkedFramework("AdSupport"),
                .linkedFramework("AudioToolbox"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("Foundation"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("StoreKit"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("WebKit"),
                .linkedFramework("UIKit"),
                .linkedFramework("AVFAudio"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("Network"),
            ]
        ),
        .binaryTarget(
            name: CAS.UnityAds.binarySDK,
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.17.0/UnityAds.zip",
            checksum: "8a40e6c779353e4ead87d4d635480cdae46f0b708763460dc002103e35ce8ba7"
        ),
        .binaryTarget(
            name: CAS.UnityAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationUnityAds-4.17.0.0.zip",
            checksum: "f92e112c7fca2624ce9b5fb984ff6cf88070ed3947dc6ecd93162358d9b2a2bf"
        ),

        // MARK: HyprMX

        .target(
            name: CAS.HyprMX.target,
            dependencies: [
                .target(name: CAS.HyprMX.binarySDK),
                .target(name: CAS.HyprMX.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.HyprMX.pathAdapter
        ),
        .binaryTarget(
            name: CAS.HyprMX.binarySDK,
            url: "https://s3.amazonaws.com/prd-mobile-sdk-files/HyprMX/6.4.5-rcs/HyprMX_iOS_v6_4_5-b353.zip",
            checksum: "12757ba6a0d357c2d6d4fce74ce003d9f73cc1af82443d35a094b8b26aa44bc0"
        ),
        .binaryTarget(
            name: CAS.HyprMX.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationHyprMX-6.4.6.0.zip",
            checksum: "80862c2d26f8a88c1ff93d8d05ac026300524376db75c2f882617b30db2a8d81"
        ),

        // MARK: - Kidoz

        .target(
            name: CAS.Kidoz.target,
            dependencies: [
                .target(name: CAS.Kidoz.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "KidozSDK", package: "kidoz-sdk-swift-package"),
            ],
            path: CAS.Kidoz.pathAdapter,
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
        .binaryTarget(
            name: CAS.Kidoz.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.0/CASMediationKidoz-10.1.5.0.zip",
            checksum: "43ff6a09ca8227fe92e1d76255bcec0d8904bff717b251f04eaf93590734600f"
        ),

        // MARK: - Prado

        .target(
            name: CAS.Prado.target,
            dependencies: [
                .target(name: CAS.Prado.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "PradoSDK", package: "prado-sdk-swift-package"),
            ],
            path: CAS.Prado.pathAdapter,
            linkerSettings: [
                .linkedLibrary("c++")
            ]
        ),
        .binaryTarget(
            name: CAS.Prado.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.0/CASMediationPrado-10.1.5.0.zip",
            checksum: "55e369c86c59690c4dc65169b5655443e170b321e2b1c8c7fbe33da750a9ff90"
        ),

        // MARK: AppLovin

        .target(
            name: CAS.AppLovin.target,
            dependencies: [
                .target(name: CAS.AppLovin.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "AppLovinSDK", package: "AppLovin-MAX-Swift-Package"),
            ],
            path: CAS.AppLovin.pathAdapter
        ),
        .binaryTarget(
            name: CAS.AppLovin.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationAppLovin-13.6.2.0.zip",
            checksum: "e11c85287ceec4d67b2ba5a40dddae8369f6e1c4d8825be87476517045dc82dc"
        ),

        // MARK: GoogleAds

        .target(
            name: CAS.GoogleAds.target,
            dependencies: [
                .target(name: CAS.GoogleAds.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                ),
            ],
            path: CAS.GoogleAds.pathAdapter
        ),
        .binaryTarget(
            name: CAS.GoogleAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationGoogleAds-13.3.0.0.zip",
            checksum: "520785a49155afaab48e6eb2c4687e8601fa0473cb986efd7230e3eaf7767c73"
        ),

        // MARK: LiftoffMonetize

        .target(
            name: CAS.LiftoffMonetize.target,
            dependencies: [
                .target(name: CAS.LiftoffMonetize.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "VungleAdsSDK", package: "VungleAdsSDK-SwiftPackageManager"),
            ],
            path: CAS.LiftoffMonetize.pathAdapter
        ),
        .binaryTarget(
            name: CAS.LiftoffMonetize.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.5/CASMediationLiftoffMonetize-7.7.2.0.zip",
            checksum: "c21a4310d03186081b1d9f85f6368daf79eda0b78705a8a2a3d5822b593578e2"
        ),

        // MARK: - StartIO

        .target(
            name: CAS.StartIO.target,
            dependencies: [
                .target(name: CAS.StartIO.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "StartApp", package: "StartAppSDK-SwiftPackage"),
            ],
            path: CAS.StartIO.pathAdapter
        ),
        .binaryTarget(
            name: CAS.StartIO.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationStartIO-4.13.1.0.zip",
            checksum: "dc6f02dd0b14836ddc0562db69421f4d0661c5bcd72eaf7a386fd43f9b9d43a0"
        ),

        // MARK: - Mintegral

        .target(
            name: CAS.Mintegral.target,
            dependencies: [
                .target(name: CAS.Mintegral.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "MintegralAdSDK", package: "MintegralAdSDK-Swift-Package"),
            ],
            path: CAS.Mintegral.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Mintegral.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.5/CASMediationMintegral-8.1.1.0.zip",
            checksum: "4f683e27a735a948e305813b4548b4926b392c589f0be0824b9150b89da1b906"
        ),

        // MARK: - DTExchange

        .target(
            name: CAS.DTExchange.target,
            dependencies: [
                .target(name: CAS.DTExchange.binarySDK),
                .target(name: CAS.DTExchange.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
            ],
            path: CAS.DTExchange.pathAdapter
        ),
        .binaryTarget(
            name: CAS.DTExchange.binarySDK,
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.4.6.zip",
            checksum: "4e5d0ace63d91934ccebf467bf9041fc9ade0c8401c4a4161e8e3907d4179c6f"
        ),
        .binaryTarget(
            name: CAS.DTExchange.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationDTExchange-8.4.6.0.zip",
            checksum: "d08f1a5177a2cb34ed4541fb82ceabd6c403e43d1cb04fd5f2272547b8758808"
        ),

        // MARK: - CASExchange

        .target(
            name: CAS.Exchange.target,
            dependencies: [
                .target(name: CAS.Exchange.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.Exchange.pathAdapter,
            linkerSettings: [
                .linkedFramework("SafariServices"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("CoreLocation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("QuartzCore"),
            ]
        ),
        .binaryTarget(
            name: CAS.Exchange.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationExchange-4.6.3.0.zip",
            checksum: "4460805507d5e5c200c8f87476ade6fc11b48df52c30457a81c45091fbb6d931"
        ),

        // MARK: - CrossPromo

        .target(
            name: CAS.CrossPromo.target,
            dependencies: [
                .target(name: CAS.CrossPromo.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.CrossPromo.pathAdapter,
            resources: [
                .process("Resources")
            ]
        ),
        .binaryTarget(
            name: CAS.CrossPromo.binaryAdapter,
            url:
                "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationCrossPromo-4.1.0.0.zip",
            checksum: "ddd50c5be23d1da33b1ac7799d3e12d08635687425055e07bb9a2a387b8a32e0"
        ),

        // MARK: - InMobi

        .target(
            name: CAS.InMobi.target,
            dependencies: [
                .target(name: CAS.InMobi.binarySDK),
                .target(name: CAS.InMobi.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.InMobi.pathAdapter,
            linkerSettings: [
                .linkedLibrary("sqlite3.0"),
                .linkedFramework("WebKit"),
            ]
        ),
        .binaryTarget(
            name: CAS.InMobi.binarySDK,
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-11.2.0.zip",
            checksum: "6013c4f6d5bb170f9a4931512e1f9623b5b3ed3a5ed59a442c6c234665af4e89"
        ),
        .binaryTarget(
            name: CAS.InMobi.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationInMobi-11.2.0.0.zip",
            checksum: "38df856aa625c2a407f5aa9ea51818af7d4772bee97c21f0741218d763bc2320"
        ),

        // MARK: - Yango Ads

        .target(
            name: CAS.YangoAds.target,
            dependencies: [
                .target(name: CAS.YangoAds.binarySDK),
                .target(name: CAS.YangoAds.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
                .product(name: "AppMetricaCore", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaCrashes", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "DivKitBinaryCompatibilityFacade", package: "divkit-ios-facade"),
            ],
            path: CAS.YangoAds.pathAdapter,
            resources: [
                .process("Resources")
            ]
        ),
        .binaryTarget(
            name: CAS.YangoAds.binarySDK,
            url: "https://github.com/yandexmobile/yandex-ads-sdk-ios/releases/download/7.18.4/YandexMobileAds.zip",
            checksum: "00261a0eeb82ebd7ec3b25ce31e4c03ea6d1e2b1038f0d0d6a5e82467d50d78c"
        ),
        .binaryTarget(
            name: CAS.YangoAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationYangoAds-7.18.4.0.zip",
            checksum: "d90ae9b8798eb086a64752f03d6e74e7502f401ad1c6188673829ce7cf561c52"
        ),

        // MARK: - YsoNetwork

        .target(
            name: CAS.YsoNetwork.target,
            dependencies: [
                .target(name: CAS.YsoNetwork.binarySDK),
                .target(name: CAS.YsoNetwork.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.YsoNetwork.pathAdapter
        ),
        .binaryTarget(
            name: CAS.YsoNetwork.binarySDK,
            url:
                "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk/get/794e6daf0ed2dc2f237714f4e86d24de7a888a63.zip",
            checksum: "237087e30b6382f0ff11b53b2c892f213d0fb34e6bf5aec3810316a3728dc978"
        ),
        .binaryTarget(
            name: CAS.YsoNetwork.binaryAdapter,
            url:
                "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationYsoNetwork-1.1.31.2.zip",
            checksum: "a8b70539b115757e8784fbc0109884e6c7451ca2d50c3bcb03e858e96921c561"
        ),

        // MARK: - AudienceNetwork

        .target(
            name: CAS.AudienceNetwork.target,
            dependencies: [
                .target(name: CAS.AudienceNetwork.binarySDK),
                .target(name: CAS.AudienceNetwork.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
            ],
            path: CAS.AudienceNetwork.pathAdapter,
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
                .linkedLibrary("z"),
            ]
        ),
        .binaryTarget(
            name: CAS.AudienceNetwork.binarySDK,
            url: "https://developers.facebook.com/resources/FBAudienceNetwork-6.21.1.zip",
            checksum: "acb53ced101d439131f0c5d0cf3da609129227140a66e4f51ec77a368a753843"
        ),
        .binaryTarget(
            name: CAS.AudienceNetwork.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/CASMediationAudienceNetwork-6.21.1.0.zip",
            checksum: "44b2b069d960c79efeda502fcbf839ebdd5d23ad859c8a4a82f580efd7f38925"
        ),

        // MARK: - Pangle

        .target(
            name: CAS.Pangle.target,
            dependencies: [
                .target(name: CAS.Pangle.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "AdsGlobalPackage", package: "AdsGlobalPackage"),
            ],
            path: CAS.Pangle.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Pangle.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationPangle-8.0.0.7.0.zip",
            checksum: "7e87859e97b434061c13172504f6944889df07ba4e835bf15358b2aec7da9060"
        ),

        // MARK: - Maticoo

        .target(
            name: CAS.Maticoo.target,
            dependencies: [
                .target(name: CAS.Maticoo.binarySDK),
                .target(name: CAS.Maticoo.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.Maticoo.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Maticoo.binarySDK,
            url: "https://github.com/cloudadrd/zMaticooPodSpec/archive/refs/tags/1.5.6.zip",
            checksum: "07df0d938a71bdbded8b2e6cd0eaf38b85a0918a0e229bac47f29625e1421e7c"
        ),
        .binaryTarget(
            name: CAS.Maticoo.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.0/CASMediationMaticoo-1.5.6.0.zip",
            checksum: "6f83092ad32463b4b3c49ee555eca1c9fa19c0585c562b143b270902e083b26f"
        ),

        // MARK: - PubMatic

        .target(
            name: CAS.PubMatic.target,
            dependencies: [
                .target(name: CAS.PubMatic.binaryAdapter),
                .target(name: CAS.AppLovin.target),
                .product(name: "OpenWrapSDK", package: "OpenWrapSDK-Swift-Package"),
            ],
            path: CAS.PubMatic.pathAdapter
        ),
        .binaryTarget(
            name: CAS.PubMatic.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationPubMatic-5.1.0.0.zip",
            checksum: "a0295555f926940e6dc7f236492860cb9bec3b63e4908b056c5223a093406708"
        ),

        // MARK: - Ogury

        .target(
            name: CAS.Ogury.target,
            dependencies: [
                .target(name: CAS.Ogury.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "OgurySdk", package: "ogury-sdk-spm"),
            ],
            path: CAS.Ogury.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Ogury.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationOgury-5.2.2.0.zip",
            checksum: "8d96943caa1dd118b9d6c622205443ebc04f78ee16dc9a3cd4a0f37ec644cb3e"
        ),

        // MARK: - Chartboost

        .target(
            name: CAS.Chartboost.target,
            dependencies: [
                .target(name: CAS.Chartboost.binarySDK),
                .target(name: CAS.Chartboost.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
            ],
            path: CAS.Chartboost.pathAdapter,
            linkerSettings: [
                .linkedFramework("AdSupport"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("StoreKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("UIKit"),
                .linkedFramework("WebKit"),
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("SafariServices"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("AppTrackingTransparency"),
            ]
        ),
        .binaryTarget(
            name: CAS.Chartboost.binarySDK,
            url: "https://s3.amazonaws.com/chartboost/sdk/9.11.0/Chartboost-iOS-9.11.0.zip",
            checksum: "45e0b6bda95cedea7a4b55da023aedd97e8bbb9e6abc121fb207edf008e6ec6b"
        ),
        .binaryTarget(
            name: CAS.Chartboost.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.0/CASMediationChartboost-9.11.0.0.zip",
            checksum: "c792a153ade807635b9d5b5d907bdd57ff2429723aa3c91f70a4ffd9f586d909"
        ),

        // MARK: - Verve

        .target(
            name: CAS.Verve.target,
            dependencies: [
                .target(name: CAS.Verve.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "HyBid", package: "hybid-ios-spm-sdk"),
            ],
            path: CAS.Verve.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Verve.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.5/CASMediationVerve-3.8.0.0.zip",
            checksum: "0e1d3f7f6b7f52ae707721445a221397e6fd6251ac86de2629c27bb9c0d729a5"
        ),

        // MARK: - Bigo Ads

        .target(
            name: CAS.Bigo.target,
            dependencies: [
                .target(name: CAS.Bigo.binarySDK),
                .target(name: CAS.Bigo.binaryAdapter),
                .target(name: baseTarget),
            ],
            path: CAS.Bigo.pathAdapter,
            linkerSettings: [
                .linkedLibrary("c++"),
            ]
        ),
        .binaryTarget(
            name: CAS.Bigo.binarySDK,
            url: "https://static-fed-oss.adsbigo.com/bigoads-framework/BigoADS_50102_84.zip",
            checksum: "409659cd4db163ff0ea52e4fbbb5b667bb9f6830b2d63be71eb13f126d60280f"
        ),
        .binaryTarget(
            name: CAS.Bigo.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationBigo-5.1.2.1.zip",
            checksum: "8e6063a8cd5047eee06cbd1b86f92166c89aae77d4feec17f116c3de19a719a3"
        ),
    ]
)
