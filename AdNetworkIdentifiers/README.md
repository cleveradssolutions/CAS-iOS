# AdAttributionKit & SKAdNetworkItems Configuration
![AdNetworksID](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-iOS/master/AdNetworkIdentifiers/AdNetworksShield.json)

To ensure proper ad attribution and maximize revenue performance, you must configure both **SKAdNetworkItems and AdAttributionKit** identifiers in your app’s `Info.plist`.

Proper configuration ensures that your app can attribute installs and in-app conversions correctly under Apple’s privacy framework:
* [x] Ensures full attribution coverage
* [x] Unlocks optimized campaign bidding
* [x] Improves fill rate and competition
* [x] Increases eCPM
* [x] Prevents revenue loss

From a monetization standpoint, missing SKAdNetwork or AdAttributionKit identifiers directly impacts your ability to compete in privacy-safe performance campaigns.

We strongly recommend validating this configuration before every production release.

Failure to properly configure these values may result in:
* Lost attribution data
* Lower campaign performance visibility
* Reduced eCPM and monetization efficiency
* Inability to measure post-install performance

## SKAdNetwork
SKAdNetwork is Apple’s privacy-preserving attribution framework introduced in iOS 14 to replace traditional device-level attribution.

It allows ad networks to measure app installs and post-install events **without accessing user-level identifiers (IDFA)**.

[Official Apple documentation about SKAdNetwork](https://developer.apple.com/documentation/storekit/skadnetwork)

Each ad network participating in SKAdNetwork must register its unique SKAdNetwork ID.
To receive attribution postbacks, your app must include these IDs in Info.plist `SKAdNetworkItems` 

## AdAttributionKit
AdAttributionKit is Apple’s next-generation attribution framework introduced in iOS 17.4 that extends and evolves SKAdNetwork. It provides more advanced attribution capabilities and improved privacy-preserving reporting.

[Official Apple documentation about AdAttributionKit](https://developer.apple.com/documentation/adattributionkit)

AdAttributionKit identifiers must also be declared in your `Info.plist` to enable proper attribution for supported campaigns.

## Automated Integration
To simplify the integration process and eliminate manual errors, we provide a Ruby script to [CAS.AI Automatically configure project](https://github.com/cleveradssolutions/CAS-iOS/tree/master/Script%20XCodeConfig).

This script will automatically inject required `SKAdNetworkItems` and 
`AdNetworkIdentifiers` identifiers into your `Info.plist`.

## Manual Integration
An up-to-date list of SKAdNetworkItems and AdAttributionKit partners can be found in the repository.

1. Open your project in `Info.plist` as Source Code.
2. Copy the `<key>SKAdNetworkItems</key><array>...</array>` tags from the [SKAdNetworkItems.xml](https://github.com/cleveradssolutions/CAS-iOS/blob/master/AdNetworkIdentifiers/SKAdNetworkItems.xml).
3. Paste the content inside SKAdNetworkItems `<array>` tag or at the end of the file before `</dict></plist>`
4. Copy the `<key>AdNetworkIdentifiers</key><array>...</array>` tags from the [AdNetworkIdentifiers.xml](https://github.com/cleveradssolutions/CAS-iOS/blob/master/AdNetworkIdentifiers/AdNetworkIdentifiers.xml).
5. Paste the content inside AdNetworkIdentifiers `<array>` tag or at the end of the file before `</dict></plist>`

Additional `SKAdNetworkItems` and `AdNetworkIdentifiers` values may be added in the future. We recommend checking back on this page for updates.

## Best Practices
* Keep identifiers updated — Apple and ad networks may introduce new ones.
* Re-run the Ruby script when updating the SDK.
* Validate configuration before App Store submission.
* Monitor attribution performance after release.
