// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let baseTarget = "CASBaseResources"
let baseBinary = "CleverAdsSolutions"

enum CAS: String, CaseIterable {
    case Exchange
    case CrossPromo
    case IronSource
    case UnityAds
    case HyprMX
    case Kidoz
    case Prado
    case AppLovin
    case GoogleAds
    case LiftoffMonetize
    case AudienceNetwork
    case StartIO
    case Mintegral
    case DTExchange
    case InMobi
    case YangoAds
    case YsoNetwork
    case Pangle
    case PubMatic
    case Ogury
    case Chartboost
    case Verve
    case DisplayIO
    case Smaato
    case Moloco
    //case Bigo
    //case Bidease
    //case Maticoo
    //case Monetrix
    //case SuperAwesome

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
        .package(url: "https://github.com/ironsource-mobile/LevelPlay-Swift-Package.git", exact: "9.5.0"),
        .package(url: "https://github.com/Unity-Technologies/Unity-Ads-Swift-Package.git", exact: "4.19.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "13.7.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager.git", exact: "7.7.6"),
        .package(url: "https://github.com/InMobi/InMobiSDK-Swift-Package.git", exact: "11.4.0"),
        .package(url: "https://github.com/ChartBoost/chartboost-monetization-ios-sdk.git", exact: "9.13.0"),
        .package(url: "https://github.com/inner-active/DTExchangeSDK-iOS-SPM.git", exact: "8.4.9"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package.git", exact: "8.1.6"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", exact: "13.6.3"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "8.2.0-release.8"),
        .package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", exact: "8.3.0"),
        .package(url: "https://github.com/facebook/FBAudienceNetwork.git", exact: "6.22.0"),
        .package(url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk.git", exact: "1.2.1"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage.git", exact: "4.14.0"),
        .package(url: "https://github.com/JunGroupProductions/HyprMX-SDK-SPM.git", exact: "6.4.6"),
        .package(url: "https://github.com/Ogury/ogury-sdk-spm.git", exact: "5.2.3"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/vervegroup/Smaato-ios-sdk-standalone.git", exact: "23.2.0"),
        .package(url: "https://github.com/vervegroup/hybid-ios-spm-sdk.git", exact: "3.9.0"),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package.git", exact: "5.2.0"),
        .package(url: "https://github.com/displayio/DIOSDK.git", exact: "4.7.5"),
        .package(url: "https://github.com/moloco/moloco-sdk-ios-spm.git", exact: "4.9.0"),
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
                .linkedFramework("StoreKit"),
            ]
        ),
        .binaryTarget(
            name: baseBinary,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CleverAdsSolutions-4.8.1-beta1.zip",
            checksum: "3ed0e4f71d73b87284fa5580a10990d7f598a5d50a4f72ee9c71fe36550d0202"
        ),

        // MARK: - IronSource

        .target(
            name: CAS.IronSource.target,
            dependencies: [
                .target(name: CAS.IronSource.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "UnityMediationSDK", package: "LevelPlay-Swift-Package"),
            ],
            path: CAS.IronSource.pathAdapter,
        ),
        .binaryTarget(
            name: CAS.IronSource.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationIronSource-9.5.0.1.zip",
            checksum: "37f72151786691c2ac3cef4ba7d05305da7a1c1e979a774d6e494139d44eaabc"
        ),

        // MARK: - UnityAds

        .target(
            name: CAS.UnityAds.target,
            dependencies: [
                .target(name: CAS.UnityAds.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
                .product(name: "UnityAds", package: "Unity-Ads-Swift-Package"),
            ],
            path: CAS.UnityAds.pathAdapter,
        ),
        .binaryTarget(
            name: CAS.UnityAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationUnityAds-4.19.0.1.zip",
            checksum: "dad7e7a46faebd3879d48908fc852059d9f084a6fea82075c3888c5c06fd244c"
        ),

        // MARK: HyprMX

        .target(
            name: CAS.HyprMX.target,
            dependencies: [
                .target(name: CAS.HyprMX.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "HyprMX", package: "HyprMX-SDK-SPM"),
            ],
            path: CAS.HyprMX.pathAdapter
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationAppLovin-13.6.3.2.zip",
            checksum: "207fc857b2b0b96d94b677a13117849284602efd3af399c0dd9a6090f0c6ae0a"
        ),

        // MARK: GoogleAds

        .target(
            name: CAS.GoogleAds.target,
            dependencies: [
                .target(name: CAS.GoogleAds.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: CAS.GoogleAds.pathAdapter
        ),
        .binaryTarget(
            name: CAS.GoogleAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationGoogleAds-13.7.0.0.zip",
            checksum: "610d12085cccd7cf265ddced18b1cd2f4fcfc4ff7028f6ff96d13aac294af1a9"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationLiftoffMonetize-7.7.6.1.zip",
            checksum: "537469a39a46faa98fbd7aba3f5cec253111b6eeb11c8917aabb5519fe83afb5"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationStartIO-4.14.0.0.zip",
            checksum: "3aee950b882bb0579e7ec5ac178803c46609bed39abeba44b6e69e812096ec86"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationMintegral-8.1.6.0.zip",
            checksum: "8034c1ce46d691e341ad5036f5ce45295d5c825629207addd1578fbbfa4e15f6"
        ),

        // MARK: - DTExchange

        .target(
            name: CAS.DTExchange.target,
            dependencies: [
                .target(name: CAS.DTExchange.binaryAdapter),
                .target(name: baseTarget),
                .target(name: CAS.IronSource.target),
                .product(name: "DTExchangeSDK", package: "DTExchangeSDK-iOS-SPM"),
            ],
            path: CAS.DTExchange.pathAdapter
        ),
        .binaryTarget(
            name: CAS.DTExchange.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationDTExchange-8.4.9.0.zip",
            checksum: "9880ea100d47d7bcf15cb40084274236de410fd030d657d9f79308cb93a8d0a8"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationCrossPromo-4.8.0.0.zip",
            checksum: "cb9123705a7f45aabc495435d202a0ef55280a0560df884d77be7c9c24f2fced"
        ),

        // MARK: - InMobi

        .target(
            name: CAS.InMobi.target,
            dependencies: [
                .target(name: CAS.InMobi.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "InMobiSDK", package: "InMobiSDK-Swift-Package"),
            ],
            path: CAS.InMobi.pathAdapter,
            linkerSettings: [
                .linkedLibrary("sqlite3.0"),
                .linkedFramework("WebKit"),
            ]
        ),
        .binaryTarget(
            name: CAS.InMobi.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationInMobi-11.4.0.0.zip",
            checksum: "0e6c181ab23299b1f3fffced9addb45f32bf75d6744db233cec2204bbec1c5fa"
        ),

        // MARK: - Yango Ads

        .target(
            name: CAS.YangoAds.target,
            dependencies: [
                .target(name: CAS.YangoAds.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "YandexMobileAds", package: "yandex-ads-sdk-ios"),
            ],
            path: CAS.YangoAds.pathAdapter,
        ),
        .binaryTarget(
            name: CAS.YangoAds.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationYangoAds-8.3.0.0.zip",
            checksum: "c2771744b19e0a3de11d08746acef3b88fc5169ced75133c2d79a625bd5cbfd5"
        ),

        // MARK: - YsoNetwork

        .target(
            name: CAS.YsoNetwork.target,
            dependencies: [
                .target(name: CAS.YsoNetwork.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "YsoNetwork", package: "ysonetwork-ios-sdk"),
            ],
            path: CAS.YsoNetwork.pathAdapter
        ),
        .binaryTarget(
            name: CAS.YsoNetwork.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationYsoNetwork-1.2.1.0.zip",
            checksum: "c2f3d905eb2ab92bd4b4d6dc34c4a5e641bfdeddae40e6432c85baf95f1fd810"
        ),

        // MARK: - AudienceNetwork

        .target(
            name: CAS.AudienceNetwork.target,
            dependencies: [
                .target(name: CAS.AudienceNetwork.binaryAdapter),
                .target(name: CAS.GoogleAds.target),
                .product(name: "FBAudienceNetwork", package: "FBAudienceNetwork"),
            ],
            path: CAS.AudienceNetwork.pathAdapter,
        ),
        .binaryTarget(
            name: CAS.AudienceNetwork.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationAudienceNetwork-6.22.0.0.zip",
            checksum: "5f0f786a4635030eb04335eb9c6756e7a73179e68728064dfadc6f9955df07f7"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationPangle-8.2.0.8.0.zip",
            checksum: "1035c60dcf805e7627751ee28c6b4060caaa4b471e4cb961bf4562663c365928"
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
                .target(name: baseTarget),
                .product(name: "OpenWrapSDK", package: "OpenWrapSDK-Swift-Package"),
            ],
            path: CAS.PubMatic.pathAdapter
        ),
        .binaryTarget(
            name: CAS.PubMatic.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationPubMatic-5.2.0.1.zip",
            checksum: "af0e3dfe44dfc348b4b9b623f59ac7f6cfeb8b1d9d7f7ba7a4064065dd87a99b"
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
                .target(name: CAS.Chartboost.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "ChartboostSDK", package: "chartboost-monetization-ios-sdk"),
            ],
            path: CAS.Chartboost.pathAdapter,
        ),
        .binaryTarget(
            name: CAS.Chartboost.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationChartboost-9.13.0.0.zip",
            checksum: "89000499e3a46ae9acc3b7726c9527195a95f2a936c3fe0f4221b693a71ca940"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationVerve-3.9.0.1.zip",
            checksum: "1c579ce7f9db4cd62791389626ab97a075acbdcca1f5d810066807a42080a290"
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
                .target(name: CAS.AudienceNetwork.target),
                .product(name: "DIOSDK-WithoutFBAudienceNetwork", package: "DIOSDK"),
            ],
            path: CAS.DisplayIO.pathAdapter
        ),
        .binaryTarget(
            name: CAS.DisplayIO.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationDisplayIO-4.7.5.0.zip",
            checksum: "99244f3bc976f5ae1685c32f5e096184cd27b4083a281ddbd7269d14187bf32d"
        ),

        // MARK: - Smaato

        .target(
            name: CAS.Smaato.target,
            dependencies: [
                .target(name: CAS.Smaato.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "SmaatoSDK", package: "Smaato-ios-sdk-standalone"),
            ],
            path: CAS.Smaato.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Smaato.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationSmaato-23.2.0.1.zip",
            checksum: "7190ff69becb75e2d42b6fc50e357189c605f874894c6b2403742607bc96db5f"
        ),

        // MARK: - Moloco

        .target(
            name: CAS.Moloco.target,
            dependencies: [
                .target(name: CAS.Moloco.binaryAdapter),
                .target(name: CAS.IronSource.target),
                .product(name: "MolocoSDK", package: "moloco-sdk-ios-spm"),
            ],
            path: CAS.Moloco.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Moloco.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationMoloco-4.9.0.0.zip",
            checksum: "1d86f9f5e7256e3c1cae51f6a8766ca22ebb121ba936a566e2ebd603328c24ec"
        ),

    ]
)
