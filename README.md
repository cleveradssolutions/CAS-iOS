# CleverAdsSolutions-iOS SDK Integration 

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
 9.  [Privacy Laws](#step-9-privacy-laws)  
 9.1.  [GDPR Managing Consent](#gdpr-managing-consent)  
 9.2.  [CCPA Compliance](#ccpa-compliance)  
 9.3.  [COPPA and EEA Compliance](#coppa-and-eea-compliance)  
 10.  [Initialize the SDK](#step-10-initialize-the-sdk)  
 11.  [Implement our Ad Units](#step-11-implement-our-ad-units)  
 11.1. [Banner Ad](#banner-ad)  
 11.2. [Ad Size](#ad-size)  
 11.3. [Ad Callback](#ad-callback)  
 11.4. [Check Ad Availability](#check-ad-availability)  
 11.5. [Show fullscreen Ad](#show-fullscreen-ad)  
 12.  [Adding App-ads.txt file of our partners (Optional)](#step-12-adding-app-ads-txt-file-of-our-partners)  
 13.  [Mediation partners](#mediation-partners)  
 14.  [GitHub issue tracker](#github-issue-tracker)
 15.  [Support](#support)  
 16.  [License](#license)

>  The Integration Demo application demonstrate how to integrate the CAS Mediation in your app.
>  [CAS-iOS-Examples repository](https://github.com/cleveradssolutions/CAS-iOS-Examples)

## Step 1 Add the CAS Framework to Your Xcode Project
The simplest way to import the SDK into an iOS project is to use [CocoaPods](https://guides.cocoapods.org/using/getting-started). Open your project's Podfile and add this line to your app's target:
```
pod 'CleverAdsSolutions-SDK', :git => 'https://github.com/cleveradssolutions/CAS-iOS.git', :tag => '1.5.1'
```
Then from the command line run:
```
pod install --repo-update
```
If you're new to CocoaPods, see their [official documentation](https://guides.cocoapods.org/using/using-cocoapods) for info on how to create and use Podfiles

## Step 2 Add Cross Promotion Framework
**Optional step.**  
Cross promotion is an app marketing strategy in which app developers promote one of their titles on another one of their titles. Cross promoting is especially effective for developers with large portfolios of games as a means to move users across titles and use the opportunity to scale each of their apps. This is most commonly used by hyper-casual publishers who have relatively low retention, and use cross promotion to keep users within their app portfolio.

Start your cross promotion campaign with CAS [here](https://cleveradssolutions.com).

Open your project's Podfile and add this line to your app's target:
```
pod 'CleverAdsSolutions-Promo', :git => 'https://github.com/cleveradssolutions/CAS-iOS.git', :tag => '1.5.1'
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
#### What is SKAdnetwork?
SKAdnetwork is a privacy safe method provided by Apple for ad networks to track installs. Up until iOS 14, most ad network campaign attribution has been based on a user's IDFA, but on iOS 14 and beyond, IDFAs will be less usable as a way to attribute which users have installed based on which ads they have interacted with.

#### How do I implement SKAdnetwork?
To use SKAdnetwork, app developers must define which networks have permission to show ads within their app. Please add the SKAdNetworkIdentifiers listed below to your app's plist file as described [here](https://developer.apple.com/documentation/storekit/skadnetwork/configuring_the_participating_apps).

#### Why should I implement SKAdnetwork?
Going forward, fewer campaigns can rely on the IDFA to track ad campaign performance. Supporting SKAdnetwork will increase the number of eligible campaigns that may serve on your app which will increase demand and therefore eCPMs

To enable this functionality, you will need to update the SKAdNetworkItems key with an additional dictionary in your Info.plist.
[View the latest list in XML format](SKAdNetworkItems.xml)

## Step 5 Configuring Privacy Controls
#### Request App Tracking Transparency authorization
iOS 14 and above requires publishers to obtain permission to track the user's device across applications.  
To display the App Tracking Transparency authorization request for accessing the IDFA, update your Info.plist to add the NSUserTrackingUsageDescription key with a custom message describing your usage. Below is an example description text:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
Some examples include:
```xml
<string>Your data will be used to provide you a better and personalized ad experience.</string>
```
```xml
<string>We try to show ads for apps and products that will be most interesting to you based on the apps you use.</string>
```
```xml
<string>We try to show ads for apps and products that will be most interesting to you based on the apps you use, the device you are on, and the country you are in.</string>
```
For more information, see [Apple's developer documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription) or [Google Ads documentation](https://developers.google.com/admob/ios/ios14#request).

Important: CAS does not provide legal advice. Therefore, the information on this page is not a substitute for seeking your own legal counsel to determine the legal requirements of your business and processes, and how to address them.  

#### Optional permissions 
In iOS 10, Apple has extended the scope of its privacy controls by restricting access to features like the camera, photo library, etc. In order to unlock rich, immersive experiences in the SDK that take advantage of these services, please add the following entry to your apps plist:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Some ad content may require access to the photo library.</string>
<key>NSCameraUsageDescription</key>
<string>Some ad content may access camera to take picture.</string>
<key>NSMotionUsageDescription</key>
<string>Some ad content may require access to accelerometer for interactive ad experience.</string>
```

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

Drop the `cas_settings.json` to any folder in your project. However, only the **main bundle** resources is supported.  

## Step 9 Privacy Laws
This documentation is provided for compliance with various privacy laws. If you are collecting consent from your users, you can make use of APIs discussed below to inform CAS and all downstream consumers of this information.  

A detailed article on the use of user data can be found in the [Privacy Policy](https://github.com/cleveradssolutions/CAS-Android/wiki/Privacy-Policy).

### GDPR Managing Consent
This documentation is provided for compliance with the European Union's [General Data Protection Regulation (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679). In order to pass GDPR consent from your users, you should make use of the APIs and methods discussed below to inform CAS and all downstream consumers of this information.  

**Passing Consent** to CAS API, use this functions:  
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

### CCPA Compliance
This documentation is provided for compliance with the California Consumer Privacy Act (CCPA). In order to pass CCPA opt-outs from your users, you should make use of the APIs discussed below to inform CAS and all downstream consumers of this information.  

**Passing consent to the sale personal information**
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
CAS.settings.updateCCPA(status: .optInSale)
```

###  COPPA and EEA Compliance
This documentation is provided for additional compliance with the [Children’s Online Privacy Protection Act (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy). Publishers may designate all inventory within their applications as being child-directed or as COPPA-applicable though our UI. Publishers who have knowledge of specific individuals as being COPPA-applicable should make use of the API discussed below to inform CAS and all downstream consumers of this information.  

You can mark your ad requests to receive treatment for users in the European Economic Area (EEA) under the age of consent. This feature is designed to help facilitate compliance with the General Data Protection Regulation (GDPR). Note that you may have other legal obligations under GDPR. Please review the European Union’s guidance and consult with your own legal counsel. Please remember that CAS tools are designed to facilitate compliance and do not relieve any particular publisher of its obligations under the law.

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

**We recommend to set Privacy API before initializing CAS SDK.**

## Step 10 Initialize the SDK
You can access to SDK from any thread.  

**Import the CAS SDK**
```swift
// Swift
import CleverAdsSolutions
```
```objc
// Objective-C
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>
```

**Configure Ads Settings singleton instance for configure all mediation managers:**
```swift
CAS.settings.updateUser(consent: userConsent)
CAS.settings.setDebugMode(debugMode)
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

**Initialize MediationManager instance:**
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
/* Class body ... */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure CAS.settings before initialize
        manager = CAS.create(
          // CAS manager (Placement) identifier.
          managerID: own_identifier, 
          // Optional set active Ad Types: '[AdTypeFlags.Banner, AdTypeFlags.Interstitial]' for example.
          // Ad types can be enabled manually after initialize by CASMediationManager.setEnabled
          enableTypes: CASTypeFlags.everything, 
          // Optional Enable demo mode that will always request test ads. Set FALSE for release!  
          demoAdMode: true, 
          // Optional subscribe to initialization done  
          onInit: { success, error in  
              // CAS manager initialization done  
          }  
        )  
        return true
    }
}
```
CAS.create can be called for different identifiers to create different managers. 

**Optional.** Subscribe listener to Ad Loading response:  
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

## Step 11 Implement our Ad Units
### Banner Ad
Banner ads are displayed in `CASBannerView` objects from module `CleverAdsSolutions`, so the first step toward integrating banner ads is to include a `CASBannerView` in your view hierarchy. This is typically done either with the **Interface Builder** or **programmatically**.

#### Interface Builder
A `CASBannerView` can be added to a storyboard or xib file like any typical view. When using this method, be sure to add width and height constraints to match the ad size you'd like to display. For example, when displaying a banner (320x50), use a width constraint of 320 points, and a height constraint of 50 points.

#### Programmatically
A `CASBannerView` can also be instantiated directly. Here's an example of how to create a `CASBannerView`, aligned to the bottom center of the safe area of the screen, with a banner size of 320x50:

#### You can alternatively create CASBannerView programmatically:
```swift
class ViewController: UIViewController, CASCallback {
/* Class body ... */
    override func viewDidLoad() {
        super.viewDidLoad()
        // In this case, we instantiate the banner with desired ad size.
        manager.setBanner(size: CASSize.banner)
        bannerView = CASBannerView(manager: manager)
        
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
        
        // Optional
        bannerView.delegate = self           // Weak reference
        bannerView.adPostion = CASPosition.bottomCenter
    }
}
```
Note that in this case we don't give width or height constraints, as the provided ad size will give the banner an intrinsic content size to size the view.

#### Load an Ad
Manual load manager mode require call `loadNextAd()` after create `CASBannerView` and change banner size.  
You can use `loadNextAd()` for cancel current impression and load next ad.
```swift
bannerView.loadNextAd();
```

### Ad Size
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

If you use `CASLoadingManagerMode.manual` then please call load next ad after banner size changed.
```swift
bannerView.loadNextAd()
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

#### Banner refresh rate
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

### AdCallback
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

#### Minimum interval between Interstitial ads
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

## Step 12 Adding App-ads txt file of our partners  
### "App-ads.txt: How to Make It & Why You Need It"

Last year, the ad tech industry struck back at one of its most elusive problems — widespread domain spoofing that let unauthorized developers sell premium inventory they didn’t actually have. The solution? Over two million developers adopted ads.txt — a simple-text public record of Authorized Digital Sellers for a particular publisher’s inventory — to make sure they didn’t lose money from DSPs and programmatic buyers who avoid noncompliant publishers. Thanks to buyers’ ability to [crawl ads.txt and verify seller authenticity](https://iabtechlab.com/ads-txt-about/), this has quickly become a standard for protecting brands. Ad fraud reduced by 11% in 2019 due to these efforts and publisher’s ability to implement more fraud prevention techniques.  

The time has come for ads.text to evolve in-app. The introduction of apps-ads.txt is an important method for mobile app devs to similarly eliminate fraud and improve transparency.

### What is app-ads.txt?

Like ads.txt, apps-ads.txt is a text file that app devs upload to their publisher website. It lists all ad sources authorized to sell that publisher’s inventory. [The IAB created a system](https://iabtechlab.com/press-releases/app-ads-txt-released-for-public-comment-as-next-step-to-fight-digital-advertising-inventory-fraud/) that allows buyers to distinguish the authorized sellers for specific in-app inventory, weeding out the undesirables.

### How does app-ads.txt work for mobile apps?

A DSP wanting to bid on an app’s inventory crawls the app-ads.txt file on a developer’s website to verify which ad sources are authorized to sell that app’s inventory. The DSP will only accept bid requests from ad sources listed on the file and authorized by the app developer.

### How does app-ads.txt help mobile app developers capture more ad revenue?

**Authorized in-app inventory**. An ever-increasing amount of brands are looking to advertise in-app today. Brand buyers now rely on an adherence to app-ads.txt to make sure they don’t buy unauthorized inventory from app developers and negatively impact campaign performance. Developers who don’t implement app-ads.txt can be removed from any brand buyer’s target media list. That’s why joining the app-ads.txt movement is crucial for publishers to maintain their revenue.

**Ad fraud prevention**. App-ads.txt blocks unauthorized developers who impersonate legitimate apps and mislead DSPs into spending brand budgets on fake inventory. With fraud instances minimized, authentic developers can retain more of the ad revenue from inventory genuinely targeted to their app.

### How do I create an app-ads.txt?

You must list your **Developer Website URL** in the GooglePlay and iTunes app stores. There must be a valid developer website URL in all app stores hosting your apps.

Make sure that your publisher website URL (not app specific URL)  is added in your app store listings. Advertising platforms will use this site to verify the app-ads.txt file.

We have made it easier for you to include CAS list of entries so that don’t have to construct it on your own. Please copy and paste the following text block and include in your txt file along with entries you may have from your other monetization partners:  

**[App-ads.txt](https://cleveradssolutions.com/app-ads.txt)**

## Mediation partners
* [Admob](https://admob.google.com/home)  
* [AppLovin](https://www.applovin.com)  
* [Chartboost](https://www.chartboost.com)  
* [KIDOZ](https://kidoz.net)  
* [UnityAds](https://unity.com/solutions/unity-ads)  
* [Vungle](https://vungle.com)  
* [AdColony](https://www.adcolony.com)  
* [StartApp](https://www.startapp.com)  
* [SuperAwesome](https://www.superawesome.com)  
* [IronSource](https://www.ironsrc.com)  
* [InMobi](https://www.inmobi.com)  
* [Facebook Audience](https://www.facebook.com/business/marketing/audience-network)  
* [Yandex Ad](https://yandex.ru/dev/mobile-ads)  

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
