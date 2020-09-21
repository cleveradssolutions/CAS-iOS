Pod::Spec.new do |s|
  s.name                = "CleverAdsSolutions-SDK"
  s.version             = "1.5.2"
  s.summary             = "Clever Ads Solutions iOS framework"
  s.homepage            = "https://cleveradssolutions.com"
  s.license             = { :type => "Commercial", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions" => "support@cleveradssolutions.com" }
  s.source              = { :git => "https://github.com/cleveradssolutions/CAS-iOS.git", :tag => "#{s.version}" }
  s.platform            = :ios
  s.ios.deployment_target = '10.0'
  s.swift_versions      = ['4.2', '5.0']
  s.requires_arc        = true
  s.static_framework    = true
  s.xcconfig            = { 
    'OTHER_LDFLAGS' => '-ObjC',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/**'
  }
  s.source_files         = 'CASMediation/**/*.{h,m,swift}'
  s.private_header_files = 'CASMediation/**/*.h'
  s.preserve_paths       = 'CASMediation/**/module.modulemap'
  s.vendored_frameworks  = 'CASBase/CleverAdsSolutions.framework'
  s.vendored_libraries   = 'libs/libKidozSDK.a' # Kidoz version 1.3.5
  s.dependency 'Google-Mobile-Ads-SDK', '7.65.0'
  s.dependency 'VungleSDK-iOS', '6.8.0'
  s.dependency 'IronSourceSDK', '7.0.1.0'
  s.dependency 'AdColony', '4.4.0'
  s.dependency 'AppLovinSDK', '6.14.3'
  s.dependency 'FBAudienceNetwork', '5.10.1'
  s.dependency 'InMobiSDK/Core', '9.0.7'
  s.dependency 'YandexMobileAds', '2.19.0'
  s.dependency 'StartAppSDK', '4.5.0'
  s.dependency 'SuperAwesome', '7.2.13'
  s.dependency 'UnityAds', '3.4.8'
  s.dependency 'ChartboostSDK', '8.3.1'

end
