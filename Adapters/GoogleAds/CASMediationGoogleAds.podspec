Pod::Spec.new do |s|
  s.name                = "CASMediationGoogleAds"
  s.version             = "12.3.0.0"
  s.summary             = "The GoogleAds mediation adapter is a library that handles communication between the CAS.AI SDK and the GoogleAds SDK. It enables you to load ads from GoogleAds using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.0.2/CASMediationGoogleAds-12.3.0.0.tar.gz" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'libs/CASGoogleAds.xcframework'
  s.dependency 'Google-Mobile-Ads-SDK', '12.3.0'
  s.dependency 'CASMediationIronSource'
end
