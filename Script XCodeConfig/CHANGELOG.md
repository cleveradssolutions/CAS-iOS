# CAS.AI iOS XCode Config script change log

# [1.6] - Feb 25, 2026
- Added automatic population of `AdNetworkIdentifiers` in `Info.plist`.
- Added automatic population of `CASAIAppIdentifier` in `Info.plist` (optional for some multiplatform frameworks).

# [1.5] - Nov 20, 2025
- Fixed an error in the script’s behavior when the parameter `--project=` is specified. When the full path to the project is provided, the script’s location no longer matters.
- Error messages are now output to `STDERR`.

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