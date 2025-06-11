Pod::Spec.new do |s|
  s.name                = "CASMediationLiftoffMonetize"
  s.version             = "7.5.1.0"
  s.summary             = "The LiftoffMonetize mediation adapter is a library that handles communication between the CAS.AI SDK and the LiftoffMonetize SDK. It enables you to load ads from LiftoffMonetize using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationLiftoffMonetize-7.5.1.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationLiftoffMonetize.xcframework'
  s.dependency 'VungleAds', '7.5.1'
  s.dependency 'CASMediationAppLovin'
end
