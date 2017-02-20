# CJMediaPlayer
视频播放器

TODO 感觉代码组织的不够清晰，暴露了一些无用的头文件，然后就是Demo也没有诠释所有支持的功能，比如清理缓存，更复杂的自定义UI方式...

### 简介
美图视频播放器，该播放器是整理的美拍播放器，缓存采用HttpServer方案。

因为要支持边下边播，美拍 <= 4.8.0的版本也是采用的这套方案，最低可以支持到iOS 5.0, 本地起一个HTTP Server，AVPlayer通过本地的URL播放，于是做到边下载边播放。后续还有一个MTVideoCache的SDK，是用的另外一套机制实现的。MPPlayerManager提供了清除缓存文件的接口。

### 使用说明
#### 接入环境
* iOS版本要求: >= 7.0
* 服务端要求: N/A

#### 导入
以POD形式导入SDK项目

    pod 'MTMediaPlayer', :git => 'http://techgit.meitu.com/iosmodules/MTMediaPlayer.git', :tag => '1.0.0'

#### 项目工程配置
* N/A

#### 接入流程

* VideoViewController.*

```
[self.zhiPlayerView 
	setURL:[NSURL URLWithString:@"http://mvvideo5.meitudata.com/56d9292d529c48134.mp4"]
	coverImage:nil
	needCache:NO
	maskType:PlayerMaskViewNormal];
```

* 自定义UI部分

主要是这个类 MPSimplePlayerMaskView, 详细的自定义见MPSimplePlayerMaskView.h中的接口和注释

#### 其他
* 缓存问题 - 播放10s内的视频文件时，可能会出现刚开始黑屏的现象，貌似边下边播对于超短视频，其实已经要下载完才开始播放了
* 同一时刻只支持一个视频下载
* 赶脚自定义UI不够灵活
* 耗电问题 - 长时间维持一个local http server，不过具体的能耗我也没有测量过

#### 参考资料
1. http://sky-weihao.github.io/2015/10/06/Video-streaming-and-caching-in-iOS/

### 维护信息

* 如果发现SDK不能满足产品需求，建议先与组件维护联系人反馈，协商处理方案。
* 如果发现SDK的bugs，也可以先行沟通，确认没有在修的情况下，可以通过个人分支修复，发起Pull Request来让维护同学review后合并到发布分支，跟着下一个SDK tag版本发布。

#### SDK联系人
iOS     吴君恺 (wjk@meitu.com), 查绪恒 (zhaxh@meitu.com)

#### 已接入产品
* tag 1.0.0
    * 变美志

#### 版本更新历史 (按版本划分)
1.0.0 第一个稳定版本 2016.04.09

 
 
