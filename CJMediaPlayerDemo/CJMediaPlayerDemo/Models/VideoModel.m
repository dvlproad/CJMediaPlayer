//
//  VideoModel.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (UIImage *)image {
    NSURL *absoluteURL = self.firstFrameImageFile.absoluteURL;
    NSData *imageData = [NSData dataWithContentsOfURL:absoluteURL];//异步加载
    if (imageData == nil) {
        NSLog(@"Error:视频预览图加载失败");
    }
    UIImage *videoPreviewImage = [UIImage imageWithData:imageData];
    return videoPreviewImage;
}

- (id)initWithVideoUrl:(NSString *)URL {
    return nil;
}

@end
