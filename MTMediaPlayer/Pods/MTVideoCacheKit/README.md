# MTVideoCache
美图app视频下载时候的缓存功能组件

######参考文档：
iOS视频边下边播--缓存播放数据流 http://www.jianshu.com/p/990ee3db0563
iOS音视频实现边下载边播放 http://sky-weihao.github.io/2015/10/06/Video-streaming-and-caching-in-iOS/

   
###### 实现原理：
1. 替换视频资源URL的scheme为系统无法识别的scheme, 得到一个伪造的url.
2. 使用伪造的url初始化AVURLAsset, 并指定AVURLAsset的resourceLoader属性的委托.
3. 通过resourceLoader的委托方法对视频资源数据的请求进行拦截，根据截获到resourceLoader的请求的offset和length, 首先检查本地是否存在缓存数据，如果已存在，则直接从缓存文件中读取缓存数据，并返回给resourceLoader的请求；
4. 否则计算未缓存的文件块，然后发起网络请求，通过http的range方式向服务器请求相应的视频资源数据. 网络请求每次返回的数据，先追加缓存到一个nsdata中（目的在于减少文件IO）,如果nsdata的长度大于一个分片长度，则写入缓存文件，并更新缓存描述文件，标记对应的片段已缓存，然后通知拦截器读取缓存数据，返回给resourceLoader的pending请求. 

备注：缓存文件采用分片方式进行缓存，每个分片为10k, 具体大小可以调整。且该组件只适用于AVPlayer播放视频.


### 使用说明
#### 接入环境
* iOS版本要求: >= 7.0

#### 导入
支持pod导入:pod 'MTVideoCacheKit', :git => 'git@techgit.meitu.com:iosmodules/MTVideoCache.git', :branch => 'cachedemo_urlsession'

#### 接入流程

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



## 维护信息
branch出修改分支并完成后, 发起pull request; 或者与维护人联系


#### SDK联系人
iOS小组 ph@meitu.com，zzc@meitu.com

#### 版本更新历史
* [0.0.1] 2016.04.13 提取组件，构造podspec，并修改Readme