#!/usr/bin/env python

import sys
import os
import subprocess
import shutil
import argparse
import json

_CAS_VERSION = '3.7.0'
_MIN_IOS = '13.0'
_XC_PROJ_NAME = 'CASFrameworks'
_XC_WORKSPACE = _XC_PROJ_NAME + '.xcworkspace'
_FRAMEWORK = '.framework'
_SCRIPT_INFO = '1.4. Apr 22, 2024'

_DYNAMIC_FRAMEWORKS_SET = {
    "AppLovinSDK",
    "HyprMX",
    "OMSDK_Smaato",
    "MadexSDK",
    "SspnetCore",
    "SspnetDsp",
}

join = os.path.join
exists = os.path.exists

_ROOT_DIR = os.path.dirname(os.path.abspath(sys.argv[0]))
_RESULT_DIR = join(_ROOT_DIR, 'Frameworks')
_DATA_DIR = _ROOT_DIR + '/build/Build/Products/Release-iphoneos'
_MAIN_FRAMEWORK = join(_DATA_DIR, _XC_PROJ_NAME + _FRAMEWORK)
_WORKSPACE_PATH = join(_ROOT_DIR, _XC_WORKSPACE)
_PODS_LOCK_PATH = join(_ROOT_DIR, 'Podfile.lock')

frameworkSet = set()
systemLibSet = set()
systemFrameworkSet = set()
systemWeakFrameworkSet = set()
resourcesSet = set()

arg_parser = argparse.ArgumentParser(
        prog='python cas_pods_setup.py',
        description=(
            'This script is designed to seamlessly load and build CAS Adapters, incorporating essential libraries from Cocoapods into the Frameworks directory to facilitate the iOS build process.'
            ),
        epilog='Powered by CAS.AI version ' + _SCRIPT_INFO)

arg_parser.add_argument('mode', default='setup', choices=['setup', 'podfile'], help=(
    "[setup] - Download CAS adapters and compile any sources from Cocoapods and place to Frameworks directory.\n" +
    "[podfile] - Create a Podfile in the same directory. Open the generated Podile in any text editor to manually add any pod names to the target '" + _XC_PROJ_NAME + "'."
    )
)
arg_parser.add_argument('--version', default=_CAS_VERSION, help="Define CAS version for Adapters. Default: " + _CAS_VERSION)
arg_parser.add_argument('--adapters', default=[], nargs='*', help="Replace all pods in Podfile to CAS Adapters from arguments. For example add 'GoogleAds' to include pod 'CleverAdsSolutions-SDK/GoogleAds'.")
arg_parser.add_argument('--no-wrap-libs', action='store_true', help="Don't wrap static libraries in frameworks.")
arg_parser.add_argument('--no-repo-update', action='store_true', help="Skip running `pod repo update` before install.")
arg_parser.add_argument('--no-pods-clear', action='store_true', help="Do not removing all traces of CocoaPods from Xcode project. This option can speed up the re-setup.")
arg_parser.add_argument('--no-static-link', action='store_true', help='Build frameworks from Pod sources as dynamic. By default frameworks build for static linkage.')
arg_parser.add_argument('--to-json', action='store_true', help='Create JSON with XC Configuration. Structure: {"sys_libs": ["name"], "sys_frameworks": ["name"], "sys_weak_frameworks": ["name"], "frameworks_bundles": {"framework1Name", "bundle1Name"}')
arg_parser.add_argument('--silent', action='store_true', help="Show nothing")
arg_parser.add_argument('--verbose', action='store_true', help="Show more debugging information")

args = arg_parser.parse_args()

def print_log(str):
    if not args.silent:
        print(str)
def print_header(str):
    print_log('\n\033[95m' + str + '\033[0m')
def print_error(str):
    print('\033[91m   ' + str + '\033[0m')
def print_info(str):
    print('\033[96m   ' + str + '\033[0m')
def exit_with_error(error):
    print_error(error)
    sys.exit()

def run_command(commands, cwd = None):
    if not cwd:
        cwd = _ROOT_DIR
    process = subprocess.Popen(' '.join(commands), 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE, 
                               shell=True, 
                               cwd=cwd, 
                               universal_newlines=True)
    while True:
        line = process.stdout.readline()
        if line == '' and process.poll() is not None:
            break
        yield str(line)
    rc = process.poll()
    error = process.communicate()[1]
    if error:
        yield str(error)

def remove_dir(path):
    if not path.startswith(_ROOT_DIR):
        path = join(_ROOT_DIR, path)
    if exists(path):
        shutil.rmtree(path)

def find_bundles_with(extension, inDir, recursive = True, skipRecursiveExt='..'):
    for name in os.listdir(inDir):
        path = join(inDir, name)
        if name.endswith(extension):
            yield str(path)
        elif recursive and not name.endswith(skipRecursiveExt) and os.path.isdir(path):
            for bundle in find_bundles_with(extension, path):
                yield str(bundle)

def pods_install():
    print_header("## Pods installing ...")
    if (not exists(_PODS_LOCK_PATH) 
        or not exists(_WORKSPACE_PATH)
        or not exists(join(_ROOT_DIR, 'Pods'))):

        commands = ['pod update']
        if args.no_repo_update:
            commands.append('--no-repo-update')
        for output in run_command(commands):
            if not args.silent:
                if 'The Podfile contains framework or static library targets' not in output:
                    sys.stdout.write(output)

        if not exists(_WORKSPACE_PATH):
            exit_with_error("Pod installation failed. Fix errors above and try again.")
    else:
        print_log("Not required")

def pods_deintegrate():
    if args.no_pods_clear: 
        return
    print_header("## Pods clear")
    for output in run_command(['pod deintegrate']):
        if not args.silent:
            sys.stdout.write(output)
    remove_dir(_WORKSPACE_PATH)
    os.remove(_PODS_LOCK_PATH)

def pods_build():
    print_header("## Pods building ... (this may take a while)")
    remove_dir("build")
    
    command = ([
        'xcodebuild',
        'build',
        '-workspace', _XC_WORKSPACE,
        '-scheme', _XC_PROJ_NAME,
        '-derivedDataPath', "'" + _ROOT_DIR + "/build/'",
        '-sdk', 'iphoneos',
        '-destination', "'generic/platform=iOS'",
        '-configuration', 'Release',
        "IPHONEOS_DEPLOYMENT_TARGET=" + _MIN_IOS,
		"GCC_GENERATE_DEBUGGING_SYMBOLS=NO"
    ])
    
    for output in run_command(command):
        if ' error:' in output:
            exit_with_error(output)
        if ' error ' in output:
            print_error(output)
        elif args.verbose:
            sys.stdout.write(output)

    if not exists(_MAIN_FRAMEWORK):
        exit_with_error("Build corrupted. Fix errors above and try again.\nAdd '--verbose' argument to show more debugging information.")
    else:
        print_log("Build success")

def find_frameworks_to_embed():
    print_header("## Find Frameworks")
    os.makedirs(_RESULT_DIR)
    for framework in find_bundles_with(_FRAMEWORK, _DATA_DIR):
        if not framework.endswith(_XC_PROJ_NAME + _FRAMEWORK):
            frameworkName = os.path.splitext(os.path.basename(framework))[0]
            print_log('-framework "' + frameworkName + '"')
            if args.verbose:
                print_log("   - " + framework[len(_ROOT_DIR):])
            frameworkPath = _RESULT_DIR
            shutil.move(framework, frameworkPath)
            frameworkSet.add(frameworkName)

def find_libraries_to_embed():
    print_header("## Find static libraries")
    for library in find_bundles_with('.a', _DATA_DIR, skipRecursiveExt=_FRAMEWORK):
        libName = os.path.splitext(os.path.basename(library))[0][3:]
        
        if args.no_wrap_libs:
            print_log('-l"' + libName + '"')
            if args.verbose:
                print_log("   - " + library[len(_ROOT_DIR):])
            libName = os.path.basename(library)
            shutil.move(library, join(_RESULT_DIR, libName))
            frameworkSet.add(libName)
            return
        print_log('-framework "' + libName + '"')
        if args.verbose:
            print_log("   - " + library[len(_ROOT_DIR):])
        libFramework = join(_RESULT_DIR, libName + _FRAMEWORK)
        os.makedirs(libFramework)
        shutil.move(library, join(libFramework, libName))
        frameworkSet.add(libName)

def find_resources_in_pods():
    print_header("## Find Resources")
    podsRoot = join(_ROOT_DIR, 'Pods')
    podsXCFileList = join(podsRoot, 'Target Support Files', 'Pods-' + _XC_PROJ_NAME, 'Pods-' + _XC_PROJ_NAME + '-resources-Release-input-files.xcfilelist')
    
    with open(podsXCFileList) as f:
        next(f) #Skip first line with script path
        for line in f:
            bundle = line.strip().replace("${PODS_ROOT}", podsRoot)
            if not bundle: continue
            bundleName = os.path.basename(bundle)
            print_log("   Resources " + bundleName)
            bundlePath = join(_RESULT_DIR, bundleName)
            shutil.move(bundle, bundlePath)
            resourcesSet.add(bundlePath)

def archive_embedded_frameworks():
    print_header("## Archive Embedded Frameworks")   
    os.makedirs(_RESULT_DIR)
    for name in frameworkSet:
        name += '.embeddedframework'
        print_log('   ' + name + '.zip')
        archive = shutil.make_archive(
            base_name=name, 
            format='zip', 
            root_dir=_ROOT_DIR, 
            base_dir=name
        )
        shutil.move(archive, join(_RESULT_DIR, name + '.zip'))
        remove_dir(name)
    
    print_log("\n - Installed " + str(len(frameworkSet)) + " frameworks")

def find_system_frameworks():
    podsXCConfig = join(_ROOT_DIR, 'Pods', 'Target Support Files', 'Pods-' + _XC_PROJ_NAME, 'Pods-' + _XC_PROJ_NAME + '.release.xcconfig')
    
    with open(podsXCConfig) as f:
        for line in f:
            if line.startswith('OTHER_LDFLAGS'):
                otherLDFlags = line.split('-')
                for lib in otherLDFlags:
                    lib = lib.strip()
                    if lib.startswith('l'):
                        lib = lib[2:-1]
                        if lib not in frameworkSet:
                            systemLibSet.add(lib)
                    elif lib.startswith('framework'):
                        lib = lib[len('framework "'):-1]
                        if lib not in frameworkSet:
                            systemFrameworkSet.add(lib)
                for lib in otherLDFlags:
                    lib = lib.strip()
                    if lib.startswith('weak_framework'):
                        lib = lib[len('weak_framework "'):-1]
                        if lib not in systemFrameworkSet and lib not in frameworkSet:
                            systemWeakFrameworkSet.add(lib)
                break

def print_xcconfig_json():
    resultJson = json.dumps({
        "version": args.version,
        "sys_libs": list(systemLibSet),
        "sys_frameworks": list(systemFrameworkSet),
        "sys_weak_frameworks": list(systemWeakFrameworkSet),
        "frameworks": list(frameworkSet),
        "resources": list(resourcesSet)
    })

    with open(join(_ROOT_DIR, 'xcconfig.json'), 'w+') as f:
        f.write(resultJson)
    
def print_xcconfig():
    if args.silent:
        return
    print_header("## Update the XC Project configuration")

    print(" > Main Target settings > Build Settings\n") 
    print_info('FRAMEWORK_SEARCH_PATHS = $(inherited) "' + _RESULT_DIR + '"')

    if systemLibSet or systemFrameworkSet or systemWeakFrameworkSet:
        print_info('OTHER_LDFLAGS = $(inherited) -ObjC' + 
              ''.join(map(lambda lib: ' -l"' + lib + '"', systemLibSet)) + 
              ''.join(map(lambda lib: ' -framework "' + lib + '"', systemFrameworkSet)) + 
              ''.join(map(lambda lib: ' -weak_framework "' + lib + '"', systemWeakFrameworkSet))
        )
    
    if resourcesSet:
        print_header("Some dependency frameworks require resources to be copied to the root of the application")
        print_log("> Main Target settings > Build Phases > Add new Copy Files Phase")
        print_log(">> Destination: Resources")
        print(">> Add Resources to copy files list:\n")
        
        for bundle in resourcesSet:
            print_info(bundle)
    
    usedDynamicFrameworks = list()
    for framework in frameworkSet:
        if framework in _DYNAMIC_FRAMEWORKS_SET:
            usedDynamicFrameworks.append(framework)
    if usedDynamicFrameworks:
        print_header("Some frameworks are dynamic and need to be copied to the application's Frameworks folder")
        print_log("> Main Target settings > Build Phases > Add new Copy Files Phase")
        print_log(">> Destination: Frameworks")
        print(">> Add Frameworks to copy files list:\n")
        for framework in usedDynamicFrameworks:
            print_info(join(_RESULT_DIR, framework + _FRAMEWORK))

def update_podfile(adapters):
    print_header("## Update Podfile")

    if exists(_PODS_LOCK_PATH):
        os.remove(_PODS_LOCK_PATH)

    with open(join(_ROOT_DIR, 'Podfile'), 'w+') as f:
        f.write("source 'https://cdn.cocoapods.org/'\n")
        f.write("source 'https://github.com/cleveradssolutions/CAS-Specs.git'\n")
        f.write("platform :ios, '" + _MIN_IOS + "'\n")
        if args.no_static_link:
            f.write("use_frameworks!\n")
        else:
            f.write("use_frameworks! :linkage => :static\n")
        f.write("$cas_version = '" + _CAS_VERSION + "'\n\n")
        
        f.write("target 'CASFrameworks' do\n")
        pod = "  pod 'CleverAdsSolutions-Base'"
        f.write(pod + ", $cas_version\n")
        print_log(pod)
        if adapters:
            for name in adapters:
                pod = "  pod 'CleverAdsSolutions-SDK/" + name + "'"
                f.write(pod + ", $cas_version\n")
                print_log(pod)
        f.write("end\n")

def main():
    if args.mode == 'podfile':
        update_podfile(args.adapters)
        print_log("")
        print_log(arg_parser.epilog)
        exit()

    if not exists(join(_ROOT_DIR, _XC_PROJ_NAME + '.xcodeproj')):
        exit_with_error("The script should be in the same directory as the " + _XC_PROJ_NAME + ".xcodeproj")

    if not exists(join(_ROOT_DIR, 'Podfile')):
        update_podfile(args.adapters)
    elif args.adapters:
        update_podfile(args.adapters)

    remove_dir(_RESULT_DIR)

    pods_install()
    pods_build()
    find_frameworks_to_embed()
    find_libraries_to_embed()
    find_resources_in_pods()
    find_system_frameworks()
    
    pods_deintegrate()

    print_xcconfig()

    if args.to_json:
        print_xcconfig_json()
    
    remove_dir("build")

    print_log("")
    print_log(arg_parser.epilog)

main()
