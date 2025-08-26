## AppLovin iOS Mediation Adapter Changelog
```ruby
pod 'CASMediationAppLovin', '13.3.1.4'
```

### 13.3.1.4
- Fixed a rare issue where information about displayed ads could be lost, preventing ILRD from being sent.

### 13.3.1.3
- Workaround for rare crashes originating from `CASBridgeMediation`.
- Fixed a crash caused by `NSInvalidArgumentException` crash.
- Resolved a crash occurring in `ALHealthEventsReporter`.

### 13.3.1.2
- The AppLovin dependency is no longer required for other CAS adapters.

### 13.3.1.0
- Certified with AppLovin - 13.3.1

### 13.3.0.1
- Rollback AppLovin 13.2.0 to avoid massive crash on iOS 15.

### 13.3.0.0
- Certified with AppLovin - 13.3.0
- Added Swift Package Manager integration support.

### 13.2.0.0
- Certified with AppLovin - 13.2.0

## Legacy Versions are incompatible with CAS 4.0

### 3.9.10
- Certified with AppLovin - 13.1.0

### 3.9.9

### 3.9.8

### 3.9.7
- Certified with AppLovin - 13.0.1

### 3.9.6

### 3.9.5

### 3.9.4
- Certified with AppLovin - 13.0.0

### 3.9.3

### 3.9.2

### 3.9.1
- Certified with AppLovin - 12.6.0

### 3.9.0

### 3.8.1

### 3.8.0

### 3.7.3
- Certified with AppLovin - 12.5.0

### 3.7.2
- Certified with AppLovin - 12.4.2

### 3.7.0

### 3.6.1
- Certified with AppLovin - 12.4.1

### 3.6.0
- Certified with AppLovin - 12.3.1

### 3.5.6

### 3.5.5
- Certified with AppLovin - [12.2.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.5.4
- Certified with AppLovin - [12.2.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.5.2

### 3.5.1

### 3.5.0
- Certified with AppLovin - [12.1.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.4.2

### 3.4.1
- Certified with AppLovin - [11.11.4](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.3.2

### 3.3.1

### 3.3.0
- Certified with AppLovin - [11.11.3](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.2.5

### 3.2.4

### 3.2.3

### 3.2.2
- Certified with AppLovin - [11.11.2](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.2.1
- Certified with AppLovin - [11.11.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.2.0

### 3.1.9

### 3.1.8
- Certified with AppLovin - [11.10.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.1.7
- Certified with AppLovin - [11.10.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.1.6

### 3.1.4

### 3.1.3
- Certified with AppLovin - [11.9.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.1.2

### 3.1.1
- Certified with AppLovin - [11.8.2](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.0.2
- Certified with AppLovin - [11.8.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 3.0.1
- Certified with AppLovin - [11.7.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)
- Returned to Family Solution due to compatibility issues with other ad networks.

### 3.0.0
- Certified with AppLovin - [11.7.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)
- Increased precision of ad revenue value for automatic analytics collection.

### 2.9.9
- Certified with AppLovin - [11.6.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.9.8
- Certified with AppLovin - [11.6.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.9.7

### 2.9.6
- Certified with AppLovin - [11.5.5](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.9.5

### 2.9.4
- Certified with AppLovin - [11.5.2](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.9.3
- Certified with AppLovin - [11.5.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)
- Fixed a rare bug where some ad zones were not active.
- Disabled user reward from AppLovin `didCompleteRewardedVideo()` callback as incorrect reward could occur.
> The reward will only be given from AppLoving `rewardValidationRequest(for:didSucceedWithResponse:)` callback.

### 2.8.6
- Certified with AppLovin - [11.4.4](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.8.5

### 2.8.4

### 2.8.3
- Certified with AppLovin - [11.4.3](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)

### 2.8.1

### 2.8.0
- Certified with AppLovin - [11.4.1](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)
- Reduced the frequency of attempts to load a banner after a failure.

### 2.7.3

### 2.7.2
- Certified with AppLovin - [11.3.3](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)