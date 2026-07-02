Pod::Spec.new do |s|
  s.name                = "CASMediationMonetrix"
  s.version             = "1.2.0.5"
  s.summary             = "The Monetrix mediation adapter is a library that handles communication between the CAS.AI SDK and the Monetrix SDK. It enables you to load ads from Monetrix using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.0-beta1/CASMediationMonetrix-1.2.0.5.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.resources = "CASMediationMonetrix.xcframework/ios-arm64/CASMediationMonetrix.framework/MonetrixAdsRes.bundle"
  s.vendored_frameworks = 'CASMediationMonetrix.xcframework'
  s.dependency 'CleverAdsSolutions-Base'
end
