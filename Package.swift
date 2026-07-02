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

    /// https://github.com/CocoaPods/Specs/blob/master/Specs/7/7/b/IronSourceSDK/
    case IronSource

    /// https://github.com/CocoaPods/Specs/blob/master/Specs/2/e/8/UnityAds/
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
    //case Maticoo

    /// https://github.com/PubMatic/OpenWrapSDK-Swift-Package
    case PubMatic

    /// https://github.com/Ogury/ogury-sdk-spm
    case Ogury
    /// https://github.com/CocoaPods/Specs/blob/master/Specs/5/3/e/ChartboostSDK/
    case Chartboost

    /// https://github.com/vervegroup/hybid-ios-spm-sdk
    case Verve

    /// https://github.com/CocoaPods/Specs/tree/master/Specs/a/5/5/Bigo/
    //case Bigo

    /// https://github.com/displayio/DIOSDK
    case DisplayIO

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
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", exact: "13.6.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager", exact: "7.7.4"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package", exact: "10.1.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package", exact: "8.1.5"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package", exact: "13.6.3"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "8.1.1-release.0"),
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", .upToNextMinor(from: "6.3.0")),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage", exact: "4.13.0"),
        .package(url: "https://github.com/JunGroupProductions/HyprMX-SDK-SPM", exact: "6.4.6"),
        .package(url: "https://github.com/Ogury/ogury-sdk-spm", exact: "5.2.3"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package", exact: "10.1.5"),
        .package(url: "https://github.com/vervegroup/hybid-ios-spm-sdk", exact: "3.8.1"),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package", exact: "5.1.1"),
        .package(url: "https://github.com/displayio/DIOSDK", exact: "4.7.4"),
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CleverAdsSolutions-4.8.0-beta1.zip",
            checksum: "450f9a637971733c61958096f4ab0aa10d3efe5b90cddddad4fdadda997b67b3"
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
            url: "https://github.com/ironsource-mobile/iOS-sdk/raw/master/9.5.0/IronSource9.5.0.zip",
            checksum: "925ec91a408809da6021b8cb2f7abb6b463521872ec8952cdf29ed636e65aa3b"
        ),
        .binaryTarget(
            name: "IronSourceAdQualitySPM",
            url: "https://github.com/ironsource-mobile/iOS-adqualitysdk/releases/download/9.7.0/IronSourceAdQualitySDK-ios-v9.7.0.zip",
            checksum: "5962af8d75db7156cfc4fcb7c7c5b006c236cfa5287518367c4c481bad1f4c3d"
        ),
        .binaryTarget(
            name: CAS.IronSource.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationIronSource-9.5.0.0.zip",
            checksum: "006d6a2d026c9845d46e4546563e79c66ee18be7030080110def19eeeddbce67"
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
            url: "https://github.com/Unity-Technologies/unity-ads-ios/releases/download/4.18.1/UnityAds.zip",
            checksum: "62cac3d0df3c8e0106f364f0e456f4edb42b6364dd9dc44b1d13985f70c2fbd1"
        ),
        .binaryTarget(
            name: CAS.UnityAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.3/CASMediationUnityAds-4.18.1.0.zip",
            checksum: "f38e157ece3e812b4ae5be722406f87488b5d755309b53333b1b99f3292b0b22"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationKidoz-10.1.5.1.zip",
            checksum: "042933c2e5b82b3b8c0e50177e110670a923e947f752036e72e503e935bd81b9"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationPrado-10.1.5.1.zip",
            checksum: "4b0de5f438d8c6ccdb6d501b52bf2450b0163d0c35d0491ea71326985f7ef78d"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationAppLovin-13.6.3.1.zip",
            checksum: "aeb66ab705c7ea1e08f199e73863c1033b2416c2ce8b120d2eca34bd94bcdae5"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationGoogleAds-13.6.0.0.zip",
            checksum: "69c29ea852e5020b1286229320ccdfcb94a87bb345c441dc45973ae1a114ac4f"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.4/CASMediationLiftoffMonetize-7.7.4.0.zip",
            checksum: "24a4c2857d7cb301bf5dca772bfd9b1b3635c8e8cb1d03b13ec9a53f2553ab33"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.4/CASMediationMintegral-8.1.5.0.zip",
            checksum: "0cc7f53cdce8df19499f5eeb008a6a5efda16c5c14bb7ab063c8dc26181170b8"
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
            url: "https://github.com/inner-active/InneractiveAdSDK-iOS/archive/refs/heads/8.4.7.zip",
            checksum: "5e770df2125adee8596cef35ee7f7d52cf0865ac9f65df7b8ef4eaf2d9bba138"
        ),
        .binaryTarget(
            name: CAS.DTExchange.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationDTExchange-8.4.7.0.zip",
            checksum: "a5dedd40ff937ec8b4d16866ce5cfd75330f108c1847390653f484101ce59054"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.0/CASMediationCrossPromo-4.1.0.1.zip",
            checksum: "d7a6b7a88ed3b0dd8d3fe3944f5356ac2d039a1de47087d8bfe2f4d1595e8dc5"
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
            url: "https://dl.inmobi.com/inmobi-sdk/IM/InMobi-iOS-SDK-11.3.0.zip",
            checksum: "1dc4583ad8718845180903bfa6accc17c5248eca6d0aabbd43b9fb0dad1f58ce"
        ),
        .binaryTarget(
            name: CAS.InMobi.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationInMobi-11.3.0.0.zip",
            checksum: "882fafb6488784aed214e16a4555261318eee543182f00881fd45b2b61b09ff6"
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
                .product(name: "AppMetricaLibraryAdapter", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaAdSupport", package: "appmetrica-sdk-ios"),
                .product(name: "AppMetricaIDSync", package: "appmetrica-sdk-ios"),
            ],
            path: CAS.YangoAds.pathAdapter,
            resources: [
                .process("Resources")
            ]
        ),
        .binaryTarget(
            name: CAS.YangoAds.binarySDK,
            url: "https://ads-mobile-sdk.s3.yandex.net/Yandex/YandexMobileAds/8.1.0/spm/ca020bc8-a791-449d-a228-e726ba619562.zip",
            checksum: "796f41ce5f415e1e4281fe9d902ec4e3ea4f083013a910b5f7435733ac2decbc"
        ),
        .binaryTarget(
            name: CAS.YangoAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.4/CASMediationYangoAds-8.1.0.1.zip",
            checksum: "5da3fa593b43a94a1a88f0e885491f1a3da185ff3af9e3226eeb197f0ca76736"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationPangle-8.1.1.0.0.zip",
            checksum: "02576f04030a9e40ebce1b8af118d6fd92c73c975376faed3f6d4d445e5e44b6"
        ),

        // MARK: - Maticoo
        /*
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
        */

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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.1/CASMediationPubMatic-5.1.1.0.zip",
            checksum: "0a48379ab6604bd4f688fdab37f278008e1ee392f960d70e636faf48802d3dfe"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationOgury-5.2.3.0.zip",
            checksum: "e7fc19ccf538f28f7115c9689fda734936df55824475763e20c4ade9f42fca0b"
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
            url: "https://s3.amazonaws.com/chartboost/sdk/9.12.0/Chartboost-iOS-9.12.0.zip",
            checksum: "8a611fed3d3e76be3faf13ffcfda6703c90abcbf415d610a6270d515dc9ae271"
        ),
        .binaryTarget(
            name: CAS.Chartboost.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.6/CASMediationChartboost-9.12.0.0.zip",
            checksum: "dbe2da10e7afc1b77c899c1c71fa134e5658dc93edc784aad2b3f8dfcd42f372"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.0/CASMediationVerve-3.8.1.0.zip",
            checksum: "eb43caca6f0777f11041ce1e0de12e8f9b8c8827447851fa4f01c08fe960f67d"
        ),

        // MARK: - Bigo Ads
        /*
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
            url: "https://static-fed-oss.adsbigo.com/bigoads-framework/BigoADS_50201_91.zip",
            checksum: "7830793144e15ef4c52c5b47b040d7824585d54700d97eeb6d4ff29bc508bc17"
        ),
        .binaryTarget(
            name: CAS.Bigo.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.4/CASMediationBigo-5.2.1.0.zip",
            checksum: "8b64f175f726189b91eed4d44ae40c1cf27f8774d0146fdf96ec3305ad3b7237"
        ),
        */

        // MARK: Display IO

        .target(
            name: CAS.DisplayIO.target,
            dependencies: [
                .target(name: CAS.DisplayIO.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "DIOSDK", package: "DIOSDK"),
            ],
            path: CAS.DisplayIO.pathAdapter
        ),
        .binaryTarget(
            name: CAS.DisplayIO.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationDisplayIO-4.7.4.0.zip",
            checksum: "b51c2109552732e36033a6b4f5e38550838bedb71b2e3c3becffc7db9569735d"
        ),

    ]
)
