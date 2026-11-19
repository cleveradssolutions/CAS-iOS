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
    case Bigo
    case BlueSea
    case Bidease
    case Maticoo
    case BidMachine
    case Monetrix
    //case SuperAwesome cocoapods conflict

    // Ads Solutions: one product pulls a whole set of adapters. The lists below are generated automaticaly.
    static var solutions: [(name: String, adapters: [CAS])] {
        return [
            ("AdsOptimalSolutions", [
                .IronSource,
                .UnityAds,
                .GoogleAds,
                .LiftoffMonetize,
                .InMobi,
                .Mintegral,
                .AppLovin,
                .Pangle,
                .Bigo,
                .YangoAds,
                .AudienceNetwork,
                .YsoNetwork,
                .Exchange,
                .Moloco,
            ]),
            ("AdsFamiliesSolutions", [
                .IronSource,
                .UnityAds,
                .GoogleAds,
                .LiftoffMonetize,
                .InMobi,
                .Chartboost,
                .Kidoz,
                .Mintegral,
                .YangoAds,
            ]),
            ("AdsPublishingSolutions", [
                .IronSource,
                .UnityAds,
                .GoogleAds,
                .LiftoffMonetize,
                .InMobi,
                .Chartboost,
                .Mintegral,
                .AppLovin,
                .Pangle,
                .Bigo,
                .YangoAds,
                .AudienceNetwork,
                .YsoNetwork,
                .Exchange,
                .Ogury,
                .Monetrix,
                .Moloco,
            ]),
            ("AdsVPNCompliantSolutions", [
                .IronSource,
                .UnityAds,
                .GoogleAds,
                .LiftoffMonetize,
                .InMobi,
                .Mintegral,
                .Bigo,
                .YangoAds,
                .YsoNetwork,
                .Monetrix,
                .Bidease,
                .BlueSea,
            ]),
        ]
    }

    var product: Product {
        return Product.library(name: "CASMediation" + rawValue, targets: [target])
    }

    static var allProducts: [Product] {
        var products = [
            Product.library(name: "CleverAdsSolutionsSPM", targets: [baseTarget])
        ]
        allCases.forEach { products.append($0.product) }
        solutions.forEach { solution in
            products.append(Product.library(
                name: solution.name,
                targets: solution.adapters.map { $0.target }
            ))
        }
        return products
    }

    var target: String { "CASMediation" + rawValue + "Target" }
    var binaryAdapter: String { "CASMediation" + rawValue }
    var targetSDK: String { binarySDK + "Target" }
    var binarySDK: String { rawValue + "SPM" }
    var pathAdapter: String {
        let adapterName = self == CAS.Exchange ? "CAS" + rawValue : rawValue
        return "Adapters/" + adapterName + "/spm"
    }
}

let package = Package(
    name: "CleverAdsSolutions",
    platforms: [.iOS(.v15)],
    products: CAS.allProducts,
    dependencies: [
        .package(url: "https://github.com/ironsource-mobile/LevelPlay-Swift-Package.git", exact: "9.8.0"),
        .package(url: "https://github.com/Unity-Technologies/Unity-Ads-Swift-Package.git", exact: "4.22.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "13.13.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager.git", exact: "7.8.0"),
        .package(url: "https://github.com/InMobi/InMobiSDK-Swift-Package.git", exact: "11.5.0"),
        .package(url: "https://github.com/ChartBoost/chartboost-monetization-ios-sdk.git", exact: "9.14.2"),
        .package(url: "https://github.com/inner-active/DTExchangeSDK-iOS-SPM.git", exact: "8.5.2"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package.git", exact: "8.1.9"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", exact: "13.7.0"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage.git", exact: "8.4.0-release.8"),
        .package(url: "https://github.com/bigo-ads/BigoADS-Swift-Package.git", exact: "6.2.0"),
        .package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", exact: "8.7.0"),
        .package(url: "https://github.com/facebook/FBAudienceNetwork.git", exact: "6.22.1"),
        .package(url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk.git", exact: "1.2.1"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage.git", exact: "4.15.0"),
        .package(url: "https://github.com/JunGroupProductions/HyprMX-SDK-SPM.git", exact: "6.4.7"),
        .package(url: "https://github.com/Ogury/ogury-sdk-spm.git", exact: "5.4.0"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/vervegroup/Smaato-ios-sdk-standalone.git", exact: "23.2.3"),
        .package(url: "https://github.com/cloudadrd/zMaticooPodSpec.git", exact: "2.3.3"),
        .package(url: "https://github.com/vervegroup/hybid-ios-spm-sdk.git", exact: "3.9.3"),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package.git", exact: "5.6.0"),
        .package(url: "https://github.com/displayio/DIOSDK.git", exact: "4.8.2"),
        .package(url: "https://github.com/bidease/BideaseSDK-iOS.git", exact: "3.0.3"),
        .package(url: "https://github.com/moloco/moloco-sdk-ios-spm.git", exact: "4.12.0"),
        .package(url: "https://github.com/blueseasx/BlueSeaSDK-Swift-Package.git", exact: "1.9.1"),
        .package(url: "https://github.com/bidmachine/BidMachine-SPM.git", exact: "3.8.2"),
    ],

    targets: [
        // MARK: - CAS Base

        .target(
            name: baseTarget,
            dependencies: [
                .target(name: baseBinary)
            ],
            path: "Adapters/Base/spm",
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
                .linkedLibrary("z"),
            ]
        ),
        .binaryTarget(
            name: baseBinary,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CleverAdsSolutions-4.8.5-beta1.zip",
            checksum: "1f2187dac5c8453dacc3a4a6126d77dd850885c013d21d52906e8a41a23740ea"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationIronSource-9.8.0.0.zip",
            checksum: "b930fbe5604170ec4ffa009ce67d314f6b24ed4b6477979e6bc2cd8dbcfb5b11"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationUnityAds-4.22.0.0.zip",
            checksum: "9051a7c7c79182f5879ebc3f2a3f37af405b1f516b18ac3477ea505f8c989f51"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationHyprMX-6.4.7.0.zip",
            checksum: "f78905f8bb75166e56584bd408917abdfc427794cd809d12bf040993c84cb927"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationAppLovin-13.7.0.0.zip",
            checksum: "55cf26d7d34b562f2dbd47fcec8e9eaf5ae70476c6f82ec6ac310e6efd28f48f"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationGoogleAds-13.13.0.0.zip",
            checksum: "dfe9a96ce015b951088e91682b9deed0cd685c90ef321832df9bfc4d010a7797"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationLiftoffMonetize-7.8.0.0.zip",
            checksum: "e8972d7133d68358238d5a8b33c026eef8d7e0ee23c990a5e656225414138a07"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationStartIO-4.15.0.0.zip",
            checksum: "904368e5cbe1182c32ca054efc2395c77b2ae404adfdff4f2e68cebc0df8ab0c"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationMintegral-8.1.9.0.zip",
            checksum: "fe56fff3a9542c5a28af04a79ff57a1ec15bc8a70fb5475c14c4ad44d175da5d"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta.4/CASMediationDTExchange-8.5.2.0.zip",
            checksum: "f14158590bf9ca16063f543a327e33aeb6710c55d3a1181467e197b88cb623f8"
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
            path: CAS.InMobi.pathAdapter
        ),
        .binaryTarget(
            name: CAS.InMobi.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationInMobi-11.5.0.1.zip",
            checksum: "042dd00dfe09aa920cfe8b77da2fe7d409c591c0f220983df150a85cfc43dee5"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationYangoAds-8.7.0.0.zip",
            checksum: "437cee353b1110de8581bf6626293f9ad15631ef2336a184f98c507483d64123"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationAudienceNetwork-6.22.1.0.zip",
            checksum: "3ee5aea6783aa1949b34c6b9ba11bba14f8703274bfc359892bfaf37df3e83ab"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationPangle-8.4.0.8.0.zip",
            checksum: "93135739dcc859f1264ba8cc0aee73dacc6eb505665e16fbb37e7518b87520e6"
        ),

        // MARK: - Maticoo
        
        .target(
            name: CAS.Maticoo.target,
            dependencies: [
                .target(name: CAS.Maticoo.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "MaticooSDK", package: "zMaticooPodSpec"),
            ],
            path: CAS.Maticoo.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Maticoo.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta.4/CASMediationMaticoo-2.3.3.0.zip",
            checksum: "8ba71534574c14fdba9ef0bea649a449a6f7dd2fcaa0a2e81b675e120b8e664f"
        ),
        
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationPubMatic-5.6.0.0.zip",
            checksum: "d870f4764911adf67071cf583fc05ccf004925d52a7de7e663895952888a5df9"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationOgury-5.4.0.0.zip",
            checksum: "1e582e0dbaac5785faada5f129443c6efa35685b8a78d3dc2d45261f7c661c0d"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationChartboost-9.14.2.0.zip",
            checksum: "61a1b59c6cd7bb5c1182bce4a426ed4fd79e8b64996f975c4a4c178ff569a71e"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta.4/CASMediationVerve-3.9.3.1.zip",
            checksum: "e0c1e97b97854acc8d722112a24d0548e013cd44730a3e4f5ec5cc44695fb182"
        ),

        // MARK: - Bigo Ads
        
        .target(
            name: CAS.Bigo.target,
            dependencies: [
                .target(name: CAS.Bigo.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "BigoADS", package: "BigoADS-Swift-Package"),
            ],
            path: CAS.Bigo.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Bigo.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.5-beta1/CASMediationBigo-6.2.0.0.zip",
            checksum: "b4110fa577f025aeb92c7f2fe9f417868a148da228812e2243a1ee9e950ec293"
        ),

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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationDisplayIO-4.8.2.0.zip",
            checksum: "3663e4a7a1a1be83cb9f888146ad39e9edfefc26b88b5541c5b80ac4a21b590f"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationSmaato-23.2.3.0.zip",
            checksum: "f0de83e356df00bc19d3e4253253ee2673fa7c1dce8a219252c49dc1d0739b67"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta3/CASMediationMoloco-4.12.0.0.zip",
            checksum: "bca185c301b623c9ee5711b9428ec1adb18d769a2606246bd14cf54fc35ddc54"
        ),
        
        // MARK: - BlueSea

        .target(
            name: CAS.BlueSea.target,
            dependencies: [
                .target(name: CAS.BlueSea.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "BlueSeaSDK", package: "BlueSeaSDK-Swift-Package"),
            ],
            path: CAS.BlueSea.pathAdapter
        ),
        .binaryTarget(
            name: CAS.BlueSea.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationBlueSea-1.9.1.0.zip",
            checksum: "cbe13c6e52a08a23fa741ebfbcc1df67c3c041e569e61f3523711d37dc905258"
        ),

        // MARK: - Bidease

        .target(
            name: CAS.Bidease.target,
            dependencies: [
                .target(name: CAS.Bidease.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "BideaseSDK", package: "BideaseSDK-iOS"),
            ],
            path: CAS.Bidease.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Bidease.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta3/CASMediationBidease-3.0.3.0.zip",
            checksum: "2e38d9af2e4c927af93c3649dfaec65e82737b5afe96184de0c7754074a772fb"
        ),

        // MARK: - BidMachine

        .target(
            name: CAS.BidMachine.target,
            dependencies: [
                .target(name: CAS.BidMachine.binaryAdapter),
                .target(name: baseTarget),
                .product(name: "BidMachine", package: "BidMachine-SPM"),
            ],
            path: CAS.BidMachine.pathAdapter
        ),
        .binaryTarget(
            name: CAS.BidMachine.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-beta.4/CASMediationBidMachine-3.8.2.1.zip",
            checksum: "c68034e79b62ffad1f6bc0cf4b2c7b1568c0d01763ffabf89f62f5ca0a75896f"
        ),

        // MARK: - Monetrix

        .target(
            name: CAS.Monetrix.target,
            dependencies: [
                .target(name: CAS.Monetrix.binaryAdapter),
                .target(name: baseTarget),
                .target(name: "MonetrixAds"),
            ],
            path: CAS.Monetrix.pathAdapter
        ),
        .binaryTarget(
            name: CAS.Monetrix.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationMonetrix-1.3.0.1.zip",
            checksum: "4568c7ca3f05f0848a9074011e3938cddb13c7774a1480e1be54dbde7619aa1f"
        ),
        .binaryTarget(
            name: "MonetrixAds",
            url: "https://monetrix.ai/sdk/dl/1.3.0.1/MonetrixAdsSpm.zip",
            checksum: "e95a9a912a40ee4fa20079ef98e46dd12e573094c3445cefce88aa15c3de0358"
        )
    ]
)
