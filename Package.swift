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
    //case Maticoo not found
    //case Monetrix (soon) cocoapods conflict
    //case SuperAwesome cocoapods conflict

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
        let adapterName = self == CAS.Exchange ? "CAS" + rawValue : rawValue
        return "Adapters/" + adapterName + "/spm"
    }
}

let package = Package(
    name: "CleverAdsSolutions",
    platforms: [.iOS(.v15)],
    products: CAS.allProducts,
    dependencies: [
        .package(url: "https://github.com/ironsource-mobile/LevelPlay-Swift-Package.git", exact: "9.6.0"),
        .package(url: "https://github.com/Unity-Technologies/Unity-Ads-Swift-Package.git", exact: "4.20.1"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "13.11.0"),
        .package(url: "https://github.com/Vungle/VungleAdsSDK-SwiftPackageManager.git", exact: "7.7.7"),
        .package(url: "https://github.com/InMobi/InMobiSDK-Swift-Package.git", exact: "11.5.0"),
        .package(url: "https://github.com/ChartBoost/chartboost-monetization-ios-sdk.git", exact: "9.14.2"),
        .package(url: "https://github.com/inner-active/DTExchangeSDK-iOS-SPM.git", exact: "8.5.0"),
        .package(url: "https://github.com/Kidoz-SDK/kidoz-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/Mintegral-official/MintegralAdSDK-Swift-Package.git", exact: "8.1.7"),
        .package(url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git", exact: "13.6.4"),
        .package(url: "https://github.com/bytedance/AdsGlobalPackage", exact: "8.3.0-release.8"),
        .package(url: "https://github.com/bigo-ads/BigoADS-Swift-Package.git", exact: "6.1.0"),
        .package(url: "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", exact: "8.6.0"),
        .package(url: "https://github.com/facebook/FBAudienceNetwork.git", exact: "6.22.0"),
        .package(url: "https://bitbucket.org/ysocorp/ysonetwork-ios-sdk.git", exact: "1.2.1"),
        .package(url: "https://github.com/StartApp-SDK/StartAppSDK-SwiftPackage.git", exact: "4.14.0"),
        .package(url: "https://github.com/JunGroupProductions/HyprMX-SDK-SPM.git", exact: "6.4.7"),
        .package(url: "https://github.com/Ogury/ogury-sdk-spm.git", exact: "5.3.1"),
        .package(url: "https://github.com/Prado-SDK/prado-sdk-swift-package.git", exact: "10.1.5"),
        .package(url: "https://github.com/vervegroup/Smaato-ios-sdk-standalone.git", exact: "23.2.2"),
        .package(url: "https://github.com/vervegroup/hybid-ios-spm-sdk.git", exact: "3.9.2"),
        .package(url: "https://github.com/PubMatic/OpenWrapSDK-Swift-Package.git", exact: "5.4.0"),
        .package(url: "https://github.com/displayio/DIOSDK.git", exact: "4.8.1"),
        .package(url: "https://github.com/bidease/BideaseSDK-iOS.git", exact: "3.0.0"),
        .package(url: "https://github.com/moloco/moloco-sdk-ios-spm.git", exact: "4.10.0"),
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.9.0-alpha3/CleverAdsSolutions-4.9.0-alpha3.zip",
            checksum: "c52dde06909d27c938c4be03e06fa324776a12e5e1f15fb29a57299abc798f82"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationIronSource-9.6.0.1.zip",
            checksum: "bc905ffc55e10264aa91bcae25ce03aa33e5ad9625b80331fd412114728b394d"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationUnityAds-4.20.1.0.zip",
            checksum: "cbff54f289b356ef7c13de4a06ca8961697c966e8a240fe5c903f051e204180e"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationAppLovin-13.6.4.1.zip",
            checksum: "974bc4b5e915af6b88131c07773060ca358052b8d5b8976f7b4934db96f7556b"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationGoogleAds-13.11.0.0.zip",
            checksum: "dbaee334b56effc03c3e329508b22d9c2650fcf44ea75fbb4b3c7b4a721b2809"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationLiftoffMonetize-7.7.7.1.zip",
            checksum: "958f6f1ebd1781ea5e3f6293761ac6a2f5d4404c02699054bb7f06d946bde764"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationMintegral-8.1.7.1.zip",
            checksum: "58685d27cc37641bc3f90abd1302c9ba566e9ec889ea3c9c5f32569f8cad2959"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationDTExchange-8.5.0.0.zip",
            checksum: "2dbd99c0021fd548b156979313144a381ab940627a3650eb6807064b5de82ec9"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationInMobi-11.5.0.0.zip",
            checksum: "5ee3596622d555a6f853a6784a33718cae7ec5bd4de9c0cccddc58c640a66a96"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationYangoAds-8.6.0.0.zip",
            checksum: "589f25fb63571cc011cb031fdd48b04d80bade215aa093516650350512e47a7b"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.2-beta1/CASMediationAudienceNetwork-6.22.0.1.zip",
            checksum: "c0e0f20c256be4a01e176149db2961e18ee2a00f3ad0bd5d550285b1a38b1d48"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationPangle-8.3.0.8.0.zip",
            checksum: "d16af15975d56336b7b01dd70fd2bf92b10ab649934bd1e9aa7f36c4cb90d952"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationPubMatic-5.4.0.0.zip",
            checksum: "18a51a6d080f8b406c4c3e30eb871dd814fb756ca1d0d19efd6fa9c533083e27"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationOgury-5.3.1.0.zip",
            checksum: "7e0857ad081731b102cf44bcda315d3de919d38adb3d37c579970172dd3a2067"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationVerve-3.9.2.0.zip",
            checksum: "8b8334fb924eed541d1cd10ea0f54c1002f415446d9ce68c760a0908f504ee88"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationBigo-6.1.0.0.zip",
            checksum: "89f357601bc9c3a775e0a0ef29618b29fa83b579bb5d5003ce10893c0abe3991"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationDisplayIO-4.8.1.0.zip",
            checksum: "6bbb3d61ac1a4a1f1380365b04c80d46cebeb82473724b9dd50e1ba0924b2238"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationSmaato-23.2.2.0.zip",
            checksum: "08302cc7d827ff3b8c31c4b1cc7153609590822651b3ad9f22878e094dea4f6e"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.2-beta1/CASMediationMoloco-4.10.0.0.zip",
            checksum: "93b2277757924fe6301209e1271afe6958a476bd13c44c386df07043cf781bbe"
        ),
        
        // MARK: - BlueSea

        .target(
            name: CAS.BlueSea.target,
            dependencies: [
                .target(name: CAS.BlueSea.binaryAdapter),
                .target(name: baseTarget),
                .target(name: "BlueSeaSDK"),
                // TODO: migrate after BlueSeaSDK package fixed
                //.product(name: "BlueSeaSDK", package: "BlueSeaSDK-Swift-Package),
            ],
            path: CAS.BlueSea.pathAdapter
        ),
        .binaryTarget(
            name: CAS.BlueSea.binaryAdapter,
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationBlueSea-1.9.0.0.zip",
            checksum: "c921b38748de2885349748976d4903010437805ce4bcab722cc197e14936aa79"
        ),
        .binaryTarget(
            name: "BlueSeaSDK",
            url: "https://sdk.cdn.blueseasx.com/ios/V1.9.0/2026091500/BlueSeaSDK.xcframework.zip",
            checksum: "892c2706b75a8308513a782c2a73858bb5d1648fe11e4c3ef19cccb468d22c67"
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
            url: "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationBidease-3.0.0.0.zip",
            checksum: "32789d89c08542e5a101dd73cd1ffcd43e5979c7de688a6f2b431c86ea419147"
        ),

    ]
)
