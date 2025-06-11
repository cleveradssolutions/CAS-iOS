Pod::Spec.new do |s|
  s.name                = "CASMediationSuperAwesome"
  s.version             = "9.4.0.0"
  s.summary             = "The SuperAwesome mediation adapter is a library that handles communication between the CAS.AI SDK and the SuperAwesome SDK. It enables you to load ads from SuperAwesome using the mediation feature in the CAS.AI SDK."
  s.homepage            = "https://github.com/cleveradssolutions/CAS-iOS"
  s.license             = { :type => "Commercial License", :file => "LICENSE.md" }
  s.author              = { "CleverAdsSolutions LTD" => "support@cas.ai" }
  s.source              = { :http => "https://github.com/cleveradssolutions/CAS-iOS/releases/download/4.0.2.1/CASMediationSuperAwesome-9.4.0.0.zip" }
  s.platform            = :ios, '13.0'
  s.swift_version       = '5.0'
  s.static_framework    = false
  # s.vendored_frameworks = 'CASMediationSuperAwesome.xcframework'
  s.source_files = 'SuperAwesome/*.swift'
  s.dependency 'SuperAwesome', '9.4.0'
  s.dependency 'CleverAdsSolutions-Base'
end
