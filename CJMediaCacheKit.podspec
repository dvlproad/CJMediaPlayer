Pod::Spec.new do |s|
  #查看本地已同步的pod库：pod repo
  #清除缓存：pod cache clean CQDemoKit
  
#  pod trunk register 邮箱地址 '用户名' --description='描述信息'
#  pod trunk register dvlproad@163.com 'dvlproad' --description='homeMac'
#  pod trunk register 913168921@qq.com 'dvlproad' --description='homeMac'
#  pod trunk me

  #验证方法： pod lib lint CJMediaCacheKit.podspec --allow-warnings --use-libraries --verbose
  #提交方法： pod trunk push CJMediaCacheKit.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJMediaCacheKit"
  s.version      = "0.0.1"
  s.summary      = "一个AFNetworking应用的封装(支持加解密、缓存、并发数控制)"
  s.homepage     = "https://github.com/dvlproad/CJMediaPlayer.git"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"
  s.description  = <<-DESC
                  - CJMediaCacheKit/CJMediaCacheKitCommon：AFN请求过程中需要的几个公共方法(包含请求前获取缓存、请求后成功与失败操作)
                  - CJMediaCacheKit/AFNetworkingSerializerEncrypt：AFN的请求方法(加解密方法卸载Method方法中)
                  - CJMediaCacheKit/AFNetworkingMethodEncrypt：AFN的请求方法(加解密方法卸载Method方法中)
                  - CJMediaCacheKit/AFNetworkingUploadComponent：AFN的上传请求方法
                  - CJMediaCacheKit/CJRequestUtil：原生(非AFN)的请求
                  - CJMediaCacheKit/CJCacheManager：自己实现的非第三方的缓存机制
                  

                   A longer description of CJMediaCacheKit in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/dvlproad/CJMediaPlayer.git", :tag => "CJMediaCacheKit_0.0.1" }  #CJMediaCacheKit_0.8.0-beta.2
  s.source_files  = "CJMediaCacheKit/*.{h,m}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.source_files = "CJMediaCacheKit/**/*.{h,m}"
  # Demo
  # s.subspec 'Demo' do |ss|
  #   ss.source_files = "CJMediaCacheKit/Demo/**/*.{h,m}"
  #   ss.dependency 'AFNetworking'
  # end

  # # 系统的请求方法
  # s.subspec 'CJRequestUtil' do |ss|
  #   ss.source_files = "CJMediaCacheKit/CJRequestUtil/**/*.{h,m}"

  #   ss.dependency 'CJMediaCacheKit/CJMediaCacheKitCommon'
  # end

end
