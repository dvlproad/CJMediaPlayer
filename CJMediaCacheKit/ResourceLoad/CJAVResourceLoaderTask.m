//
//  CJAVResourceLoaderTask.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/10.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJAVResourceLoaderTask.h"
#import "CJAVResourceCache.h"
#import "CJAVResourceInfo.h"
#import "CJAVUtil.h"


#import "CJAVResourceRequest.h"



const NSInteger MaxConnectNum = 1;


@interface CJAVResourceLoaderTask ()

@property(nonatomic, strong)NSMutableArray *requestArr;

@property(nonatomic, assign)NSInteger loadingReqNum;        //正在请求数据的请求数

@end

@implementation CJAVResourceLoaderTask


- (void)dealloc {
    [self clean];
}

//传入参数为真实URL
- (instancetype)initWithMediaUrl:(NSURL *)url {
    self = [super init];
    if (self) {

        self.loadingReqNum = 0;
        self.requestArr = [NSMutableArray array];
        
        
        NSString *cachePath     = [CJAVResourceCache cachedPathByURL:url];
        NSString *cacheDescPath = [CJAVResourceCache cachedDescPathByURL:url];
        
        //从缓存中读取AVResource信息
        self.curResourceInfo = [CJAVResourceInfo resourceInfoFromCacheWithDescPath:cacheDescPath];
        if (self.curResourceInfo == nil) {
            self.curResourceInfo = [[CJAVResourceInfo alloc] init];
            self.curResourceInfo.url = [url copy];
        }

        //创建并打开缓存文件
        [CJAVResourceCache createCacheFileAtPath:cachePath];
        self.curResourceInfo.cacheFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:cachePath];
 
    }
    
    return self;
}



- (void)finishOrCancelRequest:(CJAVResourceRequest *)request {
    //从数组中删除，并计数减1
    [request cancel];
    [self.requestArr removeObject:request];
    self.loadingReqNum--;
}



- (void)configResourceRequest:(CJAVResourceRequest *)request {
    
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(request)weakRequest = request;
    weakRequest.resourceLoaderDataUpdate = ^{
        
        //有数据更新
        //通知loaderManager
        if (weakSelf.resourceLoaderDataUpdate) {
            weakSelf.resourceLoaderDataUpdate();
        }
        
    };
    
    weakRequest.resourceLoaderDataFinish = ^{
        
        //首先移除该请求
        [weakSelf finishOrCancelRequest:request];
        
        
        //有连接请求完成，判断
        NSLog(@"********* loadingReqNum = %zd, curRequestArr.count = %tu", weakSelf.loadingReqNum, self.requestArr.count);
        if (weakSelf.loadingReqNum < weakSelf.requestArr.count) {
            CJAVResourceRequest *req = weakSelf.requestArr[weakSelf.loadingReqNum++];
            [req start];
        }
        

        
        
        
        if ([weakSelf.requestArr count] > 0) {
            
            //某个请求下载完成, 通知loaderManager
            if (weakSelf.resourceLoaderDataFinish) {
                weakSelf.resourceLoaderDataFinish();
            }
            
        } else {
            
            //所有请求都已经下载完成，通知loaderManager
            if (weakSelf.resourceLoaderDataAllFinish) {
                weakSelf.resourceLoaderDataAllFinish();
            }
            
        }
    };
    
    weakRequest.resourceLoaderDataNotExist = ^{
        
        [weakSelf cancel];
        
        //资源不存在
        //通知loaderManager
        if (weakSelf.resourceLoaderDataNotExist) {
            weakSelf.resourceLoaderDataNotExist();
        }
    };
    
    weakRequest.resourceLoaderDataFailed = ^(NSError *err) {
        
        [weakSelf cancel];
        
        //请求失败
        //通知loaderManager
        if (weakSelf.resourceLoaderDataFailed) {
            weakSelf.resourceLoaderDataFailed(err);
        }
    };
    

}



- (void)printRequest
{
    for (int i = 0; i < self.requestArr.count; ++i) {
        NSLog(@"index = %d, req = %@", i, self.requestArr[i]);
    }
    
    NSLog(@"\n\n");
}


- (void)doLoadTaskWithDataBlockArr:(NSMutableArray *)blockArr
                    LoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    if (!blockArr || blockArr.count == 0) {
        
        //没有block, 第一次请求该文件。
        //先清除所有请求(调不调用都无所谓，本来此时就没有请求)
        [self cancel];
        
        CJAVResourceRequest *request =
        [[CJAVResourceRequest alloc] initWithResourceInfo:self.curResourceInfo
                                                   Offset:0
                                                   Length:-1];
        
        [self configResourceRequest:request];
        [self.requestArr addObject:request];
        
        [request start];
        self.loadingReqNum++;
        
        
        
        NSLog(@"第一次请求_________  requestArr.count: %tu", self.requestArr.count);
        [self printRequest];
        return;
 
    }
        
        
    //当前没有请求, 全部block转换为请求， 并直接返回
    if (self.requestArr.count == 0) {

        [self makeRequestFromBlockArr:blockArr];
        
        NSLog(@"当前没有请求_________  requestArr.count: %tu", self.requestArr.count);
        [self printRequest];
        return;
        
    }
    
    
    NSMutableArray *beCancelRequestArr     = [NSMutableArray array];

    //取出第一个请求和第一个dataBlock
    CJAVResourceRequest *tempLoadingReq    = self.requestArr[0];
    CJAVResourceDataBlock *tempBlock       = blockArr[0];

    //如果请求的currentOffset比当前缓存的末尾位置还大300k，则认为用户往后拖
    //如果请求的currentOffset比当前缓存的起始位置还小，则认为用户往前拖
    BOOL isBackward = tempLoadingReq.curOffset + [CJAVResourceInfo seekInterval] < tempBlock.offset;
    BOOL isForward = tempBlock.offset < tempLoadingReq.startPosition;
    
    
    if (isBackward) {
        
        //往后拖，需要删除当前部分请求
        //添加第一个请求
        [beCancelRequestArr addObject:tempLoadingReq];
        
        //找出剩下还需删除的请求
        for (long i = 1; i < [self.requestArr count]; ++i) {
            
            tempLoadingReq = self.requestArr[i];
            isBackward = tempLoadingReq.curOffset + [CJAVResourceInfo seekInterval] < tempBlock.offset;
            
            if (isBackward) {
                [beCancelRequestArr addObject:tempLoadingReq];
            } else {
                break;
            }
        }
        
        
        for (CJAVResourceRequest * req in beCancelRequestArr) {
            
            //如果该请求正在请求数据，则计数减1,
            if (req.reqStatus == CJAVResourceRequestStatus_Loading) {
                self.loadingReqNum --;
            }
            
            //取消连接
            [req clean];
        }

        //删除已取消的请求, 并重建请求
        [self.requestArr removeObjectsInArray:beCancelRequestArr];
        [self makeRequestFromBlockArr:blockArr];
        

        //如果正在请求的连接数小于最大连接数，则继续发起请求
        while (self.loadingReqNum < MaxConnectNum) {
            
            if (self.loadingReqNum < self.requestArr.count) {
                
                CJAVResourceRequest *tempReq = self.requestArr[self.loadingReqNum++];
                [tempReq start];
                
            } else {
                break;
            }
        }
        
        
        
        NSLog(@"往后拖_________  requestArr.count: %tu", self.requestArr.count);
        [self printRequest];

        
    } else if (isForward) {
        
        //往前拖, 清空所有请求，并重建请求
        [self cancel];
        [self makeRequestFromBlockArr:blockArr];
        
        NSLog(@"往前拖_________  requestArr.count: %tu", self.requestArr.count);
        [self printRequest];
        
        
    } else {
        
        //正常播放
    }

}



- (void)makeRequestFromBlockArr:(NSMutableArray *)blockArr {
    
    for (int i = 0; i < blockArr.count; ++i) {
        
        CJAVResourceDataBlock *dataBlock = blockArr[i];
        
        
        int64_t offset = dataBlock.offset;
        int64_t len = dataBlock.len;
        if (self.curResourceInfo.contentLength < offset + len) {
            len = self.curResourceInfo.contentLength - offset;
        }
        

        CJAVResourceRequest *curRequest =
        [[CJAVResourceRequest alloc] initWithResourceInfo:self.curResourceInfo
                                                   Offset:offset
                                                   Length:len];
        
        
        [self configResourceRequest:curRequest];
        
        
        
        //为了保证requestArr中所有load请求是有序的,先找出当前请求对应的位置
        NSInteger index = 0;
        for (int j = 0; j < self.requestArr.count; ++j) {
            
            CJAVResourceRequest *loadRequest = self.requestArr[j];
            if (loadRequest.startPosition >= curRequest.startPosition) {
                break;
            }
        }
        
        //找到对应的插入位置后，将当前请求插入到请求数组中
        if (index < self.requestArr.count) {
            [self.requestArr insertObject:curRequest atIndex:index];
        } else {
            [self.requestArr addObject:curRequest];
        }
        
        //发送请求，同时最多MaxConnectNum连接
        if (self.loadingReqNum < MaxConnectNum) {
            [curRequest start];
            self.loadingReqNum++;
        }
    }
}





- (BOOL)hasCached
{
    return self.curResourceInfo.status != CJAVResourceInfoStatus_None;
}


- (void)cancel {
    
    for (CJAVResourceRequest *request in self.requestArr) {
        [request cancel];
    }
    [self.requestArr removeAllObjects];
    
    self.loadingReqNum = 0;
}


- (void)clean {

    [self cancel];
    [self.curResourceInfo.cacheFileHandle closeFile];
    self.curResourceInfo.cacheFileHandle = nil;

}



@end
