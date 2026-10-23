Pod::Spec.new do |s|
  s.name                = "CASMediationBidMachine"
  s.version             = "3.8.2.0"
  s.summary             = "The BidMachine mediation adapter is a library that handles communication between the CAS.AI SDK and the BidMachine SDK. It enables you to load ads from BidMachine using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.8.4-beta1/CASMediationBidMachine-3.8.2.0.zip" }
  s.platform            = :ios, '15.0'
  s.swift_version       = '5.0' 
  s.static_framework    = true
  s.vendored_frameworks = 'CASMediationBidMachine.xcframework'
  s.dependency 'BidMachine', '3.8.2'
  s.dependency 'CleverAdsSolutions-Base'
end
