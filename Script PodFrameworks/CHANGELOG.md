# CAS.AI Pod Frameowkrs setup script change log

# [1.6] - June 24, 2025
- Certified with CAS 4.1.2 (Use `--version` to set CAS version).
- Added YsoNetwork, Ogury, Smaato Frameworks support.

# [1.5] - May 9, 2024
- Certified with CAS 3.7.2 (Use `--version` to set CAS version).
- Fixed the path to generated resource bundles with `${PODS_CONFIGURATION_BUILD_DIR}` variable.
- Fixed `--version` function for create the correct Podfile.

# [1.3] - Feb 28, 2024
- Certified with CAS 3.5.6 (Use `--version` to set CAS version).
- Added Madex Frameworks support.
- The `--embed-archive` function has been removed.
- The `--to-json` function has been updated: now frameworks and resources are written in json separately in the `frameworks` and `resources` lists. 

# [1.2] - Jun 19, 2024
- Certified with CAS 3.5.2 (Use `--version` to set CAS version).
- Added `IPHONEOS_DEPLOYMENT_TARGET=13.0` to build frameworks.
- Added `GCC_GENERATE_DEBUGGING_SYMBOLS=NO` to build frameworks.

# [1.1] - Nov 13, 2023
- Certified with CAS 3.4.1 (Use `--version` to set CAS version).
- Improved search for resource bundles.
- Updated XCode configuration output.
- Fixed some bugs.