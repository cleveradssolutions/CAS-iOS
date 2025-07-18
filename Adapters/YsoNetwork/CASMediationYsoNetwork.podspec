Pod::Spec.new do |s|
  s.name                = "CASMediationYsoNetwork"
  s.version             = "1.1.31.2"
  s.summary             = "The YsoNetwork mediation adapter is a library that handles communication between the CAS.AI SDK and the YsoNetwork SDK. It enables you to load ads from YsoNetwork using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationYsoNetwork-1.1.31.2.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationYsoNetwork.xcframework'
  s.dependency 'YsoNetworkSDK', '1.1.31'
  s.dependency 'CleverAdsSolutions-Base'
end
