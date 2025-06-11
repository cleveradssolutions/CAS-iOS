Pod::Spec.new do |s|
  s.name                = "CASMediationCASExchange"
  s.version             = "4.1.0.0"
  s.summary             = "The CASExchange mediation adapter is a library that handles communication between the CAS.AI SDK and the CASExchange SDK. It enables you to load ads from CASExchange using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.1.0/CASMediationExchange-4.1.0.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'  
  s.static_framework    = true

  s.frameworks = [ 'UIKit', 
                   'Foundation', 
                   'SafariServices', 
                   'SystemConfiguration',
                   'AVFoundation',
                   'CoreGraphics',
                   'CoreLocation',
                   'CoreMedia',
                   'QuartzCore'
                 ]
  s.weak_frameworks = [ 'AdSupport', 'StoreKit', 'WebKit' ]
  s.vendored_frameworks = 'CASMediationExchange.xcframework'
  s.dependency 'CleverAdsSolutions-Base'
end
