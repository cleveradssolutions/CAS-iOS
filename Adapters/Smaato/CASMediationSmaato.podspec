Pod::Spec.new do |s|
  s.name                = "CASMediationSmaato"
  s.version             = "22.9.3.0"
  s.summary             = "The Smaato mediation adapter is a library that handles communication between the CAS.AI SDK and the Smaato SDK. It enables you to load ads from Smaato using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.0.2/CASMediationSmaato-22.9.3.0.tar.gz" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.swift_versions      = '5.0'
  s.requires_arc        = true  
  s.static_framework    = true
  s.vendored_frameworks = 'libs/CASSmaato.xcframework'
  s.dependency 'smaato-ios-sdk', '22.9.3'
  s.dependency 'smaato-ios-sdk/InApp', '22.9.3'
  s.dependency 'CASMediationIronSource'
end
