Pod::Spec.new do |s|
  s.name                = "CASMediationBidease"
  s.version             = "2.2.5.0"
  s.summary             = "The Bidease mediation adapter is a library that handles communication between the CAS.AI SDK and the Bidease SDK. It enables you to load ads from Bidease using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationBidease-2.2.5.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationBidease.xcframework'
  s.dependency 'BideaseSDK', '2.2.5'
  s.dependency 'CASMediationAppLovin'
end
