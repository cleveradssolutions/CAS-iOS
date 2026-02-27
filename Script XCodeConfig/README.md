# CAS.AI Automatically configure project

The Xcode project requires additional configurations that can be performed automatically by a special script. 

The script automatically performs the following integration steps:
- [x] SKAdNetwork Support
- [x] AdNetworkIdentifiers Support (AdAttributionKit)
- [x] App Transport Security
- [x] Link the CAS project
- [X] Set User Tracking usage description
- [x] Set Google Ads App ID
- [x] Set Google Delay app measurement
- [x] Set `$(inherited)` and `-ObjC` to `OTHER_LDFLAGS` project settings

> [!NOTE]
> Read more about it on [docs page](https://docs.page/cleveradssolutions/docs/iOS/Manually-configure-project).

## Getting Started 
1. Download the [casconfig.rb](https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.3/casconfig.rb)  
3. Place the script in directory with the app `.xcodeproj` 
4. Open the terminal window and run command:
```sh
ruby casconfig.rb CASID
```

> [!NOTE]  
> In most cases, a CASID is the same as your app store ID.  
> You can find an app store ID in the URL of your app’s Apple App Store URL. For example, the URL is `apps.apple.com/us/app/id123456789` then app store ID is `123456789`.

Check the additional features of the script by running the command:
```sh
ruby casconfig.rb --help
```

> [!NOTE]  
> Repeat the script before every update of the application to make sure you are using up-to-date configurations.

## Project path
The script can be located anywhere, provided that the full path to the project is specified using the `--project` parameter.
```sh
ruby /path1/to/casconfig.rb CASID --project=/path2/to/MyApp.xcodeproj
```

## Feedback & Contributions
Found a bug? Have a feature request or suggestion?
Please open an issue using [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## License
The CAS.AI iOS-SDK is available under a commercial license. See the LICENSE file for more info.
