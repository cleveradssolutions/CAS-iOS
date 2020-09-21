Pod::Spec.new do |s|
  s.name         = "CleverAdsSolutions-SDK"
  s.version      = "1.5.1.1"
  s.summary      = "Clever Ads Solutions iOS framework"
  s.homepage     = "https://cleveradssolutions.com"
  s.license      = { :type => "Commercial", :file => "LICENSE.md" }
  s.author       = { "CleverAdsSolutions" => "support@cleveradssolutions.com" }
  s.source       = { :git => "https://github.com/cleveradssolutions/CAS-iOS.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "10.0"
  s.swift_versions        = ['4.2', '5.0']
  s.requires_arc = true
  s.xcconfig     = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/CleverAdsSolutions-SDK/CASMediation/**',
                     'OTHER_LDFLAGS' => '-ObjC' }
  s.static_framework = true
  s.default_subspec  = 'Full'

  s.subspec 'Base' do |b|
    b.vendored_frameworks = 'CASBase/CleverAdsSolutions.framework'
  end

  s.subspec 'General' do |g|
    g.source_files  = 'CASMediation/**/*'
    g.private_header_files = 'CASMediation/**/*.h'
    g.dependency 'CleverAdsSolutions-SDK/Base', "#{s.version}"
    g.vendored_libraries = 'libs/libKidozSDK.a' # Kidoz version 1.3.5
  end

  s.subspec 'Full' do |full|
    full.dependency 'CleverAdsSolutions-SDK/General', "#{s.version}"
    full.dependency 'Google-Mobile-Ads-SDK', '7.65.0'
    full.dependency 'VungleSDK-iOS', '6.8.0'
    full.dependency 'IronSourceSDK', '7.0.1.0'
    full.dependency 'AdColony', '4.4.0'
    full.dependency 'AppLovinSDK', '6.14.3'
    full.dependency 'FBAudienceNetwork', '5.10.1'
    full.dependency 'InMobiSDK/Core', '9.0.7'
    full.dependency 'YandexMobileAds', '2.19.0'
    full.dependency 'StartAppSDK', '4.5.0'
    full.dependency 'SuperAwesome', '7.2.13'
    full.dependency 'UnityAds', '3.4.8'
    full.dependency 'ChartboostSDK', '8.3.1'
  end

end
