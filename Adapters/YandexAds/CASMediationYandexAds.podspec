Pod::Spec.new do |s|
  s.name                = "CASMediationYandexAds"
  s.version             = "7.14.1.0"
  s.summary             = "The YandexAds mediation adapter is a library that handles communication between the CAS.AI SDK and the YandexAds SDK. It enables you to load ads from YandexAds using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationYandexAds-7.14.1.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationYandexAds.xcframework'
  s.dependency 'YandexMobileAds', '7.14.1'
  s.dependency 'CASMediationIronSource'
end
