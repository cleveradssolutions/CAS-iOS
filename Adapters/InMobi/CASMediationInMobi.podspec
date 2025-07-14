Pod::Spec.new do |s|
  s.name                = "CASMediationInMobi"
  s.version             = "10.8.3.2"
  s.summary             = "The InMobi mediation adapter is a library that handles communication between the CAS.AI SDK and the InMobi SDK. It enables you to load ads from InMobi using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationInMobi-10.8.3.2.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationInMobi.xcframework'
  s.dependency 'InMobiSDK', '10.8.3'
  s.dependency 'CleverAdsSolutions-Base'
end
