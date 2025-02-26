#
Pod::Spec.new do |s|
  
  s.name         = "CJMediaPlayer"
  s.version      = "0.0.1"
  s.summary      = "自定义的视频播放器CJMediaPlayer"
  s.homepage     = "https://github.com/dvlproad/CJMediaPlayer.git"
  

  #s.license      = {
  #  :type => 'Copyright',
  #  :text => <<-LICENSE
  #            © 2008-2016 Dvlproad. All rights reserved.
  #  LICENSE
  #}
  s.license      = "MIT"

  s.author   = { "dvlproad" => "" }

  s.platform     = :ios, "9.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJMediaPlayer.git", :tag => "CJMediaPlayer_0.0.1" }
  s.source_files  = "CJMediaPlayer/*.{h,m}"
  #s.public_header_files = 'CJMediaPlayer/CJMediaPlayer/SDK/**/*.h'

  s.frameworks = 'Foundation', "UIKit"

  s.requires_arc = true
  #s.xcconfig   =  {'OTHER_LDFLAGS' => '-lObjC' }
  


  #s.subspec 'ConcreteUI' do |concreteUI|
  #  concreteUI.source_files = 'CJMediaPlayer/CJMediaPlayer/SDK/ConcreteUI/**/*'
  #end

  #s.subspec 'Player' do |player|
  #  player.source_files = 'CJMediaPlayer/CJMediaPlayer/SDK/Player/**/*'
  #end

  #s.subspec 'Cache' do |cache|
  #  cache.source_files = 'CJMediaPlayer/CJMediaPlayer/SDK/Cache/**/*'
  #end
  s.source_files = "CJMediaPlayer/**/*.{h,m}"
  s.dependency 'CJMediaCacheKit'

  s.dependency 'CJBaseUIKit/CJSlider', '~> 0.8.0'  # CJPlayerSlider
  s.dependency 'TransitionKit'
  s.dependency 'PureLayout'

end
