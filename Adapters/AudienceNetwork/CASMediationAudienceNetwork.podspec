Pod::Spec.new do |s|
  s.name                = "CASMediationAudienceNetwork"
  s.version             = "6.17.1.1"
  s.summary             = "The AudienceNetwork mediation adapter is a library that handles communication between the CAS.AI SDK and the AudienceNetwork SDK. It enables you to load ads from AudienceNetwork using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationAudienceNetwork-6.17.1.1.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationAudienceNetwork.xcframework'
  s.dependency 'FBAudienceNetwork', '6.17.1'
  s.dependency 'CASMediationGoogleAds'
end
