#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'set'
require 'xcodeproj'
require 'fileutils'
require 'pathname'

module CASConfig
    ARG_PROJECT = '--project='
    ARG_NO_GAD = '--no-gad'
    ARG_CLEAN = '--clean'
    ARG_IGNORE_ID = '--ignore-id'
    ARG_HELP = '--help'

    XC_PROJECT_FILE = '.xcodeproj'
    SCRIPT_VERSION = '2.0'

    class << self
        attr_accessor :casId, :project_path, :gad_included, :clean_install, :require_id

        def config
            Dir.chdir __dir__
            if block_given?
                yield self
            end

            update_project() do |project|
                update_plist(project.get_plist_path()) do |plist|
                    if @casId.empty?
                        @casId = plist.get_cas_app_id()
                    end
                    if @casId.empty? && @require_id
                        error("[!] You must specify an CAS Id to complete the configuration.")
                        exit_with_help()
                    end
                    
                    cas_config, cas_config_name = load_configuration()
                    project.check_config_file(cas_config, cas_config_name)
                    project.ensure_ldflags
                
                    plist.check_sk_ad_networks()
                    plist.check_att_ad_networks()
                    plist.check_cas_app_id(@casId)
                    plist.check_google_app_id(cas_config)
                    plist.check_transport_security()
                    plist.check_tracking_usage_description()
                    plist.check_app_bound_domains()
                end
            end
            print_footer()
        end

        def update_project()
            instance = Project.new(@project_path)
            yield(instance)
            if instance.dirt?
                instance.project.save()
                puts "Updated: " + relative_path(instance.project.path)
                if running_in_xcode?
                    error("The build was cancelled to complete the project modification for CAS.AI Mediation. Please run the build again. If this message appears more than once, please contact support.")
                    exit 1
                end
            end
        end

        def update_plist(path)
            if File.exist?(path)
                plist = Xcodeproj::Plist.read_from_path(path)
            else
                plist = Hash.new
            end
            instance = ProjectPlist.new(plist)
            yield(instance)
            if instance.dirt?
                begin
                    Xcodeproj::Plist.write_to_path(instance.plist, path)
                    puts "Updated: " + path
                rescue IOError => e
                    error("Failed to save " + path)
                    error(e)
                end
            end
        end

        def gad_included?
            @gad_included
        end

        def clean_install?
            @clean_install
        end

        def read_from_args
            @casId = ""
            @project_path = ENV['PROJECT_FILE_PATH'].to_s
            @gad_included = true
            @clean_install = false
            @require_id = true
            
            if !@project_path.empty? && Pathname.new(@project_path).absolute?
                Dir.chdir File.dirname(@project_path)
                @require_id = false
            end

            if @require_id && ARGV.count == 0
                error("[!] You must specify an CAS Id to complete the configuration.")
                exit_with_help()
            end

            ARGV.each do |arg|
                if arg == ARG_HELP
                    exit_with_help()
                elsif arg == ARG_NO_GAD
                    @gad_included = false
                elsif arg == ARG_CLEAN
                    @clean_install = true
                elsif arg == ARG_IGNORE_ID
                    @require_id = false
                elsif arg.start_with?(ARG_PROJECT)
                    @project_path = arg.split('=', 2)[1]
                    @project_path += XC_PROJECT_FILE unless @project_path.end_with?(XC_PROJECT_FILE)
                    if Pathname.new(@project_path).absolute?
                        Dir.chdir File.dirname(@project_path)
                    end
                    unless File.exist?(@project_path)
                        Dir.chdir File.expand_path('../')
                        unless File.exist?(@project_path)
                            error("[!] Not found project: " + @project_path)
                            exit_with_help()
                        end
                    end
                elsif !arg.empty? && (arg == 'demo' || arg.scan(/\D/).empty?)
                    @casId = arg
                else
                    if arg.start_with?('--')
                        error("[!] Unknown option: " + arg)
                    else
                        error("[!] Invalid CAS Id: " + arg)
                    end
                    exit_with_help()
                end
            end
        end
    
        def relative_path(path)
            Pathname.new(path).relative_path_from(File.expand_path('.')).to_s
        end

        def sub_between(source, startStr, endStr)
            source.split(startStr).last.split(endStr).first
        end

        def running_in_xcode?
            !ENV['PROJECT_FILE_PATH'].nil?
        end

        def error(message)
            if running_in_xcode?
                STDERR.puts "error: " + message 
            else
                STDERR.puts colortxt(message, 31)
            end
        end

        def success(message)
            if running_in_xcode?
                puts "note: " + message 
            else
                puts colortxt(message, 32)
            end
        end

        def warning(message)
            if running_in_xcode?
                puts "warning: " + message 
            else
                puts colortxt(message, 33)
            end
        end

        def thin_text(message)
            if running_in_xcode?
                return message
            else
                return colortxt(message, 2)
            end
        end

        def colortxt(txt, term_color_code)
            "\e[#{term_color_code}m#{txt}\e[0m"
        end

        def print_footer
            return if running_in_xcode?
            puts ""
            puts thin_text("XCode project configuration script version " + SCRIPT_VERSION)
            puts thin_text("   Powered by ") + colortxt("CAS.ai", 36)
        end

        def exit_with_help
            return if running_in_xcode?
            puts ""
            warning "Usage:"
            puts "   Place the script in the directory with the " + XC_PROJECT_FILE + " file"
            puts "   and run the command:"
            puts ""
            print "    $ "
            success "ruby casconfig.rb CASID"
            puts "        In most cases, a CASID is the same as your app store ID"
            puts "        If you haven't created an CAS account and registered an app yet,"
            puts "        now's a great time to do so at https://cas.ai"
            puts "        While testing, use 'demo' as CASID."
            puts ""
            warning "Options:"
            success "    " + ARG_PROJECT + "XCodeProjectName"
            puts "        Specify the app project name when there are multiple projects"
            puts "        in the same folder"
            success "    " + ARG_NO_GAD
            puts "        Skip Google AdMob configuration"
            success "    " + ARG_CLEAN
            puts "        Ignore the SKAdNetworks of the project and add CAS SKAdNetworks only"
            success "    " + ARG_HELP
            puts "        Show help banner of specified command"
            print_footer()
            exit!
        end

        def file_expired?(file)
            clean_install? || !File.exist?(file) || (Time.now - File.mtime(file) > 43200)
        end

        def load_with_cache(url)
            cacheDir = File.join(ENV['HOME'], 'Library', 'Caches', 'com.cleveradssolutions.configuration')
            FileUtils.mkdir_p(cacheDir) unless File.directory?(cacheDir)
            cache_filename = File.join(cacheDir, Digest::MD5.hexdigest(url))
            unless file_expired?(cache_filename)
                cache_content = File.open(cache_filename, 'rb') { |f| f.read }
                unless cache_content.empty?
                    return cache_content
                end
                File.delete(cache_filename)
            end
            if !clean_install? && File.exist?(cache_filename)
                Dir.each_child(cacheDir) do |filename|
                    filepath = File.join(cacheDir, filename)
                    if file_expired?(filepath)
                        File.delete(filepath)
                    end
                end
            end
            res = Net::HTTP.get_response(URI(url))
            if block_given?
                file_contents = yield res
            else
                if res.is_a?(Net::HTTPSuccess)
                    file_contents = res.body
                else
                    error(res.value) # to get error
                    return ""
                end
            end
            unless file_contents.empty?
                File.open(cache_filename, 'wb') { |f| f.write(file_contents) }
            end
            return file_contents
        end

        def load_sk_ad_networks_set()
            url = 'https://raw.githubusercontent.com/cleveradssolutions/CAS-iOS/master/AdNetworkIdentifiers/SKAdNetworkCompact.txt'
            data = load_with_cache(url)
            if data.empty?
                return set()
            else
                return data.split("\n").map{|item| item + ".skadnetwork"}.to_set
            end
        end

        def load_att_ad_networks_set()
            url = 'https://raw.githubusercontent.com/cleveradssolutions/CAS-iOS/master/AdNetworkIdentifiers/AdNetworkCompact.txt'
            data = load_with_cache(url)
            if data.empty?
                return set()
            else
                return data.split("\n").map{|item| item + ".adattributionkit"}.to_set
            end
        end

        def load_configuration()
            if casId.empty? || casId == "demo"
                return "", ""
            end
            url = 'https://psvpromo.psvgamestudio.com/cas-settings.php?platform=1&apply=config&bundle=' + @casId
            data = load_with_cache(url) do |res|
                if res.is_a?(Net::HTTPNoContent)
                    error("[!] CAS Id " + casId + " not registered.")
                    exit_with_help()
                end
                if res.is_a?(Net::HTTPSuccess)
                    configName = sub_between(res['content-disposition'], 'filename="', '"')
                    next Marshal.dump({body: res.body, name: configName})
                end
                error(res.value)
                exit!
                next ""
            end
            if data.empty?
                return "", "" 
            end
            combine = Marshal.load(data)
            return combine[:body], combine[:name]
        end
    end

    class Project
        attr_reader :project, :mainTarget
        def dirt?
            @is_dirt
        end

        def initialize(projectName)
            if projectName.empty?
                foundProjects = Dir.glob("*" + XC_PROJECT_FILE)
                if foundProjects.empty?
                    Dir.chdir File.expand_path('../')
                    foundProjects = Dir.glob("*" + XC_PROJECT_FILE)
                    if foundProjects.empty?
                        CASConfig.error("[!] XCode project not found")
                        CASConfig.exit_with_help
                    end
                end
                if foundProjects.count == 1
                    path = foundProjects.first
                else
                    CASConfig.warning("Found several XC Projects near the script.")
                    CASConfig.warning("Add the --project option with target application project:")
                    foundProjects.each do |file|
                        CASConfig.success "   " + ARG_PROJECT + file
                    end
                    exit
                end
            else
                path = projectName
            end
            puts "Target: " + path
            @project = Xcodeproj::Project.open(path)

            mainTargetName = File.basename(path, XC_PROJECT_FILE)
            @mainTarget = @project.targets.find { |target| target.name == mainTargetName }
            @mainTarget ||= @project.targets.first
        end

        def get_setting(key)
            @mainTarget.build_configurations.each do |config|
                # not resolve some variables, just remove it, for example $(TARGET_NAME)
                # prop = config.resolve_build_setting(key, @mainTarget)
                prop = config.build_settings[key]
                return prop unless prop.nil? || prop.empty?
            end
            return ""
        end

        def set_setting(key, value)
            @mainTarget.build_configurations.each { |config| config.build_settings[key] = value }
            @is_dirt = true
        end

        def get_file_path_in_group(name, group)
            if group.nil?
                return File.join(@project.path.dirname, name)
            elsif group.isa == 'PBXFileSystemSynchronizedRootGroup'
                return File.join(@project.path.dirname, group.display_name, name)
            else
                return File.join(group.real_path, name)
            end
        end

        def create_new_resource_file(name, group)
            @is_dirt = true
            if group.nil?
                xcFile = @project.new_file(name)
                @mainTarget.add_resources([xcFile])
                return xcFile.full_path.to_s
            elsif group.isa == 'PBXFileSystemSynchronizedRootGroup'
                return File.join(@project.path.dirname, group.display_name, name) 
            else
                xcFile = group.new_file(name)
                @mainTarget.add_resources([xcFile])
                return xcFile.full_path.to_s
            end
        end

        def get_plist_path()
            path = get_setting("INFOPLIST_FILE")
            if path.empty?
                path = create_new_resource_file("Info.plist", @project.groups.find{ |group| !group.path.empty? })
                set_setting("INFOPLIST_FILE", path)
                return path
            end
            if path.start_with?("$(SRCROOT)/")
                return path["$(SRCROOT)/".length..]
            end
            if path.start_with?("$(PROJECT_DIR)/")
                return path["$(PROJECT_DIR)/".length..]
            end
            path = path.gsub("$(TARGET_NAME)", @mainTarget.name)
            path = path.gsub("$(CONFIGURATION)", "Release")
            return path
        end

        def check_config_file(configBody, configName)
            return if configBody.empty?
            configName = "cas_settings.json" if configName.empty?
            groupPath = File.dirname(get_plist_path())
            xGroup = @project[groupPath]
            filePath = get_file_path_in_group(configName, xGroup)

            if CASConfig.file_expired?(filePath)
                CASConfig.success "- Config file has been " + (if File.exist?(filePath) then "updated" else "created" end)
                newFilePath = create_new_resource_file(configName, xGroup)
                puts "   " + CASConfig.thin_text(newFilePath)
                File.open(newFilePath, 'w') { |file| file.write(configBody) }
            else
                puts "- Config file is up-to-date"
            end
        end

        def ensure_ldflags
            updated = false
            @mainTarget.build_configurations.each do |config|
                flags = config.build_settings["OTHER_LDFLAGS"] || []
                unless flags.include?("-ObjC")
                    flags.unshift("-ObjC")
                    updated = true
                end
                unless flags.include?("$(inherited)")
                    flags.unshift("$(inherited)")
                    updated = true
                end
                config.build_settings["OTHER_LDFLAGS"] = flags if updated
            end
            if updated
                CASConfig.success "- OTHER_LDFLAGS updated with -ObjC and $(inherited)"
                @is_dirt = true
            else
                puts "- -ObjC and $(inherited) is defined"
            end
        end
    end

    class ProjectPlist
        KEY_SKAD_ARRAY = "SKAdNetworkItems"
        KEY_SKAD = "SKAdNetworkIdentifier"
        KEY_ATTAD_ARRAY = "AdNetworkIdentifiers"
        KEY_SECURITY = "NSAppTransportSecurity"
        KEY_ALLOWS_LOADS = "NSAllowsArbitraryLoads"
        KEY_CAS_APP_ID = "CASAIAppIdentifier"
        KEY_GAD_APP_ID = "GADApplicationIdentifier"
        KEY_GAD_DELAY_INIT = "GADDelayAppMeasurementInit"
        KEY_GAD_AD_VALIDATOR = "GADNativeAdValidatorEnabled"
        KEY_TRACKING_USAGE = "NSUserTrackingUsageDescription"
        KEY_BOUND_DOMAINS = "WKAppBoundDomains"

        attr_reader :plist

        def dirt?
            @is_dirt
        end

        def initialize(plist)
            @plist = plist
        end

        def check_sk_ad_networks()
            requiredIds = CASConfig.load_sk_ad_networks_set()

            skAdArray = @plist[KEY_SKAD_ARRAY]
            
            if skAdArray.nil? || CASConfig.clean_install?
                skAdArray = []
                @plist[KEY_SKAD_ARRAY] = skAdArray
            else
                skAdArray.each do |item|
                    requiredIds.delete(item[KEY_SKAD])
                end
            end
            if requiredIds.count > 0
                requiredIds.each do |item|
                    skAdArray.push({KEY_SKAD=>item})
                end
                CASConfig.success("- " + KEY_SKAD_ARRAY + " has added " + requiredIds.count.to_s + " new items")
                @is_dirt = true
            else
                puts "- " + KEY_SKAD_ARRAY + " is up-to-date"
            end
        end

        def check_att_ad_networks()
            requiredIds = CASConfig.load_att_ad_networks_set()

            attAdArray = @plist[KEY_ATTAD_ARRAY]
            
            if attAdArray.nil? || CASConfig.clean_install?
                attAdArray = []
                @plist[KEY_ATTAD_ARRAY] = attAdArray
            else
                attAdArray.each do |item|
                    requiredIds.delete(item)
                end
            end
            if requiredIds.count > 0
                requiredIds.each do |item|
                    attAdArray.push(item)
                end
                CASConfig.success("- " + KEY_ATTAD_ARRAY + " has added " + requiredIds.count.to_s + " new items")
                @is_dirt = true
            else
                puts "- " + KEY_ATTAD_ARRAY + " is up-to-date"
            end
        end

        def check_transport_security
            security = plist[KEY_SECURITY]
            allowLoad = security && security[KEY_ALLOWS_LOADS]
            if security.nil? || allowLoad.nil?
                plist[KEY_SECURITY] = {KEY_ALLOWS_LOADS=>true}
                @is_dirt = true
                CASConfig.success("- " + KEY_SECURITY + " has been added")
                puts("   to allow a cleartext HTTP (http://) resource load")
                return
            end
            if allowLoad == false
                CASConfig.warning("- " + KEY_ALLOWS_LOADS + " is disabled")
                CASConfig.warning("   App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure")
                CASConfig.warning("   Set " + KEY_ALLOWS_LOADS + " = YES to make sure your ads are not impacted by ATS")
            else
                puts "- " + KEY_SECURITY + " is defined"
            end
        end

        def check_cas_app_id(casId)
            if casId.empty? || casId == "demo"
                return
            end
            currAppId = @plist[KEY_CAS_APP_ID]
            if currAppId != casId 
                @plist[KEY_CAS_APP_ID] = casId
                @is_dirt = true
                CASConfig.success("- " + KEY_CAS_APP_ID + " has been " + (if currAppId.nil? then "added" else "updated" end))
            else
                puts "- " + KEY_CAS_APP_ID + " is up-to-date"
            end
        end

        def get_cas_app_id
            return @plist[KEY_CAS_APP_ID].to_s
        end

        def check_google_app_id(casConfig)
            return unless CASConfig.gad_included?
            requiredAppId = "ca-app-pub-3940256099942544~1458002511"
            unless casConfig.empty?
                requiredAppId = CASConfig.sub_between(casConfig, '"admob_app_id":"', '"')
            end
        
            currAppId = @plist[KEY_GAD_APP_ID]
            if currAppId != requiredAppId 
                @plist[KEY_GAD_APP_ID] = requiredAppId
                @plist[KEY_GAD_DELAY_INIT] = true
                @plist[KEY_GAD_AD_VALIDATOR] = false
                @is_dirt = true
                CASConfig.success("- " + KEY_GAD_APP_ID + " has been " + (if currAppId.nil? then "added" else "updated" end))
                puts "   required for Google AdMob network. Use " + ARG_NO_GAD + " option if app doesn't use AdMob"
            else
                puts "- " + KEY_GAD_APP_ID + " is up-to-date"
            end
        end

        def check_tracking_usage_description
            description = plist[KEY_TRACKING_USAGE]
            if description.nil? || description.empty?
                plist[KEY_TRACKING_USAGE] = "Your data will remain confidential and will only be used to provide you a better and personalised ad experience"
                @is_dirt = true
                CASConfig.success("- " + KEY_TRACKING_USAGE + " has been added")
                CASConfig.success("   to display the App Tracking Transparency authorization request:")
                puts "   " + CASConfig.thin_text(plist[KEY_TRACKING_USAGE])
            else
                puts "- " + KEY_TRACKING_USAGE + " is defined"
            end
        end

        def check_app_bound_domains
            unless plist[KEY_BOUND_DOMAINS].nil?
                CASConfig.warning("- " + KEY_BOUND_DOMAINS + " - Currently, the Clever Ads Solutions doesn't support App Bound Domains feature.")
                CASConfig.warning("   Remove the " + KEY_BOUND_DOMAINS + " key from your Info.plist file, otherwise the CAS SDK might fail to load ads.")
            end
        end
    end
end


if __FILE__ == $0
    CASConfig.config do |config|
        config.read_from_args
    end
end
