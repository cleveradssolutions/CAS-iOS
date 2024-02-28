# CAS.AI Automatically configure project

Your project requires additional configurations that can be performed automatically by a special script. 

The script automatically performs the following integration steps:
- [x] SKAdNetwork Support
- [x] App Transport Security
- [x] Link the CAS project
- [X] Set User Tracking usage description
- [x] Set Google Ads App ID
- [x] Set Delay app measurement

> [!NOTE]
> Read more about it on [wiki page](https://github.com/cleveradssolutions/CAS-iOS/wiki/Manually-configure-project).

## Getting Started 
1. Download the [casconfig.rb](https://github.com/cleveradssolutions/CAS-iOS/releases/download/3.5.6/casconfig.rb)  
3. Place the script in directory with the app `.xcodeproj` 
4. Open the terminal window and run command:
```
ruby casconfig.rb CASID
```

> [!NOTE]  
> In most cases, a CASID is the same as your app store ID.  
> You can find an app store ID in the URL of your app’s Apple App Store URL. For example, the URL is `apps.apple.com/us/app/id123456789` then app store ID is `123456789`.

Check the additional features of the script by running the command:
```
ruby casconfig.rb --help
```

> [!NOTE]  
> Repeat the script before every update of the application to make sure you are using up-to-date configurations.


## GitHub issue tracker
To file bugs, make feature requests, or suggest improvements for the script, please use [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## Support
mailto:support@cleveradssolutions.com
