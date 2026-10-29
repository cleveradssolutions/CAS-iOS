# CAS.AI Framework for iOS 
[![Cocoapods](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-Specs/master/CAS.json)](https://github.com/cleveradssolutions/CAS-Specs/tree/master/Specs/CleverAdsSolutions-SDK)
[![AdNetworksID](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-iOS/master/AdNetworkIdentifiers/AdNetworksShield.json)](https://github.com/cleveradssolutions/CAS-iOS/blob/master/AdNetworkIdentifiers/README.md)
[![App-ads.txt](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/App-ads.txt/master/Shield.json)](https://docs.page/cleveradssolutions/docs/general/Authorized-Sellers-for-Apps)

The CAS.AI Mobile Ads Framework (by CleverAdsSolutions) offers advanced mobile advertising capabilities with refined ad formats and streamlined APIs to access multiple ad networks and maximize monetization in mobile apps.

This repository contains the official CAS.AI iOS Framework, enabling iOS developers to easily integrate and monetize their apps.

## Documentation
For setup instructions, usage examples, and API details, refer to the [Developer Guide](https://docs.page/cleveradssolutions/docs/iOS).

## Demo application
Each iOS example app on this repository takes the CAS.AI Framework from this repository as a Swift Package, and adds the `CleverAdsSolutionsSPM` product alone. Mediation adapters are products of the same package: add the `CASMediation*` ones your app needs to the application target.

1. Open the `.xcodeproj` file with Xcode.
2. Wait for Xcode to resolve the package, then run the app.
3. [Optional] **File > Packages > Update to Latest Package Versions** to move to the newest release of the Framework.

## Supported architectures
- Device: arm64
- Simulator: arm64, x86_64

## Feedback & Contributions
Found a bug? Have a feature request or suggestion?
Please open an issue using [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## License
The CAS.AI iOS-SDK is available under a commercial license. See the LICENSE file for more info.
