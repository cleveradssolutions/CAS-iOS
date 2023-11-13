# CAS.AI iOS XCode Config script

This script is designed to seamlessly load and build CAS Adapters, incorporating essential libraries from Cocoapods into the Frameworks directory to facilitate the iOS build process.

## Getting Started

1. Download the [PodFrameworksScript.zip](https://github.com/cleveradssolutions/CAS-iOS/blob/master/Script%20PodFrameworks/PodFrameworksScript.zip).
2. Unpack the archive into an new directory.
3. Run terminal command in the directory.

```
python cas_pods_setup.py setup --adapters Optimal
```

> [!NOTE]
> -   Use an `--version 1.2.3` argument to select CAS version.
> -   Use an `--help` argument to check the additional features of the script

After successfully executing the script, you will see a folder named `Frameworks`. This folder will contain all the libraries and bundles ready to be added to your project.

### Adapters options
You can set muliple `--adapters` argument from [Adapters list](https://github.com/cleveradssolutions/CAS-iOS/wiki/Advanced-integration) or Ads Solutions. For example:

```
python cas_pods_setup.py setup --adapters Families GoogleAds
```
Where `Families` is Ads Solution and `GoogleAds` name of adapter.  


Another way is modify the `Podfile` and not set the `--adapters` argument to install pods defined in the `Podfile`.  
To create the `Podfile` template, use the following command:
```
python cas_pods_setup.py podfile
```

#### See the output of the script with the configuration for the XCode project

-   `FRAMEWORK_SEARCH_PATHS` - Specifies directories in which the compiler searches for frameworks to find included header files.
-   `OTHER_LDFLAGS` - Specifies additional options for linking the binary.
-   Some dependency frameworks require resources to be copied to the root of the application. The script will display a list of resources that should be added to Copy Resources Build Phases.
    > Main Target settings > Build Phases > Add new Copy Files Phase > Destination: Resources
-   Some frameworks are dynamic and need to be copied to the application's Frameworks folder. The script will display a list of dynamic frameworks that should be embedded to Copy Frameworks Build Phases.
    > Main Target settings > Build Phases > Add new Copy Files Phase > Destination: Frameworks

> [!NOTE]  
> Repeat the script before every CAS update to make sure you are using up-to-date configurations.

## GitHub issue tracker

To file bugs, make feature requests, or suggest improvements for the script, please use [GitHub's issue tracker](https://github.com/cleveradssolutions/CAS-iOS/issues).

## Support

mailto:support@cleveradssolutions.com

## License

The CAS iOS-SDK is available under a commercial license. See the LICENSE file for more info.
