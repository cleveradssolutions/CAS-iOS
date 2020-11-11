# CleverAdsSolutions-iOS SDK Integration 

[![SDK](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-Specs/master/CAS.json)](https://github.com/cleveradssolutions/CAS-Specs/tree/master/Specs/CleverAdsSolutions-SDK)
[![Promo](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/CAS-Specs/master/CASPromo.json)](https://github.com/cleveradssolutions/CAS-Specs/tree/master/Specs/CleverAdsSolutions-Promo)
[![SKAdNetworksID](https://img.shields.io/badge/SKAdNetworksItems-Oct%2029%2C%202020-orange)](https://github.com/cleveradssolutions/CAS-iOS/blob/master/SKAdNetworkItems.xml)
[![Updated](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/cleveradssolutions/App-ads.txt/master/Shield.json)](https://github.com/cleveradssolutions/App-ads.txt)

## Note
- XCode 12 and up
- Works on iOS 10 and above.

# Table of contents
 1.  [Add the CAS Framework to Your Xcode Project](#step-1-add-the-cas-framework-to-your-xcode-project)  
 2.  [Add Cross Promotion Framework (Optional)](#step-2-add-cross-promotion-framework)  
 3.  [Configuring App Transport Security](#step-3-configuring-app-transport-security)  
 4.  [Configuring SK Ad Networks](#step-4-configuring-sk-ad-networks)  
 5.  [Configuring Privacy Controls](#step-5-configuring-privacy-controls)  
 6.  [Configuring URL Schemes (Optional)](#step-6-configuring-url-schemes)  
 7.  [Google Ads App ID](#step-7-google-ads-app-id)  
 8.  [Add the CAS default settings file (Optional)](#step-8-add-the-CAS-default-settings-file)  
 9. [Import the CAS SDK](#step-9-import-the-cas-sdk)
 10.  [Privacy Laws](#step-10-privacy-laws)  
 10.1.  [GDPR Managing Consent](#gdpr-managing-consent)  
 10.2.  [CCPA Compliance](#ccpa-compliance)  
 10.3.  [COPPA and EEA Compliance](#coppa-and-eea-compliance)  
 11.  [Initialize the SDK](#step-10-initialize-the-sdk)  
 12.  [Implement our Ad Units](#step-11-implement-our-ad-units)  
 12.1. [Banner Ad](#banner-ad)  
 12.2. [Ad Size](#ad-size)  
 12.3. [Ad events](#ad-events)  
 12.4. [Check Ad Availability](#check-ad-availability)  
 12.5. [Show fullscreen Ad](#show-fullscreen-ad)  
 13.  [GitHub issue tracker](#github-issue-tracker)
 14.  [Support](#support)  
 15.  [License](#license)

#### The Integration Demo application demonstrate how to integrate the CAS Mediation in your app.
Each iOS example app on this repository includes a Podfile and a Podfile.lock. The Podfile.lock tracks the version of each Pod specified in the Podfile that was used to build the release of the iOS example apps.  

1. Run `pod install` in the same directory as the Podfile.
2. [Optional] Run `pod update` to get the latest version of the SDK.
3. Open the `.xcworkspace` file with Xcode and run the app.

See the [CocoaPods Guides](https://guides.cocoapods.org) for more information on installing and updating pods.

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
pod 'CleverAdsSolutions-SDK', '~> 1.7.0'
```
> Some third party partners are not included in the main dependency: MyTarget, MobFox, AmazonAd.  Combine main dependency with partners dependencies from Advanced CocoaPods integration.
4. Then from the command line run:
```
pod install --repo-update
```
If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Podfiles

</details>
<details><summary><b>Advanced CocoaPods</b></summary>

We support partial integration of the third party mediation sdk you really need.  
To do this, use any combination of partial dependencies.  
**Please provide us with a list of integrated dependencies so that we can make the correct settings.**  

General is dependency of third-party mediation SDK that are always recommended to be used: Google Ads, Vungle, IronSource, AdColony, AppLovin, Facebook AN, InMobi, Yandex Ads, Unity Ads, Kidoz.
```cpp
pod 'CleverAdsSolutions-SDK/General', '~> 1.7.0'
```
Separate dependencies for each third party partner.:
```cpp
pod 'CleverAdsSolutions-SDK/MobFox'
pod 'CleverAdsSolutions-SDK/AmazonAd'
pod 'CleverAdsSolutions-SDK/Chartboost'
pod 'CleverAdsSolutions-SDK/StartApp'
pod 'CleverAdsSolutions-SDK/Kidoz'
pod 'CleverAdsSolutions-SDK/SuperAwesome' # Works only for children audience
pod 'CleverAdsSolutions-SDK/MyTarget' # Works only for CIS countries
```
> The list of third party partners will change in the future.

</details>
<details><summary><b>Manual Download</b></summary>

Follow these steps to add the CAS SDK to your project:
1. Download latest version of [CleverAdsSolutions.zip](https://github.com/cleveradssolutions/CAS-iOS/releases/latest).
2. Unzip it into your Xcode Project
3. Add `CleverAdsSolutions.framework` to dependencies
4. Set `Swift Compiler - Search paths` to the CASMediation folder in Build Settings.
5. Add any supported third party mediation sdk.
6. Remove unused scripts from the CASMediation folder of third party mediation that are not integrated.

</details>

## Step 2 Add Cross Promotion Framework
**Optional step.**  
Cross promotion is an app marketing strategy in which app developers promote one of their titles on another one of their titles. Cross promoting is especially effective for developers with large portfolios of games as a means to move users across titles and use the opportunity to scale each of their apps. This is most commonly used by hyper-casual publishers who have relatively low retention, and use cross promotion to keep users within their app portfolio.

Start your cross promotion campaign with CAS [here](https://cleveradssolutions.com).

Open your project's Podfile and add this line to your app's target:
```cpp
pod 'CleverAdsSolutions-Promo', '~> 1.7.0'
```
Then from the command line run:
```
pod install --repo-update
```

## Step 3 Configuring App Transport Security
With the release of iOS 9 Apple introduced ATS, which requires apps to make secure network connections via SSL and enforces HTTPS connections through its requirements on the SSL version, encryption cipher, and key length. At this time, CAS highly recommends **disabling ATS** in your application. Please note that, while CAS fully supports HTTPS, some of our advertisers and 3rd party ad tracking providers do not. Therefore enabling ATS may result in a reduction in fill rate.

From the options mentioned below, please choose either option for seemless ad delivery and monetization.

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

## Step 4 Configuring SK Ad Networks
<details><summary><b>What is SKAdnetwork?</b></summary>
 
SKAdnetwork is a privacy safe method provided by Apple for ad networks to track installs. Up until iOS 14, most ad network campaign attribution has been based on a user's IDFA, but on iOS 14 and beyond, IDFAs will be less usable as a way to attribute which users have installed based on which ads they have interacted with.
</details>
<details><summary><b>How do I implement SKAdnetwork?</b></summary>

To use SKAdnetwork, app developers must define which networks have permission to show ads within their app. Please add the SKAdNetworkIdentifiers listed below to your app's plist file as described [here](https://developer.apple.com/documentation/storekit/skadnetwork/configuring_the_participating_apps).

</details>
<details><summary><b>Why should I implement SKAdnetwork?</b></summary>
Going forward, fewer campaigns can rely on the IDFA to track ad campaign performance. Supporting SKAdnetwork will increase the number of eligible campaigns that may serve on your app which will increase demand and therefore eCPMs
</details>

To enable this functionality, you will need to update the SKAdNetworkItems key with an additional dictionary in your Info.plist.
[View the latest list in XML format](SKAdNetworkItems.xml)

## Step 5 Configuring Privacy Controls
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

For more information, see [Apple's developer documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription) or [Google Ads documentation](https://developers.google.com/admob/ios/ios14#request).

Important: CAS does not provide legal advice. Therefore, the information on this page is not a substitute for seeking your own legal counsel to determine the legal requirements of your business and processes, and how to address them.  

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
</details>

## Step 6 Configuring URL Schemes
With the release of iOS 9, Apple also restricted usage of the canOpenURL: API, which CAS mediation networks uses to make decisions about whether or not we can land users in certain apps from our Dynamic End Cards (DECs). For example, one of our ad units could be for a new movie, and the associated DEC may present functionality to the user that allows them to send a tweet about it using the Twitter app. This kind of functionality is still possible in iOS 9, but publishers must enable it for the applications CAS links to by authorizing each app’s URL scheme in their plist. Note that if the schemes are not added, users will be taken to the app’s website instead, which may result in an undesirable user experience - having to login to the site, for example. In order to enable deep-linking for the apps the CAS uses, please add the following entry to your app's plist:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>fb</string>
    <string>instagram</string>
    <string>tumblr</string>
    <string>twitter</string>
</array>
```
## Step 7 Google Ads App ID
Follow the [link](http://psvpromo.psvgamestudio.com/cas-settings.php) to get your Admob App ID.  

Add your AdMob App ID to your app's `Info.plist` file by adding a `GADApplicationIdentifier` key:
```xml
<!-- Sample AdMob App ID: ca-app-pub-3940256099942544~1458002511 -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

**Note:** If you haven't created an CAS account and registered an app yet, now's a great time to do so. In a real app, it is important that you use your actual AdMob app ID, not the one listed above. If you're just looking to experiment with the SDK in a Hello World app, though, you can use the sample App ID shown above.  

## Step 8 Add the CAS default settings file
**Optional step.**  
Follow the [link](http://psvpromo.psvgamestudio.com/cas-settings.php) to download a `cas_settings.json` file.

Drop the `cas_settings.json` to your project and link the settings file to `Build Phases > Copy Bundle Resources`. However, only the **main bundle** resources is supported.  

## Step 9 Import the CAS SDK
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
</details>

## Step 10 Privacy Laws
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
</details>

**We recommend to set Privacy API before initializing CAS SDK.**

## Step 10 Initialize the SDK
<details><summary><b>Configure Ads Settings singleton instance</b></summary>
 
```swift
CAS.settings.updateUser(consent: userConsent)
CAS.settings.setDebugMode(debugMode)
CAS.settings.setTrackLocation(enabled: isTrackLocation)
// .. other settings
```

**Select the desired load manager mode:**
|        Mode        |  Load*  | Impact on App performance | Memory usage |        Actual ads*       |
|:------------------:|:------:|:-------------------------:|:------------:|:------------------------:|
|   FastestRequests  |  Auto  |         Very high         |     High     |       Most relevant      |
|    FastRequests    |  Auto  |            High           |    Balance   |      High relevance      |
|  Optimal(Default)  |  Auto  |          Balance          |    Balance   |          Balance         |
|   HighPerformance  |  Auto  |            Low            |      Low     |       Possible loss      |
| HighestPerformance |  Auto  |          Very low         |      Low     |       Possible loss      |
|       Manual      | Manual |          Very low         |      Low     | Depends on the frequency |

```swift
CAS.settings.setLoading(mode: .optimal)
```

> Actual ads* - Potential increase in revenue by increasing the frequency of ad requests. At the same time, it greatly affects the performance of the application.   

> Load*  
> Auto control load mediation ads starts immediately after initialization and will prepare displays automatically.  
> Manual control loading mediation ads requires manual preparation of advertising content for display. Use ad loading methods before trying to show: `CASMediationManager.loadInterstitial(), CASMediationManager.loadRewardedVideo(), CASBannerView.loadNextAd()`  

</details>
<details><summary><b>Configure Targeting Options singleton instance once before initialize</b></summary>
 
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

</details>
<details><summary><b>Initialize Mediation Manager instance (Swift)</b></summary>
  
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
/* Class body ... */

    var manager: CASMediationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure CAS.settings before initialize
        // Configure CAS.targetingOptions before initialize
        manager = CAS.create(
          // CAS manager (Placement) identifier.
          managerID: ownIdentifier, 
          // Optional set active Ad Types: '[CASTypeFlags.banner, CASTypeFlags.interstitial]' for example.
          // Ad types can be enabled manually after initialize by CASMediationManager.setEnabled
          enableTypes: CASTypeFlags.everything, 
          // Optional Enable demo mode that will always request test ads. Set FALSE for release!  
          demoAdMode: isTestBuild, 
          // Optional subscribe to initialization done  
          onInit: { success, error in  
              // CAS manager initialization done  
          }  
        )  
        return true
    }
}
```
</details>
<details><summary><b>Initialize Mediation Manager instance (Objective-C)</b></summary>
 
```objc
@implementation AppDelegate
/* Class body ... */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure CAS.settings before initialize
    CASMediationManager *manager =
        // CAS manager (Placement) identifier.
        [CAS createWithManagerID:own_identifier
        // Optional set active Ad Types: 'CASTypeInt.banner | CASTypeInt.interstitial' for example.
        // Ad types can be enabled manually after initialize by CASMediationManager.setEnabled
                     enableTypes:CASTypeInt.everything
        // Optional Enable demo mode that will always request test ads. Set FALSE for release!  
                      demoAdMode:YES
        // Optional subscribe to initialization done  
                          onInit:^(BOOL complete, NSString *_Nullable error) {
        // CAS manager initialization done  
    }];
    return YES;
}
@end
```
</details>

CAS.create can be called for different identifiers to create different managers. 

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
</details>

## Step 11 Implement our Ad Units
### Banner Ad
Banner ads are displayed in `CASBannerView` objects from module `CleverAdsSolutions`, so the first step toward integrating banner ads is to include a `CASBannerView` in your view hierarchy. This is typically done either with the **Interface Builder** or **programmatically**.

<details><summary><b>Interface Builder</b></summary>

A `CASBannerView` can be added to a storyboard or xib file like any typical view. When using this method, be sure to add width and height constraints to match the ad size you'd like to display. For example, when displaying a banner (320x50), use a width constraint of 320 points, and a height constraint of 50 points.
</details>

A `CASBannerView` can also be instantiated directly. Here's an example of how to create a `CASBannerView`, aligned to the bottom center of the safe area of the screen, with a banner size of 320x50:

<details><summary><b>Programmatically (Swift)</b></summary>
 
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
</details>
<details><summary><b>Programmatically (Objective-C)</b></summary>
 
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
</details>

#### Load an Banner Ad
Manual load manager mode require call `loadNextAd` after create `CASBannerView` or change banner size.  
And you can use `loadNextAd` for cancel current impression to load next ad for any load manager mode.
```swift
bannerView.loadNextAd()
```

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
</details>

### Check Ad Availability
You can ask for the ad availability directly by calling the following function:
```swift
manager.isAdReady(type: CASType.interstitial) //Check ready any AdType
```

### Show fullscreen Ad
**Manual load manager mode** require call `manager.loadInterstitial()` and `manager.loadRewardedVideo()`  before try show ad.  
You will also need to load new ad after the ad closed.  
```swift
manager.loadInterstitial()
manager.loadRewardedVideo()
```

Invoke the following method to serve an selected ad to your users:
```swift
manager.show(
    fromRootViewController: self,
    // Ad type Interstitial or Rewarded
    type: CASType.interstitial, 
    // Optional. CASCallback implementation. Weak reference
    callback: delegate
  )
```

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

</details>

## GitHub issue tracker
To file bugs, make feature requests, or suggest improvements for the iOS SDK, please use [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## Support
Site: [https://cleveradssolutions.com](https://cleveradssolutions.com)

Technical support: Max  
Skype: m.shevchenko_15  

Network support: Vitaly  
Skype: zanzavital  

mailto:support@cleveradssolutions.com  

## License
The CAS iOS-SDK is available under a commercial license. See the LICENSE file for more info.
