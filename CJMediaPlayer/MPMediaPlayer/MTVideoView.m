//
//  MPMediaView.m
//  MeituMV
//
//  Created by 张闽 on 15/5/21.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

#import "MTVideoView.h"

@interface MTVideoView ()

@end

@implementation MTVideoView

+ (Class) layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *) player
{
    return [(AVPlayerLayer *) [self layer] player];
}

- (AVPlayerLayer *) playerLayer
{
    return (AVPlayerLayer *) self.layer;
}

- (void) setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *) [self layer] setPlayer:player];
}

@end
