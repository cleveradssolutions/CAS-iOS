Pod::Spec.new do |s|
  s.name                = "CASMediationMadex"
  s.version             = "1.7.5.0"
  s.summary             = "The Madex mediation adapter is a library that handles communication between the CAS.AI SDK and the Madex SDK. It enables you to load ads from Madex using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.6.0/CASMediationMadex-1.7.5.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationMadex.xcframework'
  s.dependency 'MadexSDK', '1.7.5'
  s.dependency 'SspnetCore', '1.7.5'
  s.dependency 'CleverAdsSolutions-Base'
end
