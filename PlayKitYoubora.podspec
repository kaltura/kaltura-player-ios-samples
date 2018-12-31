
suffix = '-dev'   # Dev mode
# suffix = ''       # Release

Pod::Spec.new do |s|
  
  s.name             = 'PlayKitYoubora'
  s.version          = '1.0.1' + suffix
  s.summary          = 'PlayKitYoubora -- Analytics framework for iOS'
  s.homepage         = 'https://github.com/kaltura/playkit-ios-youbora'
  s.license          = { :type => 'AGPLv3', :file => 'LICENSE' }
  s.author           = { 'Kaltura' => 'community@kaltura.com' }
  s.source           = { :git => 'https://github.com/kaltura/playkit-ios-youbora.git', :tag => 'v' + s.version.to_s }
  s.swift_version     = '4.0'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Sources/**/*' 
  s.dependency 'PlayKit/AnalyticsCommon', '~> 3.7.0' + suffix
  #s.dependency 'YouboraAVPlayerAdapter', '6.0.11'
  s.dependency 'YouboraLib', '6.1.7'
end

