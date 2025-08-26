Pod::Spec.new do |s|
  s.name                = "CASMediationOgury"
  s.version             = "5.1.0.0"
  s.summary             = "The Ogury mediation adapter is a library that handles communication between the CAS.AI SDK and the Ogury SDK. It enables you to load ads from Ogury using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.0-rc1/CASMediationOgury-5.1.0.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationOgury.xcframework'
  s.dependency 'OgurySdk', '5.1.0'
  s.dependency 'CleverAdsSolutions-Base'
end
