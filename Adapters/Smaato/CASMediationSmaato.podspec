Pod::Spec.new do |s|
  s.name                = "CASMediationSmaato"
  s.version             = "23.2.0.1"
  s.summary             = "The Smaato mediation adapter is a library that handles communication between the CAS.AI SDK and the Smaato SDK. It enables you to load ads from Smaato using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.1-beta1/CASMediationSmaato-23.2.0.1.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationSmaato.xcframework'
  s.dependency 'smaato-ios-sdk', '23.2.0'
  s.dependency 'smaato-ios-sdk/InApp', '23.2.0'
  s.dependency 'CASMediationIronSource'
end
