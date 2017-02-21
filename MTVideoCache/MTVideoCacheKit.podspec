Pod::Spec.new do |s|

  s.name         = "MTVideoCacheKit"
  s.version      = "0.0.1"
  s.summary      = "A cache feature"
  s.homepage     = "http://techgit.meitu.com/iosmodules/MTVideoCache"

  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 Meitu. All rights reserved.
    LICENSE
  }

  s.author   = { "lichq" => "" }

  s.platform     = :ios, '7.0'
 
  s.source       = { :git => "http://techgit.meitu.com/iosmodules/MTVideoCache.git", :tag => "0.0.1" }

  s.source_files  = "MTVideoCacheKit/**/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
end
