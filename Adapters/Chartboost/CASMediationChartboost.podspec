Pod::Spec.new do |s|
  s.name                = "CASMediationChartboost"
  s.version             = "9.10.0.0"
  s.summary             = "The Chartboost mediation adapter is a library that handles communication between the CAS.AI SDK and the Chartboost SDK. It enables you to load ads from Chartboost using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.4.1/CASMediationChartboost-9.10.0.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationChartboost.xcframework'
  s.dependency 'ChartboostSDK', '9.10.0'
  s.dependency 'CASMediationIronSource'
end
