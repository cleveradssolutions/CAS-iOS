Pod::Spec.new do |s|
  s.name                = "CASMediationBigo"
  s.version             = "5.1.2.1"
  s.summary             = "The Bigo mediation adapter is a library that handles communication between the CAS.AI SDK and the Bigo SDK. It enables you to load ads from Bigo using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.7.0-alpha1/CASMediationBigo-5.1.2.1.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationBigo.xcframework'
  s.dependency 'BigoADS', '5.1.2'
  s.dependency 'CleverAdsSolutions-Base'
end
