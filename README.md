# CleverAdsSolutions-iOS SDK Integration 

[![SDK](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-Specs/master/CAS.json)](https://github.com/cleveradssolutions/CAS-Specs/tree/master/Specs/CleverAdsSolutions-SDK)
[![Promo](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-Specs/master/CASPromo.json)](https://github.com/cleveradssolutions/CAS-Specs/tree/master/Specs/CleverAdsSolutions-Promo)
[![SKAdNetworksID](https://img.shields.io/badge/SKAdNetworksItems-Dec%2024%2C%202020-orange)](https://github.com/cleveradssolutions/CAS-iOS/blob/master/SKAdNetworkItems.xml)
[![Updated](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/App-ads.txt/master/Shield.json)](https://github.com/cleveradssolutions/App-ads.txt)

## Note
- XCode 12.2 and up
- Works on iOS 10 and above.

# Table of contents
 1.  [Add the CAS Framework to Your Xcode Project](#step-1-add-the-cas-framework-to-your-xcode-project)  
 2.  [Add Cross Promotion Framework (Optional)](#step-2-add-cross-promotion-framework)  
 3.  [Update Info plist](#step-3-update-info-plist)
 4.  [Configuring Privacy Controls (Optional)](#step-4-configuring-privacy-controls)  
 5.  [Add the CAS default settings file (Optional)](#step-5-add-the-CAS-default-settings-file)  
 6.  [Import the CAS SDK](#step-6-import-the-cas-sdk)
 7.  [Privacy Laws](#step-7-privacy-laws)  
 7.1.  [GDPR Managing Consent](#gdpr-managing-consent)  
 7.2.  [CCPA Compliance](#ccpa-compliance)  
 7.3.  [COPPA and EEA Compliance](#coppa-and-eea-compliance)  
 8.  [Configuring CAS SDK](#step-8-configuring-cas-sdk)
 9.  [Initialize the SDK](#step-9-initialize-the-sdk)  
 10.  [Implement our Ad Units](#step-10-implement-our-ad-units)  
 10.1.  [Banner Ad](#banner-ad)  
 10.2.  [Ad events](#ad-events)  
 10.3.  [Check Ad Availability](#check-ad-availability)  
 10.4.  [Show Interstitial Ad](#show-interstitial-ad)  
 10.5.  [Show Rewarded Video Ad](#show-rewarded-video-ad)  
 11.  [Mediation extras](#mediation-extras)
 12.  [GitHub issue tracker](#github-issue-tracker)
 13.  [Support](#support)  
 14.  [License](#license)

<details><summary><b>Demo application demonstrate how to integrate the CAS Mediation</b></summary>

Each iOS example app on this repository includes a Podfile and a Podfile.lock. The Podfile.lock tracks the version of each Pod specified in the Podfile that was used to build the release of the iOS example apps. 

1. Run `pod install` in the same directory as the Podfile.
2. [Optional] Run `pod update` to get the latest version of the SDK.
3. Open the `.xcworkspace` file with Xcode and run the app.

See the [CocoaPods Guides](https://guides.cocoapods.org) for more information on installing and updating pods.
***
</details>

## Step 1 Add the CAS Framework to Your Xcode Project
<details><summary><b>Simple CocoaPods</b></summary>
 
The simplest way to import the SDK into an iOS project is to use [CocoaPods](https://guides.cocoapods.org/using/getting-started). 
1. Open your project's Podfile. 
2. Add the following lines to the beginning of podfile:
```cpp
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/cleveradssolutions/CAS-Specs.git'
```
3. Add this line to your app's target:
```cpp
pod 'CleverAdsSolutions-SDK', '~> 1.9.1'
```

Main solution included following mediation networks:  
<details><summary>Google Ads, Vungle, AdColony, Kidoz, IronsSource, AppLovin, Unity Ads, StartApp, InMobi, Chartboost, SuperAwesome, Facebook AN, Yandex Ads</summary>

- Google Ads  
Banner, Interstitial, Rewarded Video - [Home](https://admob.google.com/home) - [Privacy Policy](https://policies.google.com/technologies/ads)
- Unity Ads  
Banner, Interstitial, Rewarded Video - [Home](https://unity.com/solutions/unity-ads) - [Privacy Policy](https://unity3d.com/legal/privacy-policy)
- IronSource  
~~Banner~~, Interstitial, Rewarded Video - [Home](https://www.ironsrc.com) - [Privacy Policy](https://developers.ironsrc.com/ironsource-mobile/air/ironsource-mobile-privacy-policy/)
- AdColony  
Banner, Interstitial, Rewarded Video - [Home](https://www.adcolony.com) - [Privacy Policy](https://www.adcolony.com/privacy-policy/)
- Kidoz  
Banner, Interstitial, Rewarded Video - [Home](https://kidoz.net) - [Privacy Policy](https://kidoz.net/privacy-policy/)
- Vungle  
Banner, Interstitial, Rewarded Video - [Home](https://vungle.com) - [Privacy Policy](https://vungle.com/privacy/)
- AppLovin  
Banner, Interstitial, Rewarded Video - [Home](https://www.applovin.com) - [Privacy Policy](https://www.applovin.com/privacy/)
- StartApp  
Banner, Interstitial, Rewarded Video - [Home](https://www.startapp.com) - [Privacy Policy](https://www.startapp.com/policy/privacy-policy/)
- InMobi  
Banner, Interstitial, Rewarded Video - [Home](https://www.inmobi.com) - [Privacy Policy](https://www.inmobi.com/privacy-policy/)
- Chartboost  
Banner, Interstitial, Rewarded Video - [Home](https://www.chartboost.com) - [Privacy Policy](https://answers.chartboost.com/en-us/articles/200780269)
- SuperAwesome  
Banner, Interstitial, Rewarded Video - [Home](https://www.superawesome.com) - [Privacy Policy](https://www.superawesome.com/privacy-hub/privacy-policy/)  
- Facebook Audience Network  
Banner, Interstitial, Rewarded Video  - [Home](https://www.facebook.com/business/marketing/audience-network) - [Privacy Policy](https://developers.facebook.com/docs/audience-network/policy/)
- Yandex Ads  
Banner, Interstitial, ~~Rewarded Video~~ - [Home](https://yandex.com/dev/mobile-ads/) - [Privacy Policy](https://yandex.com/legal/mobileads_sdk_agreement/)  
</details>

> Some third party partners are not included in the main dependency: MyTarget, MobFox, AmazonAd.  Combine main dependency with partners dependencies from Advanced CocoaPods integration.
4. Then from the command line run:
```
pod install --repo-update
```
If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Podfiles
***
</details>
<details><summary><b>Advanced CocoaPods</b></summary>

We support partial integration of the third party mediation sdk you really need.  
To do this, use any combination of partial dependencies.  
**Please provide us with a list of integrated dependencies so that we can make the correct settings.**  

<details><summary>Google Ads</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://admob.google.com/home) - [Privacy Policy](https://policies.google.com/technologies/ads)
```cpp
pod 'CleverAdsSolutions-SDK/GoogleAds'
```
</details><details><summary>Unity Ads</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://unity.com/solutions/unity-ads) - [Privacy Policy](https://unity3d.com/legal/privacy-policy)
```cpp
pod 'CleverAdsSolutions-SDK/UnityAds'
```
</details><details><summary>IronSource</summary>
 
~~Banner~~, Interstitial, Rewarded Video - [Home](https://www.ironsrc.com) - [Privacy Policy](https://developers.ironsrc.com/ironsource-mobile/air/ironsource-mobile-privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/IronSource'
```
</details><details><summary>AdColony</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://www.adcolony.com) - [Privacy Policy](https://www.adcolony.com/privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/AdColony'
```
</details><details><summary>Vungle</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://vungle.com) - [Privacy Policy](https://vungle.com/privacy/)
```cpp
pod 'CleverAdsSolutions-SDK/Vungle'
```
</details><details><summary>AppLovin</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://www.applovin.com) - [Privacy Policy](https://www.applovin.com/privacy/)
```cpp
pod 'CleverAdsSolutions-SDK/AppLovin'
```
</details><details><summary>InMobi</summary>
 
Banner, Interstitial, Rewarded Video - [Home](https://www.inmobi.com) - [Privacy Policy](https://www.inmobi.com/privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/InMobi'
```
</details><details><summary>Facebook Audience Network</summary>

Banner, Interstitial, Rewarded Video - [Home](https://www.facebook.com/business/marketing/audience-network) - [Privacy Policy](https://developers.facebook.com/docs/audience-network/policy/)
```cpp
pod 'CleverAdsSolutions-SDK/FBAudienceNetwork'
```
</details><details><summary>Yandex Ads</summary>

Banner, Interstitial, ~~Rewarded Video~~ - [Home](https://yandex.com/dev/mobile-ads/) - [Privacy Policy](https://yandex.com/legal/mobileads_sdk_agreement/) 
```cpp
pod 'CleverAdsSolutions-SDK/YandexAds'
```
</details><details><summary>Kidoz</summary>

Banner, Interstitial, Rewarded Video - [Home](https://kidoz.net) - [Privacy Policy](https://kidoz.net/privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/Kidoz'
```
</details><details><summary>SuperAwesome</summary>

Banner, Interstitial, Rewarded Video - [Home](https://www.superawesome.com) - [Privacy Policy](https://www.superawesome.com/privacy-hub/privacy-policy/)   
> Works only for children audience
```cpp
pod 'CleverAdsSolutions-SDK/SuperAwesome'
```
</details><details><summary>Chartboost</summary>

Banner, Interstitial, Rewarded Video - [Home](https://www.chartboost.com) - [Privacy Policy](https://answers.chartboost.com/en-us/articles/200780269)
```cpp
pod 'CleverAdsSolutions-SDK/Chartboost'
```
</details><details><summary>StartApp</summary>

Banner, Interstitial, Rewarded Video - [Home](https://www.startapp.com) - [Privacy Policy](https://www.startapp.com/policy/privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/StartApp'
```
</details>

Dependencies of Closed Beta third party partners:
> :warning:  Next dependencies in closed beta and available upon invite only. If you would like to be considered for the beta, please contact Support.

<details><summary>Verizon Media</summary>

Banner, Interstitial, Rewarded Video - [Home](https://www.verizonmedia.com/advertising/solutions#/mobile)- [Privacy Policy](https://www.verizonmedia.com/policies/us/en/verizonmedia/privacy/)
```cpp
pod 'CleverAdsSolutions-SDK/Verizon'
```
</details><details><summary>MyTarget</summary>

Banner, Interstitial, Rewarded Video - [Home](https://target.my.com/) - [Privacy Policy](https://legal.my.com/us/mytarget/privacy/)   
> Works to CIS countries only
```cpp
pod 'CleverAdsSolutions-SDK/MyTarget'
```
</details><details><summary>MobFox</summary>

Banner, Interstitial, ~~Rewarded Video~~ - [Home](https://www.mobfox.com) - [Privacy Policy](https://www.mobfox.com/privacy-policy/)
```cpp
pod 'CleverAdsSolutions-SDK/MobFox'
```
</details><details><summary>Amazon Ads</summary>

Banner, ~~Interstitial, Rewarded Video~~ - [Home](https://advertising.amazon.com) - [Privacy Policy](https://advertising.amazon.com/legal/privacy-notice)
```cpp
pod 'CleverAdsSolutions-SDK/AmazonAd'
```
</details>

> The list of third party partners may change in the future.
***
</details>
<details><summary><b>Manual Download</b></summary>

Follow these steps to add the CAS SDK to your project:
1. Download latest version of [CleverAdsSolutions.zip](https://github.com/cleveradssolutions/CAS-iOS/releases/latest).
2. Unzip it into your Xcode Project
3. Add `CleverAdsSolutions.framework` to dependencies
4. Set `Swift Compiler - Search paths` to the CASMediation folder in Build Settings.
5. Add any supported third party mediation sdk.
6. Remove unused scripts from the CASMediation folder of third party mediation that are not integrated.
***
</details>

## Step 2 Add Cross Promotion Framework
**Optional step.**  
Cross promotion is an app marketing strategy in which app developers promote one of their titles on another one of their titles. Cross promoting is especially effective for developers with large portfolios of games as a means to move users across titles and use the opportunity to scale each of their apps. This is most commonly used by hyper-casual publishers who have relatively low retention, and use cross promotion to keep users within their app portfolio.

Start your cross promotion campaign with CAS [here](https://cleveradssolutions.com).

<details><summary><b>CocoaPods</b></summary>

Open your project's Podfile and add this line to your app's target:
```cpp
pod 'CleverAdsSolutions-Promo', '~> 1.9.1'
```
Then from the command line run:
```
pod install --repo-update
```
***
</details>

## Step 3 Update Info plist
<details><summary>Configuring App Transport Security</summary>

With the release of iOS 9 Apple introduced ATS, which requires apps to make secure network connections via SSL and enforces HTTPS connections through its requirements on the SSL version, encryption cipher, and key length. At this time, CAS highly recommends **disabling ATS** in your application. Please note that, while CAS fully supports HTTPS, some of our advertisers and 3rd party ad tracking providers do not. Therefore enabling ATS may result in a reduction in fill rate.  

In order to prevent your ads (and your revenue) from being impacted by ATS, please disable it by adding the following to your info.plist:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsForMedia</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```
The `NSAllowsArbitraryLoads` exception is required to make sure your ads are not impacted by ATS on iOS 9 devices, while `NSAllowsArbitraryLoadsForMedia` and `NSAllowsArbitraryLoadsInWebContent` are required to make sure your ads are not impacted by ATS on iOS 10 and later devices.
***
</details>
<details><summary>Configuring SK Ad Networks</summary>

#### What is SKAdnetwork?
SKAdnetwork is a privacy safe method provided by Apple for ad networks to track installs. Up until iOS 14, most ad network campaign attribution has been based on a user's IDFA, but on iOS 14 and beyond, IDFAs will be less usable as a way to attribute which users have installed based on which ads they have interacted with.
#### Why should I implement SKAdnetwork?
Going forward, fewer campaigns can rely on the IDFA to track ad campaign performance. Supporting SKAdnetwork will increase the number of eligible campaigns that may serve on your app which will increase demand and therefore eCPMs
#### How do I implement SKAdnetwork?
To use SKAdnetwork, app developers must define which networks have permission to show ads within their app. Please add the SKAdNetworkIdentifiers listed below to your app's plist file as described [here](https://developer.apple.com/documentation/storekit/skadnetwork/configuring_the_participating_apps).

To enable this functionality, you will need to update the SKAdNetworkItems key with an additional dictionary in your Info.plist.  
[View the latest list in XML format](SKAdNetworkItems.xml)
***
</details>
<details><summary>Add Google Ads App ID</summary>

Follow the [link](http://psvpromo.psvgamestudio.com/cas-settings.php) to get your Admob App ID.  

Add your AdMob App ID to your app's `Info.plist` file by adding a `GADApplicationIdentifier` key:
```xml
<!-- Sample AdMob App ID: ca-app-pub-3940256099942544~1458002511 -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

To delay app measurement, add the `GADDelayAppMeasurementInit` key with a boolean value of `YES` to your app’s `Info.plist`:
```xml
<key>GADDelayAppMeasurementInit</key>
<true/>
```

**Note:** If you haven't created an CAS account and registered an app yet, now's a great time to do so. In a real app, it is important that you use your actual AdMob app ID, not the one listed above. If you're just looking to experiment with the SDK in a Hello World app, though, you can use the sample App ID shown above.  
***
</details>
<details><summary>Configuring URL Schemes</summary>

With the release of iOS 9, Apple also restricted usage of the canOpenURL: API, which CAS mediation networks uses to make decisions about whether or not we can land users in certain apps from our Dynamic End Cards (DECs).  
 
For example, one of our ad units could be for a new movie, and the associated DEC may present functionality to the user that allows them to send a tweet about it using the Twitter app.  
Note that if the schemes are not added, users will be taken to the app’s website instead, which may result in an undesirable user experience - having to login to the site, for example.  
In order to enable deep-linking for the apps the CAS uses, please add the following entry to your app's plist:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fb</string>
    <string>instagram</string>
    <string>tumblr</string>
    <string>twitter</string>
</array>
```
***
</details>

## Step 4 Configuring Privacy Controls
<details><summary><b>Request App Tracking Transparency authorization</b></summary>

iOS 14 and above requires publishers to obtain permission to track the user's device across applications.  
To display the App Tracking Transparency authorization request for accessing the IDFA, update your Info.plist to add the NSUserTrackingUsageDescription key with a custom message describing your usage. Below is an example description text:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
Some examples include:
- Your data will be used to provide you a better and personalized ad experience.
- We try to show ads for apps and products that will be most interesting to you based on the apps you use.
- We try to show ads for apps and products that will be most interesting to you based on the apps you use, the device you are on, and the country you are in.  

To present the authorization request, call `requestTrackingAuthorizationWithCompletionHandler:`. We recommend waiting for the completion callback prior to [initialzie ads](#step-10-initialize-the-sdk), so that if the user grants the App Tracking Transparency permission, the CAS mediation can use the IDFA in ad requests.
```swift
import AppTrackingTransparency
import AdSupport
...
func requestIDFA() {
  ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
    // Tracking authorization completed. Start initialize CAS here.
    CAS.create(...)
  })
}
```

For more information, see [Apple's developer documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription) or [Google Ads documentation](https://developers.google.com/admob/ios/ios14#request).

> Regarding guideline 2.1.0, If your app does not include AppTrackingTransparency functionality, please indicate this information in the Review Notes section for each version of your app in App Store Connect when submitting for review.  

> **Important:** CAS does not provide legal advice. Therefore, the information on this page is not a substitute for seeking your own legal counsel to determine the legal requirements of your business and processes, and how to address them.  
***
</details>
<details><summary><b>Wireless Accessory Configuration (Optional)</b></summary>
 
Apple has introduced privacy settings to access WiFi details from iOS 12 onwards. To boost monetization and relevant user experience, we encourage sharing WiFi details for targeted advertising.
1. Log into you Apple developer account at https://developer.apple.com, and enable Wireless Accessory Configuration for the App ID
2. Go to `Project Settings > Select Your App Target > Signing & Capabilities` tab. 
3. Add capabilities bt clicking the "+" button and select Wireless Accessory Configuration.
***
</details>
<details><summary><b>Optional permissions</b></summary>
 
In iOS 10, Apple has extended the scope of its privacy controls by restricting access to features like the camera, photo library, etc. In order to unlock rich, immersive experiences in the SDK that take advantage of these services, please add the following entry to your apps plist:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Some ad content may require access to the photo library.</string>
<key>NSCameraUsageDescription</key>
<string>Some ad content may access camera to take picture.</string>
<key>NSMotionUsageDescription</key>
<string>Some ad content may require access to accelerometer for interactive ad experience.</string>
```
***
</details>

## Step 5 Add the CAS default settings file
**Optional step.**  
Follow the [link](http://psvpromo.psvgamestudio.com/cas-settings.php) to download a `cas_settings.json` file.

Drop the `cas_settings.json` to your project and link the settings file to `Build Phases > Copy Bundle Resources`. However, only the **main bundle** resources is supported.  

## Step 6 Import the CAS SDK
<details><summary>Swift</summary>
 
```swift
import CleverAdsSolutions
```

The `CAS` class gives access to all the possibilities of the SDK.
Singleton instance of `CASSettings` to configure all mediation managers.
```swift
let sdkSettings = CAS.settings
```
Singleton instance of `CASTargetingOptions` to inform SDK of the users details.
```swift
let targetingOptions = CAS.targetingOptions
```
Last initialized instance of `CASMediationManager` stored with strong pointer. May be **nil** before calling the `CAS.create` function.
```swift
let lastManager = CAS.manager
```
The CAS SDK version string
```swift
let sdkVersion = CAS.getSDKVersion()
```
***
</details>
<details><summary>Objective-C</summary>

```objc
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>
```

The `CAS` class gives access to all the possibilities of the SDK.
Singleton instance of `CASSettings` to configure all mediation managers.
```swift
CASSettings *sdkSettings = [CAS settings]
```
Singleton instance of `CASTargetingOptions` to inform SDK of the users details.
```swift
CASTargetingOptions *targetingOptions = [CAS targetingOptions]
```
Last initialized instance of `CASMediationManager` stored with strong pointer. May be **nil** before calling the `[CAS create]` function.
```swift
CASMediationManager *lastManager = [CAS manager]
```
The CAS SDK version string
```swift
NSString *sdkVersion = [CAS getSDKVersion]
```
***
</details>
<details><summary><b>Verify Your Integration (Optional)</b></summary>

The CAS SDK provides an easy way to verify that you’ve successfully integrated any additional adapters; it also makes sure all required dependencies and frameworks were added for the various mediated ad networks.  
After you have finished your integration, call the following static method and confirm that all networks you have implemented are marked as VERIFIED:
```swift
CAS.validateIntegration()
```

Find log information by tag: **CASIntegrationHelper**  

Once you’ve successfully verified your integration, please remember to **remove the integration helper from your code**.  

The Integration Helper tool reviews everything, including ad networks you may have intentionally chosen NOT to include in your application. These will appear as MISSING and there is no reason for concern. In the case the ad network’s integration has not been completed successfully, it will be marked as NOT VERIFIED.
***
</details>
<details><summary><b>Don’t forget to implement app-ads.txt (Optional)</b></summary>

For both iOS and Android integrations, we encourage our partners to adopt this file and help us combat ad fraud.  
Read detailed instructions on [how to create and upload your app-ads.txt file](https://github.com/cleveradssolutions/App-ads.txt#cleveradssolutions-app-adstxt).
</details>

## Step 7 Privacy Laws
This documentation is provided for compliance with various privacy laws. If you are collecting consent from your users, you can make use of APIs discussed below to inform CAS and all downstream consumers of this information.  

A detailed article on the use of user data can be found in the [Privacy Policy](https://github.com/cleveradssolutions/CAS-Android/wiki/Privacy-Policy).

### GDPR Managing Consent
This documentation is provided for compliance with the European Union's [General Data Protection Regulation (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). In order to pass GDPR consent from your users, you should make use of the APIs and methods discussed below to inform CAS and all downstream consumers of this information.  

<details><summary><b>Passing Consent to use personal information (Swift)</b></summary>
   
User consents to behavioral targeting in compliance with GDPR.
```swift
CAS.settings.updateUser(consent: .accepted)
```
User does not consent to behavioral targeting in compliance with GDPR.
```swift
CAS.settings.updateUser(consent: .denied)
```
By default, user consent management is passed on to media networks. For reset state:
```swift
CAS.settings.updateUser(consent: .undefined)
```
***
</details>
<details><summary><b>Passing Consent to use personal information (Objective-C)</b></summary>
 
User consents to behavioral targeting in compliance with GDPR.
```objc
[CAS.settings updateUserWithConsent: CASConsentStatusAccepted];
```
User does not consent to behavioral targeting in compliance with GDPR.
```objc
[CAS.settings updateUserWithConsent: CASConsentStatusDenied];
```
By default, user consent management is passed on to media networks. For reset state:
```objc
[CAS.settings updateUserWithConsent: CASConsentStatusUndefined];
```
***
</details>
 
### CCPA Compliance
This documentation is provided for compliance with the California Consumer Privacy Act (CCPA). In order to pass CCPA opt-outs from your users, you should make use of the APIs discussed below to inform CAS and all downstream consumers of this information.  

<details><summary><b>Passing consent to the sale personal information (Swift)</b></summary>
 
User does not consent to the sale of his or her personal information in compliance with CCPA.
```swift
CAS.settings.updateCCPA(status: .optOutSale)
```
User consents to the sale of his or her personal information in compliance with CCPA.
```swift
CAS.settings.updateCCPA(status: .optInSale)
```
By default, user consent management is passed on to media networks. For reset state:
```swift
CAS.settings.updateCCPA(status: .undefined)
```
***
</details>
<details><summary><b>Passing consent to the sale personal information (Objective-C)</b></summary>
 
User does not consent to the sale of his or her personal information in compliance with CCPA.
```objc
[CAS.settings updateCCPAWithStatus: CASCCPAStatusOptOutSale];
```
User consents to the sale of his or her personal information in compliance with CCPA.
```objc
[CAS.settings updateCCPAWithStatus: CASCCPAStatusOptInSale];
```
By default, user consent management is passed on to media networks. For reset state:
```objc
[CAS.settings updateCCPAWithStatus: CASCCPAStatusUndefined];
```
***
</details>
 
###  COPPA and EEA Compliance
This documentation is provided for additional compliance with the [Children’s Online Privacy Protection Act (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy). Publishers may designate all inventory within their applications as being child-directed or as COPPA-applicable though our UI. Publishers who have knowledge of specific individuals as being COPPA-applicable should make use of the API discussed below to inform CAS and all downstream consumers of this information.  

You can mark your ad requests to receive treatment for users in the European Economic Area (EEA) under the age of consent. This feature is designed to help facilitate compliance with the General Data Protection Regulation (GDPR). Note that you may have other legal obligations under GDPR. Please review the European Union’s guidance and consult with your own legal counsel. Please remember that CAS tools are designed to facilitate compliance and do not relieve any particular publisher of its obligations under the law.

<details><summary><b>Define application audience (Swift)</b></summary>
 
Call `CASAudience.children` indicate that user want get content treated as child-directed for purposes of COPPA or receive treatment for users in the European Economic Area (EEA) under the age of consent. 
```swift
CAS.settings.setTagged(audience: .children)
```
Call `CASAudience.notChildren` to indicate that user **don't** want get content treated as child-directed for purposes of COPPA or **not** receive treatment for users in the European Economic Area (EEA) under the age of consent.
```swift
CAS.settings.setTagged(audience: .notChildren)
```
By default, the audience is unknown and the mediation ad network will work as usual. For reset state:
```swift
CAS.settings.setTagged(audience: .undefined)
```
***
</details>
<details><summary><b>Define application audience (Objective-C)</b></summary>
 
Call `CASAudienceChildren` indicate that user want get content treated as child-directed for purposes of COPPA or receive treatment for users in the European Economic Area (EEA) under the age of consent. 
```objc
[CAS.settings setTaggedWithAudience: CASAudienceChildren];
```
Call `CASAudienceNotChildren` to indicate that user **don't** want get content treated as child-directed for purposes of COPPA or **not** receive treatment for users in the European Economic Area (EEA) under the age of consent.
```objc
[CAS.settings setTaggedWithAudience: CASAudienceNotChildren];
```
By default, the audience is unknown and the mediation ad network will work as usual. For reset state:
```objc
[CAS.settings setTaggedWithAudience: CASAudienceUndefined];
```
***
</details>

**We recommend to set Privacy API before initializing CAS SDK.**

## Step 8 Configuring CAS SDK
<details><summary><b>Track Location</b></summary>

The SDK automatically collects location data if the user allowed the app to track the location.  
Enables or disables collecting location data.  
Disabled by default.
```swift
CAS.settings.setTrackLocation(enabled:true)
```
***
</details>
<details><summary><b>Debug mode</b></summary>

The enabled Debug Mode will display a lot of useful information for debugging about the states of the sdk with tag CAS.   
Disabling Debug Mode may improve application performance.  
Disabled by default.  

```swift
CAS.settings.setDebugMode(true)
```
***
</details>
<details><summary><b>Test Device IDs</b></summary>

Identifiers corresponding to test devices which will always request test ads.  
The test device identifier for the current device is logged to the console when the first ad request is made.

```swift
CAS.settings.setTestDevice(["test-device-id"])
```
***
</details>
<details><summary><b>Muted Ad sounds</b></summary>

Indicates if the application’s audio is muted. Affects initial mute state for all ads.  
Use this method only if your application has its own volume controls.
```swift
CAS.settings.setMuteAdSounds(to: false)
```
***
</details>
<details><summary><b>Waterfall Loading Mode</b></summary>

|        Mode        |  Load<sup>[*1](#load-f-1)</sup>  | Impact on App performance | Memory usage |        Actual ads<sup>[*2](#actual-f-2)</sup>       |
|:------------------:|:------:|:-------------------------:|:------------:|:------------------------:|
|   fastestRequests  |  Auto  |         Very high         |     High     |       Most relevant      |
|    fastRequests    |  Auto  |            High           |    Balance   |      High relevance      |
|  optimal *(Default)*  |  Auto  |          Balance          |    Balance   |          Balance         |
|   highPerformance  |  Auto  |            Low            |      Low     |       Possible loss      |
| highestPerformance |  Auto  |          Very low         |      Low     |       Possible loss      |
|       manual      | Manual<sup>[*3](#manual-f-3)</sup> |          Very low         |      Low     | Depends on the frequency |

```swift
CAS.settings.setLoading(mode: CASLoadingManagerMode.optimal)
```

<b id="load-f-1">^1</b>: Auto control load mediation ads starts immediately after initialization and will prepare displays automatically.  

<b id="actual-f-2">^2</b>: Potential increase in revenue by increasing the frequency of ad requests. At the same time, it greatly affects the performance of the application.  

<b id="manual-f-3">^3</b>: Manual control loading mediation ads requires manual preparation of advertising content for display. Use ad loading methods before trying to show: `CASMediationManager.loadInterstitial(), CASMediationManager.loadRewardedVideo(), CASBannerView.loadNextAd()`.  
***
</details>
<details><summary><b>Analytics collection</b></summary>

Sets CAS analytics collection is enabled for this app on this device.    
By default it is disabled. This setting is persisted across app sessions. 
```swift
CAS.settings.setAnalyticsCollection(enabled: true)
```

<details><summary>Implement a analytics event handler (Swift)</summary>

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, CASAnalyticsHandler {
/* Class body ... */

    var window: UIWindow?
    var manager: CASMediationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set weak reference to analytics handler
        CASAnalytics.handler = self
        CAS.settings.setAnalyticsCollection(enabled: true)
    
        // TODO: Initialize CAS manager
        return true
    }
    
    override func log(_ eventName: String, _ map: [String: Any]){
      // For example Firebase Analytics implementation
      Analytics.logEvent(eventName, parameters: map)
    }
}
```
</details>
<details><summary>Implement a analytics event handler (Objective-C)</summary>

```objc
@interface AppDelegate : UIResponder <UIApplicationDelegate, CASAnalyticsHandler>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CASMediationManager *manager;
@end

@implementation AppDelegate
/* Class body ... */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set weak reference to analytics handler
    [CASAnalytics setHandler:self];
    [[CAS settings] setAnalyticsCollectionWithEnabled:YES];
    
    // TODO: Initialize CAS manager
    return YES;
}
@end

- (void)log:(NSString *)eventName:(NSDictionary<NSString *, id> *)map {
    // For example Firebase Analytics implementation
    [FIRAnalytics logEventWithName:eventName parameters:map];
}
```
</details>

***
</details>
<details><summary><b>Targeting Options</b></summary>
 
You can now easily tailor the way you serve your ads to fit a specific audience!  
You’ll need to inform our servers of the users’ details so the SDK will know to serve ads according to the segment the user belongs to.
```swift
// Set user age. Limitation: 1-99 and 0 is 'unknown'
CAS.targetingOptions.setAge(12)
// Set user gender
CAS.targetingOptions.setGender(CASTargetingOptions.Gender.male)
// The user's current location.
// Location data is not used to CAS; however, it may be used by 3rd party ad networks.
// Do not use Location just for advertising.
// Your app should have a valid use case for it as well.
CAS.targetingOptions.setLocation(latitude: userLatitude, longitude: userLongitude)
```
***
</details>

## Step 9 Initialize the SDK
<details><summary><b>Initialize Mediation Manager instance (Swift)</b></summary>
  
> :warning: Some third party CAS networks require a `window: UIWindow?` property in the **AppDelegate**, even when **SceneDelegate** is used. Missing the property will cause Fatal Error.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
/* Class body ... */

    var window: UIWindow?
    var manager: CASMediationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure CAS.settings before initialize
        // Configure CAS.targetingOptions before initialize
        manager = CAS.create(
          managerID: ownIdentifier,
          enableTypes: CASTypeFlags.everything, 
          demoAdMode: isTestBuild, 
          onInit: { success, error in  
              // CAS manager initialization done  
          }  
        )  
        return true
    }
}
```
- An `managerID` is a unique ID number assigned to each of your ad placements when they're created in CAS.  
The manager ID is added to your app's code and used to identify ad requests.  
If you haven't created an CAS account and registered an app yet, now's a great time to do so.  
In a real app, it is important that you use your actual CAS manager ID.  

- An `enableTypes` is option to increase application performance by initializing only those ad types that will be used.  
For example: `[CASTypeFlags.banner, CASTypeFlags.interstitial]`.  
Ad types processing can be enabled manually after initialize with use `manager.setEnabled`.  

- An `demoAdMode` is optional to enable Test ad mode that will always request test ads.  
If you're just looking to experiment with the SDK in a Hello World app, though, you can use the `demoAdMode = true` and any manager ID string.  

- `onInit` is optional subscribe to initialization finish.    

`CAS.create` can be called for different identifiers to create different managers. 
***
</details>
<details><summary><b>Initialize Mediation Manager instance (Objective-C)</b></summary>
 
> :warning: Some third party CAS networks require a `UIWindow *window` property in the **AppDelegate**, even when **SceneDelegate** is used. Missing the property will cause Fatal Error.

```objc
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CASMediationManager *manager;
@end

@implementation AppDelegate
/* Class body ... */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure [CAS settings] before initialize
    // Configure [CAS targetingOptions] before initialize
    self.manager =
        [CAS createWithManagerID:own_identifier
                     enableTypes:CASTypeInt.everything
                      demoAdMode:YES
                          onInit:^(BOOL complete, NSString *_Nullable error) {
             // CAS manager initialization done  
         }];
    return YES;
}
@end
```
- An `managerID` is a unique ID number assigned to each of your ad placements when they're created in CAS.  
The manager ID is added to your app's code and used to identify ad requests.  
If you haven't created an CAS account and registered an app yet, now's a great time to do so.  
In a real app, it is important that you use your actual CAS manager ID.  

- An `enableTypes` is option to increase application performance by initializing only those ad types that will be used.  
For example: `CASTypeInt.banner | CASTypeInt.interstitial`.  
Ad types processing can be enabled manually after initialize with use `[manager setEnabledWithType:]`.  

- An `demoAdMode` is optional to enable Test ad mode that will always request test ads.  
If you're just looking to experiment with the SDK in a Hello World app, though, you can use the `demoAdMode:YES` and any manager ID string.  

- `onInit` is optional subscribe to initialization finish.    

`[CAS createWithManagerID:]` can be called for different identifiers to create different managers. 
***
</details>
<details><summary><b>Subscribe listener to Ad Loading response (Swift)</b></summary>
 
```swift
class AdLoadDelegate: CASLoadDelegate{
    init(manager:CASMediationManager){
        manager.adLoadDelegate = self // Weak reference
    }
    func onAdLoaded(_ adType: CASType){
        // Callback on AdType loaded and ready to shown.
    }
    func onAdFailedToLoad(_ adType: CASType, withError error: String?){
        // Callback on AdType failed to load and cant be shown.
    }
}
```
***
</details>
<details><summary><b>Subscribe listener to Ad Loading response (Objective-C)</b></summary>
 
```objc
@interface ViewController : UIViewController<CASLoadDelegate>
@end

@implementation ViewController
- (void)onAdLoaded:(enum CASType)adType {
    // Callback on AdType loaded and ready to shown.
}
- (void)onAdFailedToLoad:(enum CASType) adType withError:(NSString *)error {
    // Callback on AdType failed to load and cant be shown.
}
@end
```
***
</details>
<details><summary><b>Last page Ad</b></summary>

The latest free ad page for your own promotion.  
This ad page will be displayed when there is no paid ad to show or internet availability.  
**Attention!** Impressions and clicks of this ad page will not be billed.  
By default, this page will not be displayed while the ad content is NIL.  
The Last Page Ad Content will be shown as a Banner and Interstitial ads.

<details><summary>Swift</summary>

```swift
manager.lastPageAdContent = CASLastPageAdContent(
    headline: headline,  // The message that you want users to see.
    adText: adText,      // A description for the app being promoted.
    destinationURL: URL, // The URL that CAS will direct users to when they click the ad.
    imageURL: imageURL,  // The direct URL of the image to be used as the ad file.
    iconURL: iconURL     // The direct URL of the icon or logo (Small square picture).
)
```
</details><details><summary>Objective-C</summary>

```objc
self.manager.lastPageAdContent =
  [[CASLastPageAdContent alloc]
   initWithHeadline:title // The message that you want users to see.
             adText:txt   // A description for the app being promoted.
     destinationURL:url   // The URL that CAS will direct users to when they click the ad.
           imageURL:img   // The direct URL of the image to be used as the ad file.
            iconURL:icon  // The direct URL of the icon or logo (Small square picture).
  ];
```
</details>

> `CASLastPageAdContent.destinationURL` is not visible in the ad and should always have a non-empty URL.
***
</details>

## Step 11 Implement our Ad Units
### Banner Ad
Banner ads are displayed in `CASBannerView` objects from module `CleverAdsSolutions`, so the first step toward integrating banner ads is to include a `CASBannerView` in your view hierarchy. This is typically done either with the **Interface Builder** or **programmatically**.

<details><summary><b>Interface Builder</b></summary>

A `CASBannerView` can be added to a storyboard or xib file like any typical view. When using this method, be sure to add width and height constraints to match the ad size you'd like to display. For example, when displaying a banner (320x50), use a width constraint of 320 points, and a height constraint of 50 points.
***
</details>
<details><summary><b>Programmatically (Swift)</b></summary>
 
A `CASBannerView` can be instantiated directly. Here's an example of how to create a `CASBannerView`, aligned to the bottom center of the safe area of the screen, with a banner size of 320x50:
```swift
class ViewController: UIViewController, CASCallback {
/* Class body ... */
    override func viewDidLoad() {
        super.viewDidLoad()
        // In this case, we instantiate the banner with desired ad size.
        manager.setBanner(size: CASSize.banner)
        bannerView = CASBannerView(manager: manager)      
        bannerView.setTranslatesAutoresizingMaskIntoConstraints = false
        
        // Optional set delegate of Banner Ad state changes
        bannerView.delegate = self           // Weak reference
        
        // This view controller is used to present an overlay when the ad is clicked. 
        // It should normally be set to the view controller that contains the GADBannerView.
        bannerView.rootViewController = self // Weak reference
        
        // Add BannerView To View
        view.addSubview(bannerView)
        view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bottomLayoutGuide,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
        
        
    }
}
```
***
</details>
<details><summary><b>Programmatically (Objective-C)</b></summary>
 
A `CASBannerView` can be instantiated directly. Here's an example of how to create a `CASBannerView`, aligned to the bottom center of the safe area of the screen, with a banner size of 320x50:
```objc
@implementation ViewController
/* Class body ... */
- (void)viewDidLoad {
    [super viewDidLoad];
        // In this case, we instantiate the banner with desired ad size.
        [manager setBannerSize: CASSize.banner];
        self.bannerView = [[CASBannerView alloc] initWithManager:manager];        
        [self.bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Optional set delegate of Banner Ad state changes
        [self.bannerView setDelegate:self]; // Weak reference
        
        // This view controller is used to present an overlay when the ad is clicked. 
        // It should normally be set to the view controller that contains the GADBannerView.
        [self.bannerView setRootViewController:self]; // Weak reference

        // Add BannerView To View
        [self.view addSubview:self.bannerView];
        [NSLayoutConstraint activateConstraints:@[
           [NSLayoutConstraint constraintWithItem:self.bannerTest
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1
                                         constant:0],
           [NSLayoutConstraint constraintWithItem:self.bannerTest
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1
                                         constant:0]
      ]];
    }
}
```
***
</details>
<details><summary><b>Load an Banner Ad</b></summary>
 
Manual load manager mode require call `loadNextAd` after create `CASBannerView` or change banner size.  
And you can use `loadNextAd` for cancel current impression to load next ad for any load manager mode.
```swift
bannerView.loadNextAd()
```
***
</details>
<details><summary><b>Ad Size</b></summary>
 
| Size in dp (WxH) |      Description     |    Availability    |  CASSize constant |
|:----------------:|:--------------------:|:------------------:|:----------------:|
|      320x50      |    Standard Banner   | Phones and Tablets |      banner      |
|      728x90      |    IAB Leaderboard   |       Tablets      |    leaderboard   |
|      300x250     | IAB Medium Rectangle | Phones and Tablets | mediumRectangle |

We recommended set banner size once immediately after `CAS.create()`.
```swift
manager.setBanner(size: size)
// OR same
bannerView.adSize = size
```

#### Adaptive Banners
Adaptive banners are the next generation of responsive ads, maximizing performance by optimizing ad size for each device.  
To pick the best ad size, adaptive banners use fixed aspect ratios instead of fixed heights. This results in banner ads that occupy a more consistent portion of the screen across devices and provide opportunities for improved performance. [You can read more in this article.](https://developers.google.com/admob/android/banner/adaptive)

Use the appropriate static methods on the ad size class, such as AdSize.getAdaptiveBanner to get an adaptive AdSize object.
```swift
// Get adaptive size in container view group:
adaptiveSize = CASSize.getAdaptiveBanner(inContainer: containerView)
// Get adaptive size in full screen width:
adaptiveSize = CASSize.getAdaptiveBanner(inWindow: containerWindow)
// Get adaptive size with width parameter:
adaptiveSize = AdSize.getAdaptiveBanner(forMaxWidth: maxWidth)
```

#### Smart Banners
Typically, Smart Banners on phones have a `banner` size. Or on tablets a `leaderboard` size.

Use the static method in the CASSize class to get the smart CASSize object.
```swift
smartSize = CASSize.getSmartBanner()
```
***
</details>
<details><summary><b>Banner refresh rate</b></summary>
 
An ad unit’s automatic refresh rate determines how often a new ad request is generated for that ad unit.  
We recommend using 30 seconds (Default) refresh rate.  
You may also set a custom refresh rate of 5-360 seconds.  
This setting is available for change through the web application settings.   

You can specify refresh rate **before** initialization to allow overrides settings by the web interface for a given session.
```swift
CAS.settings.setBannerRefresh(interval: interval)
manager = CAS.create(...)
```
Or **after** initialization to override the web application settings for a given session.
```swift
manager = CAS.create(..., onInit: { success, error in  
        // CAS manager initialization done  
        CAS.settings.setBannerRefresh(interval: interval)
} )
```
***
</details>

### Ad events
Through the use of CASCallback, you can listen for lifecycle events, such as when an ad is closed or the user leaves the app.  

<details>
 
To register for ad events, set the `delegate` property on CASBannerView to an object for banner or set argument on show ad, that implements the CASCallback protocol. Generally, the class that implements banner ads also acts as the delegate class, in which case, the `delegate` property can be set to `self`.  

Each of the methods in CASCallback is marked as optional, so you only need to implement the methods you want. This example implements each method and logs a message to the console:
```swift
/// Executed when the ad is displayed.
/// - Parameter ad: Information of displayed ad
optional func willShown(ad adStatus: CASStatusHandler)

/// Executed when the ad is failed to display.
/// The Banner may automatically appear when the Ad is ready again.
/// This will trigger the [willShown] callback again.
/// - Parameter  message: Error message
optional func didShowAdFailed(error: String)

/// Executed when the user clicks on an Ad.
optional func didClickedAd()

/// Executed when the Ad is completed.
/// Banner Ad does not use this callback.
optional func didCompletedAd()

/// Executed when the ad is closed.
/// The Banner Ad cannot be displayed automatically after this callback for the current view.
/// If you decide to show the Banner Ad on this view then you need refresh view visibility.
optional func didClosedAd()
```
***
</details>

### Check Ad Availability
You can ask for the ad availability directly by calling the following function:
<details><summary>Swift</summary>
 
```swift
manager.isAdReady(type: CASType.interstitial) //Check ready any CASType
```
***
</details>
<details><summary>Objective-C</summary>
 
 ```objc
[self.manager isAdReadyWithType:CASTypeInterstitial]; //Check ready any CASType
```
***
</details>

### Show Interstitial Ad
<details><summary>Swift</summary>
 
**Manual load manager mode** require call `loadInterstitial` before try show ad.  
You will also need to load new ad after the ad closed.  
```swift
manager.loadInterstitial()
```

Invoke the following method to serve an selected ad to your users:
```swift
manager.show(
    fromRootViewController: self,
    type: CASType.interstitial, 
    // Optional. CASCallback implementation. Weak reference
    callback: delegate
  )
```
***
</details>
<details><summary>Objective-C</summary>

**Manual load manager mode** require call `loadInterstitial` before try show ad.  
You will also need to load new ad after the ad closed.  
```objc
[self.manager loadInterstitial]
```

Invoke the following method to serve an selected ad to your users:
```swift
[self.manager showFromRootViewController:self,
                                    type:CASTypeInterstitial, 
    // Optional. CASCallback implementation. Weak reference
                                callback:delegate
  )
```
***
</details>
<details><summary><b>Minimum interval between Interstitial ads</b></summary>
 
You can limit the posting of an interstitial ad to a period of time in seconds after the ad is closed, during which display attempts will fail.  
This setting is available for change through the web application settings.  Unlimited by default (0 seconds).

You can specify minimal interval **before** initialization to allow overrides settings by the web interface for a given session.
```swift
CAS.settings.setInterstitial(interval: interval)
manager = CAS.create(...);
```
Or **after** initialization to override the web application settings for a given session.
```swift
manager = CAS.create(..., onInit: { success, error in  
        // CAS manager initialization done  
        CAS.settings.setInterstitial(interval: interval)
} )
```

You can also restart the countdown interval until the next successful ad shown. For example, after closing Rewarded Video Ad.
```swift
CAS.settings.restartInterstitialInterval()
```
***
</details>

### Show Rewarded Video Ad
<details><summary>Swift</summary>

**Manual load manager mode** require call `loadRewardedVideo` before try show ad.  
You will also need to load new ad after the ad closed.  
```swift
manager.loadRewardedVideo()
```

Invoke the following method to serve an selected ad to your users:
```swift
manager.show(
    fromRootViewController: self,
    type: CASType.Rewarded, 
    // Optional. CASCallback implementation. Weak reference
    callback: delegate
  )
```
***
</details>
<details><summary>Objective-C</summary>

**Manual load manager mode** require call `loadRewardedVideo` before try show ad.  
You will also need to load new ad after the ad closed.  
```objc
[self.manager loadRewardedVideo]
```

Invoke the following method to serve an selected ad to your users:
```swift
[self.manager showFromRootViewController:self,
                                    type:CASTypeRewarded, 
    // Optional. CASCallback implementation. Weak reference
                                callback:delegate
  )
```
***
</details>
<details><summary><b>Redirect rewarded video ad impressions to interstitial ads at higher cost per impression</b></summary>
 
This option will compare ad cost and serve regular interstitial ads when rewarded video ads are expected to generate less revenue.  
Interstitial Ads does not require to watch the video to the end, but the `CASCallback.didCompletedAd` callback will be triggered in any case.  
```java
CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: true);
```
Disabled by default.
***
</details>

## Mediation extras
The CAS mediation adapters provides the `CASNetwork` constant keys to customize parameters to be sent to networks SDK.  

The following sample code demonstrates how to pass these parameters to the networks adapter:
```swift
var extras = [CASNetwork.adMobGDPRConsent: "0",
              CASNetwork.vunglePublishIDFV: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```

Although the GDPR and CCPA settings are used by all media adapters, you have the option to override these values for a specific network.

<details><summary>Google Ads</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.adMobGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.adMobCCPAOptedOut: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
See Admob [GDPR](https://developers.google.com/admob/ios/eu-consent) and [CCPA](https://developers.google.com/admob/ios/ccpa) implementation details for more information about what values may be provided in these methods.
***
</details><details><summary>AppLovin</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.appLovinGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.appLovinCCPAOptedOut: "1",
              // Initialize MAX
              CASNetwork.appLovinUseMAX: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
***
</details><details><summary>AdColony</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.adColonyGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.adColonyCCPAOptedOut: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
See [AdColony’s Privacy Laws implementation details](https://github.com/AdColony/AdColony-iOS-SDK/wiki/Privacy-Laws) for more information about what values may be provided in these methods.
***
</details><details><summary>Vungle</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.vungleGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.vungleCCPAOptedOut: "1",
              // Restrict use of IDFV
              CASNetwork.vunglePublishIDFV: "0"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
See [Vungle's Advanced Settings implementation](https://support.vungle.com/hc/en-us/articles/360048572411) for more information.
***
</details><details><summary>IronSource</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.ironSourceGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.ironSourceCCPAOptedOut: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
See [ironSource's managing consent](https://developers.ironsrc.com/ironsource-mobile/ios/advanced-settings/) documentation for more details.
***
</details><details><summary>Unity Ads</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.unityAdsGDPRConsent: "0",
// User CCPA do not sell data "1" and "0" is use data in ad
              CASNetwork.unityAdsCCPAOptedOut: "1"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```

See [Unity Ads data privacy and consent implementation details](https://unityads.unity3d.com/help/legal/data-privacy-and-consent) for more information about what values may be provided in these methods.
***
</details><details><summary>InMobi</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.inMobiGDPRConsent: "0",
              CASNetwork.inMobiGDPRIAB: iab_string]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
See [InMobi's GDPR implementation details](https://support.inmobi.com/monetize/ios-guidelines) for more information about the possible keys and values that InMobi accepts in this consent object.
***
</details><details><summary>StartApp</summary>

```swift
// User GDPR consent "1" is accepted and "0" is rejected
var extras = [CASNetwork.startAppGDPRConsent: "0"]
              
manager = CAS.create(
    managerID: ownIdentifier,
    mediationExtras: extras)
```
***
</details>

>Unique properties for each network will be added in the future. 

## GitHub issue tracker
To file bugs, make feature requests, or suggest improvements for the iOS SDK, please use [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## Support
Technical support: Max  
Skype: m.shevchenko_15  

Network support: Vitaly  
Skype: zanzavital  

mailto:support@cleveradssolutions.com  

## License
The CAS iOS-SDK is available under a commercial license. See the LICENSE file for more info.
