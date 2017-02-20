//
//  MPLoadingProgressView.m
//  Zhi
//
//  Created by dvlproad on 2/24/16.
//  Copyright © 2016 dvlproad. All rights reserved.
//

#import "MPLoadingProgressView.h"

@implementation MPLoadingProgressView

/**
 * 重载init来做一些初始化的事情
 */
- (instancetype)init {
    if (self = [super init]) {
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i < 16; i++) {
            
            NSString *fileName = [NSString stringWithFormat:@"loading_anim_%d", i];
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
