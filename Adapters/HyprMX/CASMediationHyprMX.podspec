Pod::Spec.new do |s|
  s.name                = "CASMediationHyprMX"
  s.version             = "6.4.3.0"
  s.summary             = "The HyprMX mediation adapter is a library that handles communication between the CAS.AI SDK and the HyprMX SDK. It enables you to load ads from HyprMX using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.2.1/CASMediationHyprMX-6.4.3.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationHyprMX.xcframework'
  s.dependency 'HyprMX', '6.4.3'
  s.dependency 'CleverAdsSolutions-Base'
end
