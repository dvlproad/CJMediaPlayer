//
//  CJAVAssetResourceLoaderManager.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJAVAssetResourceLoaderManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "CJAVUtil.h"
#import "CJAVResourceCache.h"
#import "CJAVResourceLoaderTask.h"


@interface CJAVAssetResourceLoaderManager ()

@property(nonatomic, strong) NSMutableArray *pendingRequestArr;     //未决请求数组
@property(nonatomic, strong)CJAVResourceLoaderTask *loaderTask;     //当前loaderTask

@end


@implementation CJAVAssetResourceLoaderManager

- (void)dealloc {
    
    [self clean];
    
    self.pendingRequestArr = nil;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    self.pendingRequestArr = [NSMutableArray array];
}



/**
 *  切换视频时必须先调用该方法
 */
- (void)clean {
    
    if (self.loaderTask) {
        
        [self.loaderTask clean];
        self.loaderTask = nil;
    }

    
    if (self.pendingRequestArr) {
        
        //清空
        [self.pendingRequestArr removeAllObjects];
    }
}




#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSLog(@"start_request__:%@\n\n", loadingRequest);
    
    //添加请求到未决请求数组中
    [self.pendingRequestArr addObject:loadingRequest];
    [self dealWithLoadingRequest:loadingRequest];

    CJAVResourceInfo *resourceInfo = self.loaderTask.curResourceInfo;
    
    if (resourceInfo.status != CJAVResourceInfoStatus_None) {
        [self processPendingRequests];
    }

    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    NSLog(@"cancel_request__: %@\n\n", loadingRequest);
    [self.pendingRequestArr removeObject:loadingRequest];
}





#pragma mark - Private

- (void)dealWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {

    NSURL *fakeURL = [loadingRequest.request URL];
    NSURL *realURL = [CJAVUtil realUrl:fakeURL];

    //判断loaderTask是否存在，如果不存在，则创建新的实例
    if (!self.loaderTask) {

        __weak typeof(self) weakSelf = self;
        self.loaderTask = [[CJAVResourceLoaderTask alloc] initWithMediaUrl:realURL];
        self.loaderTask.resourceLoaderDataUpdate = ^{
            
            [weakSelf processPendingRequests];
        };
        
        self.loaderTask.resourceLoaderDataFinish = ^{
            
            [weakSelf processPendingRequests];
        };
        
        self.loaderTask.resourceLoaderDataAllFinish = ^{
            
            [weakSelf processPendingRequests];
            
            
            if (weakSelf.pendingRequestArr.count > 0) {
                
//                AVAssetResourceLoadingRequest *loadingRequest = weakSelf.pendingRequestArr[0];
//                for (int i = 1; i < weakSelf.pendingRequestArr.count; ++i) {
//                    
//                    AVAssetResourceLoadingRequest *tempLoadingRequest = weakSelf.pendingRequestArr[i];
//                    if (loadingRequest.dataRequest.currentOffset > tempLoadingRequest.dataRequest.currentOffset) {
//                        loadingRequest = tempLoadingRequest;
//                    }
//                }

                AVAssetResourceLoadingRequest *loadingRequest = [weakSelf.pendingRequestArr lastObject];
                
                //继续处理
                [weakSelf dealWithLoadingRequest:loadingRequest];
            }

        };
        
        self.loaderTask.resourceLoaderDataFailed = ^(NSError *err){
            
            if (![weakSelf.loaderTask hasCached]) {
                
                //完全没有缓存
                if (weakSelf.resourceLoadFailed) {
                    weakSelf.resourceLoadFailed(err);
                }
            }
        };
        
        self.loaderTask.resourceLoaderDataNotExist = ^{
            
            //NSLog(@"文件不存在, 返回404");
            if (weakSelf.resourceNotExist) {
                weakSelf.resourceNotExist();
            }
        };
    }
        
    //判断该请求所请求的数据块是否已缓存
    int64_t reqCurrentOffset = loadingRequest.dataRequest.currentOffset;
    int64_t reqRequireLen    = loadingRequest.dataRequest.requestedLength;
    
    int64_t startSegment  = [CJAVResourceInfo segmentWithOffset:reqCurrentOffset];
    int64_t endSegment    = [CJAVResourceInfo segmentWithOffset:reqCurrentOffset Length:reqRequireLen];
    
    NSLog(@"loadrequest: reqOffset = %lld, reqLength = %lld, startSegment = %lld, endSegment = %lld",
          reqCurrentOffset, reqRequireLen, startSegment, endSegment);
    
    
    
    CJAVResourceInfoStatus status = self.loaderTask.curResourceInfo.status;
    switch (status) {
        case CJAVResourceInfoStatus_None:
        {
            
            NSLog(@"文件没有任何缓存, 请求所有数据");
            
            //文件没有任何缓存
            [self.loaderTask doLoadTaskWithDataBlockArr:nil LoadingRequest:loadingRequest];
            break;
        }
        case CJAVResourceInfoStatus_Whole:
        {
            NSLog(@"文件已全部缓存, 可以直接finish该请求");
            
            //媒体文件已全部缓存
            [self responseWholeDataForRequest:loadingRequest];
            break;
        }
        case CJAVResourceInfoStatus_Partial:
        {
            
            
            //文件缓存部分数据
            BOOL isCached = [self.loaderTask.curResourceInfo isCachedWithStartSegment:startSegment EndSegment:endSegment];
            if (isCached) {
                
                
                NSLog(@"文件部分缓存, 该请求的数据都已缓存，可直接返回数据");
                
                //所请求的数据段已缓存，可直接返回数据
                [self responseWholeDataForRequest:loadingRequest];
            } else {

                //发起请求
                NSMutableArray *blockArr =
                [self.loaderTask.curResourceInfo calcRequestBlockWithStartSegment:startSegment];
                [self.loaderTask doLoadTaskWithDataBlockArr:blockArr LoadingRequest:loadingRequest];
                

                NSLog(@"文件部分缓存, 该请求的数据还有这些没被缓存:\n");
                for (CJAVResourceDataBlock *block in blockArr) {
                    NSLog(@"bock.startSegment = %lld, endSegment = %lld", block.startSegment, block.endSegment);
                }
                
            }
            
            break;
        }

        default:
            break;
    }
}



- (void)processPendingRequests {
    //已完成的请求数组
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    
    for (AVAssetResourceLoadingRequest *loadingRequest in self.pendingRequestArr)
    {
        //对每次请求加上长度，文件类型等信息
        [self fillContentInformation:loadingRequest.contentInformationRequest];
        
        //判断该请求的数据是否已缓存
        BOOL didRespondCompletely = [self respondWithDataForRequest:loadingRequest.dataRequest];
        if (didRespondCompletely) {
            //已缓存，把此次请求放进请求完成的数组
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
            
           NSLog(@"finish_request__: %@\n\n", loadingRequest);
            
        }
    }
    
    //删除已完成的所有请求
    [self.pendingRequestArr removeObjectsInArray:requestsCompleted];
    
    
    NSLog(@"pendingRequestArr.count = %tu", self.pendingRequestArr.count);
    
}


- (void)fillContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest {
    NSString *contentType = self.loaderTask.curResourceInfo.contentType;
    int64_t contentLen  = self.loaderTask.curResourceInfo.contentLength;
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(contentType), NULL);
    
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentType   = CFBridgingRelease(type);
    contentInformationRequest.contentLength = contentLen;
}


- (void)responseWholeDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
   
    NSString *path = [CJAVResourceCache cachedPathByURL:self.loaderTask.curResourceInfo.url];
    
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:nil];
    
    //填充contentInformation数据
    [self fillContentInformation:loadingRequest.contentInformationRequest];
    
    int64_t reqCurrentOffset  = loadingRequest.dataRequest.currentOffset;
    int64_t reqRequireLen     = loadingRequest.dataRequest.requestedLength;
    NSRange range               = NSMakeRange((NSUInteger)reqCurrentOffset, (NSUInteger)reqRequireLen);
    
    [loadingRequest.dataRequest respondWithData:[filedata subdataWithRange:range]];
    [loadingRequest finishLoading];
    
    NSLog(@"finish_request__: %@\n\n", loadingRequest);

    //从未决请求数组中删除
    [self.pendingRequestArr removeObject:loadingRequest];
    
    
    
    NSLog(@"pendingRequestArr.count = %tu", self.pendingRequestArr.count);
}


- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingDataRequest *)dataRequest {

    NSString *path = [CJAVResourceCache cachedPathByURL:self.loaderTask.curResourceInfo.url];
    NSData *filedata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:nil];
    
    
    //判断该请求所请求的数据块是否已缓存
    int64_t reqRequireLen     = dataRequest.requestedLength;
    int64_t reqCurrentOffset  = dataRequest.currentOffset;
    reqRequireLen -= (dataRequest.currentOffset - dataRequest.requestedOffset);
    
    int64_t startSegment  = [CJAVResourceInfo segmentWithOffset:reqCurrentOffset];
    int64_t endSegment    = [CJAVResourceInfo segmentWithOffset:reqCurrentOffset Length:reqRequireLen];
    
    BOOL didRespondFully = NO;
    BOOL isCached = [self.loaderTask.curResourceInfo isCachedWithStartSegment:startSegment EndSegment:endSegment];
    if (isCached) {

        NSRange range = NSMakeRange((NSUInteger)reqCurrentOffset, (NSUInteger)reqRequireLen);
        [dataRequest respondWithData:[filedata subdataWithRange:range]];
        
        NSLog(@"response___loadingRequest: currentOffset = %lld, len = %lld", reqCurrentOffset, reqRequireLen);
        didRespondFully = YES;

    } else {
    
        int64_t lastSegment = -1;
        for (int64_t i = startSegment; i <= endSegment; ++i) {
            if (![self.loaderTask.curResourceInfo.segmentSet containsObject:@(i)]) {
                lastSegment = i;
            } else {
                break;
            }
        }
        
        if (lastSegment >= startSegment) {
            
            int64_t lastOffset = (lastSegment + 1) * [CJAVResourceInfo segmentLength];
            NSRange range = NSMakeRange((NSUInteger)reqCurrentOffset, (NSUInteger)(lastOffset - reqCurrentOffset));

            NSLog(@"response___loadingRequest: currentOffset = %tu, len = %tu", range.location, range.length);
            [dataRequest respondWithData:[filedata subdataWithRange:range]];
            didRespondFully = NO;
 
        }
    }

    return didRespondFully;
}




@end
