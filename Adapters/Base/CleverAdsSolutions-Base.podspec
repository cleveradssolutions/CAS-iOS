Pod::Spec.new do |s|
  s.name                = "CleverAdsSolutions-Base"
  s.version             = "4.6.3"
  s.summary             = "Monetize your mobile applications easy with CAS.AI iOS framework"
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/#{s.version}/CleverAdsSolutions-#{s.version}.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.cocoapods_version   = '>= 1.13.0'
  s.libraries           = 'z'
  s.frameworks = 'UIKit', 'Network', 'WebKit', 'AVFoundation', 'Foundation', 'SwiftUI'
  s.weak_frameworks = 'AdSupport', 'AppTrackingTransparency'
  s.vendored_frameworks = 'CleverAdsSolutions.xcframework'
  s.resources = 'CASBaseResources.bundle'
end
