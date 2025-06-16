# CAS.AI iOS XCode Config script change log

# [1.4] - June 16, 2025
- Added automatic setting of `$(inherited)` and `-ObjC` to `OTHER_LDFLAGS` project settings.
- Aaded `demo` support as CAS ID for testing.

# [1.3] - Jan 30, 2024
- Added support new `PBXFileSystemSynchronizedRootGroup` from XCode 16.
- Removed `MyTargetSDKAutoInitMode` property from Info.plist.

# [1.2] - Feb 28, 2024
- Update `NSUserTrackingUsageDescription` value to `Your data will remain confidential and will only be used to provide you a better and personalised ad experience`.

# [1.1] - Nov 10, 2023
- Fixed exception if CAS Id is not registered.