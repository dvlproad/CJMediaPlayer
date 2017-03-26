//
//  CJFileModel.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 2016/3/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "CJFileModel.h"

@interface CJFileModel ()

@property (nonatomic, assign, readonly) CJFileSourceType sourceType;

@end



@implementation CJFileModel

#pragma mark - 初始化
- (instancetype)initWithNetworkAbsoluteUrl:(NSString *)networkAbsoluteUrl
{
    self = [super init];
    if (self) {
        _networkAbsoluteUrl = networkAbsoluteUrl;
        _sourceType = CJFileSourceTypeNetwork;
    }
    
    return self;
}

- (instancetype)initWithLocalRelativePath:(NSString *)localRelativePath
                               sourceType:(CJFileSourceType)sourceType
{
    self = [super init];
    if (self) {
        _localRelativePath = localRelativePath;
        _sourceType = sourceType;
    }
    
    return self;
}

- (instancetype)initWithLocalAbsolutePath:(NSString *)localAbsolutePath
                               sourceType:(CJFileSourceType)sourceType
{
    self = [super init];
    if (self) {
        NSString *localRelativePath = nil;
        switch (sourceType) {
            case CJFileSourceTypeLocalSandbox:
            {
                NSString *homeDirectory = NSHomeDirectory();
                if ([localAbsolutePath hasPrefix:homeDirectory]) {
                    localRelativePath = [localAbsolutePath substringFromIndex:homeDirectory.length+1];
                }
                break;
            }
            case CJFileSourceTypeLocalBundle:
            {
                NSString *homeDirectory = [[NSBundle mainBundle] bundlePath];
                if ([localAbsolutePath hasPrefix:homeDirectory]) {
                    localRelativePath = [localAbsolutePath substringFromIndex:homeDirectory.length+1];
                }
                break;
            }
            default:
            {
                break;
            }
        }
        
        _localRelativePath = localRelativePath;
        _sourceType = sourceType;
        
    }
    
    return self;
}


#pragma mark - Getter
/** 完整的描述请参见文件头部 */
- (NSURL *)absoluteURL {
    NSURL *absoluteURL = nil;
    switch (self.sourceType) {
        case CJFileSourceTypeLocalSandbox:
        {
            NSString *homeDirectory = NSHomeDirectory();
            NSString *localAbsolutePath = [homeDirectory stringByAppendingPathComponent:self.localRelativePath];
            
            localAbsolutePath = [localAbsolutePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            absoluteURL = [NSURL fileURLWithPath:localAbsolutePath];   //fileURLWithPath
            break;
        }
        case CJFileSourceTypeLocalBundle:
        {
            NSString *homeDirectory = [[NSBundle mainBundle] bundlePath];
            NSString *localAbsolutePath = [homeDirectory stringByAppendingPathComponent:self.localRelativePath];
            
            //localAbsolutePath = [localAbsolutePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //错误，不能执行此句，否则中文名字图片会错误
            absoluteURL = [NSURL fileURLWithPath:localAbsolutePath];   //fileURLWithPath
            break;
        }
        case CJFileSourceTypeNetwork:
        {
            NSString *networkAbsoluteUrl = [self.networkAbsoluteUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            absoluteURL = [NSURL URLWithString:networkAbsoluteUrl];   //URLWithString
            break;
        }
        default:
        {
            break;
        }
    }
    
    return absoluteURL;
}

//- (UIImage *)image {
//    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];//异步加载
//    if (imageData == nil) {
//        NSLog(@"Error:视频预览图加载失败");
//    }
//    UIImage *videoPreviewImage = [UIImage imageWithData:imageData];
//    return videoPreviewImage;
//}
//


@end
