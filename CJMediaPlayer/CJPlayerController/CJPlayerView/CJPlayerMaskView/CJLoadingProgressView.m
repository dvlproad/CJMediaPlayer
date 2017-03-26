//
//  CJLoadingProgressView.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJLoadingProgressView.h"

@implementation CJLoadingProgressView

/**
 * 重载init来做一些初始化的事情
 */
- (instancetype)init {
    if (self = [super init]) {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i < 16; i++) {
            
            NSString *fileName = [NSString stringWithFormat:@"cjLoadingAnimation%d", i];
            UIImage *pic = [UIImage imageNamed:fileName];
            [images addObject:pic];
        }
        
        self.image = images[0];
        self.animationDuration = 1.0f;
        self.animationImages = images;
    }
    
    return self;
}

@end
