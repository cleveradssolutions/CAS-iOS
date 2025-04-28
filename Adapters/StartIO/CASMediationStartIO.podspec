Pod::Spec.new do |s|
  s.name                = "CASMediationStartIO"
  s.version             = "4.10.5.0"
  s.summary             = "The StartIO mediation adapter is a library that handles communication between the CAS.AI SDK and the StartIO SDK. It enables you to load ads from StartIO using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.0.2/CASMediationStartIO-4.10.5.0.tar.gz" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.swift_versions      = '5.0'
  s.requires_arc        = true  
  s.static_framework    = true
  s.vendored_frameworks = 'libs/CASStartIO.xcframework'
  s.dependency 'StartAppSDK', '4.10.5'
  s.dependency 'CleverAdsSolutions-Base'
end
