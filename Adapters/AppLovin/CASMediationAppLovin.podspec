Pod::Spec.new do |s|
  s.name                = "CASMediationAppLovin"
  s.version             = "13.3.1.1"
  s.summary             = "The AppLovin mediation adapter is a library that handles communication between the CAS.AI SDK and the AppLovin SDK. It enables you to load ads from AppLovin using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.0/CASMediationAppLovin-13.3.1.1.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationAppLovin.xcframework'
  s.dependency 'AppLovinSDK', '13.3.1'
  s.dependency 'CleverAdsSolutions-Base'
end
