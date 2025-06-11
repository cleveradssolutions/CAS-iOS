Pod::Spec.new do |s|
  s.name                = "CASMediationMintegral"
  s.version             = "7.7.8.0"
  s.summary             = "The Mintegral mediation adapter is a library that handles communication between the CAS.AI SDK and the Mintegral SDK. It enables you to load ads from Mintegral using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationMintegral-7.7.8.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationMintegral.xcframework'
  s.dependency 'MintegralAdSDK', '7.7.8'
  s.dependency 'MintegralAdSDK/BidSplashAd', '7.7.8'
  s.dependency 'CASMediationAppLovin'
end
