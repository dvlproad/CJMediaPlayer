# CJMediaPlayer
视频播放器

### 需求
1、UI需求
* 小窗口播放
* 全屏播放
* 支持旋屏
* 手势点击后播放进度条的显示隐藏

2、Video 相关
* 支持边下边播（缓存）
* 缓存已经播放过的近期视频
* playback
* 基本操作(resume, pause, reset, rate control等)
* 播放的时间及进度条跟随播放进度自行调整
* 手动拖动播放
* 可以拖动到未下载完的位置吗?
* 声音控制

### 简介
本播放器。
要支持边下边播的实现

方法1：缓存采用HttpServer方案

本地起一个HTTP Server，AVPlayer通过本地的URL播放，即可做到边下载边播放。

方法2：基于AVAssetResourceLoder封装的缓存SDK

CJVideoCache的SDK，是用的另外一套机制实现的。CJPlayerManager提供了清除缓存文件的接口。

两种方案比较：

httpServer支持iOS5以上，而系统AVAssetResourceLoder方案不支持，但是AVAssetResourceLoder是比较好的方案

##### 视频下载时候的缓存功能组件的实现原理：
1. 替换视频资源URL的scheme为系统无法识别的scheme, 得到一个伪造的url.
2. 使用伪造的url初始化AVURLAsset, 并指定AVURLAsset的resourceLoader属性的委托.
3. 通过resourceLoader的委托方法对视频资源数据的请求进行拦截，根据截获到resourceLoader的请求的offset和length, 首先检查本地是否存在缓存数据，如果已存在，则直接从缓存文件中读取缓存数据，并返回给resourceLoader的请求；
4. 否则计算未缓存的文件块，然后发起网络请求，通过http的range方式向服务器请求相应的视频资源数据. 网络请求每次返回的数据，先追加缓存到一个nsdata中（目的在于减少文件IO）,如果nsdata的长度大于一个分片长度，则写入缓存文件，并更新缓存描述文件，标记对应的片段已缓存，然后通知拦截器读取缓存数据，返回给resourceLoader的pending请求. 

备注：缓存文件采用分片方式进行缓存，每个分片为10k, 具体大小可以调整。且该组件只适用于AVPlayer播放视频.


### 使用说明
#### 接入环境
* iOS版本要求: >= 7.0
* 服务端要求: N/A

#### 导入
以POD形式导入SDK项目

    pod 'CJMediaPlayer', :tag => '1.0.0'

#### 项目工程配置
* N/A

#### 接入流程

* VideoViewController.*

```
[self.playerView setVideoURL:[NSURL URLWithString:@"http://xxx.mp4"]
				  coverImage:nil
				   needCache:NO
					maskType:PlayerMaskViewNormal];
```

* 自定义UI部分
详细的自定义见CJPlayerMaskView.h中的接口和注释

#### 缓存组建的接入流程
1.生成伪URL(替换视频资源的scheme为自定义的scheme)，并用其创建AVURLAsset:

```
NSURL *url = [NSURL URLWithString:@"http://mvvideo2.meitudata.com/56f103d8d2cf51799.mp4"];
NSURL *fakeUrl = [MTAVUtil fakeUrl:url];
AVURLAsset *videoURLAsset      = [AVURLAsset URLAssetWithURL:fakeUrl options:nil];
```
2 创建MTAVResourceLoaderManager缓存实例，并将其设置给AVURLAsset的resourceLoader属性的委托（注意这里的缓存实例必须是强制拥有的）

```
MTAVResourceLoaderManager *loaderManager = [[MTAVResourceLoaderManager alloc] init];
[videoURLAsset.resourceLoader setDelegate:loaderManager 
										 queue:dispatch_get_main_queue()];
```


3 附加：如果有视频播放的切换时，记得要调用MTAVResourceLoaderManager的clean方法，清理一下，例如：
```
[self.loaderManager clean];
```

备注：全局只需一个MTAVResourceLoaderManager的实例即可，播放切换时 必须先clean一下.

#### 其他
* 缓存问题 - 播放10s内的视频文件时，可能会出现刚开始黑屏的现象，貌似边下边播对于超短视频，其实已经要下载完才开始播放了
* 同一时刻只支持一个视频下载
* 耗电问题 - 长时间维持一个local http server，不过具体的能耗我也没有测量过
* 播放器现在采用了状态机机制，容易出现bug等问题，后续这一块需要寻找更好的方案替换掉
* 播放器在不同场景下容易出现比较多的bug，如多个播放器在一个tableview中，在SDK调试时容易出现问题

#### 参考资料
1. [iOS音视频实现边下载边播放](http://sky-weihao.github.io/2015/10/06/Video-streaming-and-caching-in-iOS/) 
2. [iOS视频边下边播--缓存播放数据流](http://www.jianshu.com/p/990ee3db0563)
3. [iOS音视频实现边下载边播放](http://sky-weihao.github.io/2015/10/06/Video-streaming-and-caching-in-iOS/)

### 维护信息
* 如果发现SDK不能满足产品需求，建议先与组件维护联系人反馈，协商处理方案。
* 如果发现SDK的bugs，也可以先行沟通，确认没有在修的情况下，可以通过个人分支修复，发起Pull Request来让维护同学review后合并到发布分支，跟着下一个SDK tag版本发布。

#### SDK联系人
iOS	   dvlproad (studyroad@qq.com)

#### 已接入产品
* 暂无

#### 版本更新历史 (按版本划分)
[0.0.1] 2016.04.09 提取组件，构造podspec，并修改Readme

 
 
