Pod::Spec.new do |s|
  s.name                = "CASMediationBigoSpec"
  s.version             = "6.1.0.0"
  s.summary             = "The CASMediationBigo adapter for VPN apps, linked against BigoADS_spec. Use it instead of CASMediationBigo, not together."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }  
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.3-beta1/CASMediationBigo-6.1.0.0.zip" }
  s.platform            = :ios, '15.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationBigo.xcframework'
  s.dependency 'BigoADS_spec', '6.1.0'
  s.dependency 'CleverAdsSolutions-Base'
end
