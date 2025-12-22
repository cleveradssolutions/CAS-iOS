Pod::Spec.new do |s|
  s.name                = "CASMediationPangle"
  s.version             = "7.8.0.7.0"
  s.summary             = "The Pangle mediation adapter is a library that handles communication between the CAS.AI SDK and the Pangle SDK. It enables you to load ads from Pangle using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.5.4/CASMediationPangle-7.8.0.7.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationPangle.xcframework'
  s.dependency 'Ads-Global', '7.8.0.7'
  s.dependency 'CleverAdsSolutions-Base'
end
