//
//  MPMediaView.h
//  MeituMV
//
//  Created by 张闽 on 15/5/21.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MTVideoView : UIView

- (AVPlayerLayer *)playerLayer;

/**
 *  为 MPMediaView 绑定一个 player，MPMediaView 显示 player 下载的视频
 */
- (void)setPlayer:(AVPlayer *)player;

@end
