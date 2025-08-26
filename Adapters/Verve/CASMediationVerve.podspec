Pod::Spec.new do |s|
  s.name                = "CASMediationVerve"
  s.version             = "3.6.1.0"
  s.summary             = "The Verve mediation adapter is a library that handles communication between the CAS.AI SDK and the Madex SDK. It enables you to load ads from Madex using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.0-rc1/CASMediationVerve-3.6.1.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationVerve.xcframework'
  s.dependency 'HyBid', '3.6.1'
  s.dependency 'CASMediationAppLovin'
end
