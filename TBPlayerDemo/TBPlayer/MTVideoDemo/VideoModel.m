//
//  VideoModel.m
//  TBPlayer
//
//  Created by dvlproad on 16/3/23.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (instancetype)initWithVideoUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        
        self.videoUrl = [url copy];
    }
    return self;
}


@end
