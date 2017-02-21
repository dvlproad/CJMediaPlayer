#
# Be sure to run `pod lib lint MTVideoCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MTVideoCache"
  s.version          = "0.1.0"
  s.summary          = "VideoCache for MT."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  


  s.homepage         = "http://techgit.meitu.com/iosmodules/MTVideoCache"
   s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 Meitu. All rights reserved.
    LICENSE
  }

  
  s.author           = { "zzc" => "zzc@meitu.com" }
  s.source           = { :git => "http://techgit.meitu.com/iosmodules/MTVideoCache.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'MTVideoCacheKit/**/*.{h,m}'
  s.public_header_files = 'MTVideoCacheKit/**/*.h'


  s.frameworks = 'UIKit'


end
