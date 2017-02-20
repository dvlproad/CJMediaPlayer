#
#  Be sure to run `pod spec lint MTMediaPlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "MTMediaPlayer"
  s.version      = "1.0.0"
  s.summary      = "MTMediaPlayer."
  s.homepage     = "http://techgit.meitu.com/iosmodules/MTMediaPlayer.git"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 Meitu. All rights reserved.
    LICENSE
  }

  s.author       = { "zhaxh@meitu.com" => "zhaxh@meitu.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "http://techgit.meitu.com/iosmodules/MTMediaPlayer.git", :tag => s.version.to_s }
  s.source_files = 'MTMediaPlayer/MTMediaPlayer/SDK/**/*'
  s.public_header_files = 'MTMediaPlayer/MTMediaPlayer/SDK/**/*.h'


  #s.subspec 'ConcreteUI' do |concreteUI|
  #  concreteUI.source_files = 'MTMediaPlayer/MTMediaPlayer/SDK/ConcreteUI/**/*'
  #end

  #s.subspec 'Player' do |player|
  #  player.source_files = 'MTMediaPlayer/MTMediaPlayer/SDK/Player/**/*'
  #end

  #s.subspec 'Utils' do |utils|
  #  utils.source_files = 'MTMediaPlayer/MTMediaPlayer/SDK/Utils/**/*'
  #end

  #s.subspec 'Cache' do |cache|
  #  cache.source_files = 'MTMediaPlayer/MTMediaPlayer/SDK/Cache/**/*'
  #end
  
  s.frameworks = 'Foundation', 'UIKit'

  s.requires_arc = true
  s.xcconfig   =  {'OTHER_LDFLAGS' => '-lObjC' }

  s.dependency 'TransitionKit'
  s.dependency 'AFNetworking',       '~> 2.5.1'
  s.dependency 'FrameAccessor',      '~> 1.3.2'
  s.dependency 'MBProgressHUD',      '~> 0.9'
  s.dependency 'OpenUDID',           '~> 1.0.0'
  s.dependency 'Reachability',       '~> 3.2'
  s.dependency 'RegexKitLite',       '~> 4.0'
  s.dependency 'SDWebImage',         '~> 3.7.2'
  s.dependency 'SevenSwitch',        '~> 1.3.0'
  s.dependency 'Toast',              '~> 2.2'
  s.dependency 'UIAlertView-Blocks', '~> 1.0'
  s.dependency 'XMLDictionary',      '~> 1.3'
  s.dependency 'PureLayout',         '~> 2.0.6'
  s.dependency 'UIAlertView-Blocks', '~> 1.0'
  s.dependency 'DZNEmptyDataSet',    '~> 1.5.2'
  s.dependency 'Mantle',             '~> 2.0'
  s.dependency 'HexColors',          '~> 2.2.1'
  s.dependency 'CocoaHTTPServer',    '~> 2.3'
    

end
