//
//  CJPlayerViewController.h
//  MTMediaPlayer
//
//  Created by lichq on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJPlayerController.h"

@interface CJPlayerViewController : UIViewController

@property (nonatomic, weak) UIView *videoPlayerView;

- (instancetype)initWithPlayerController:(CJPlayerController *)playerController;

- (void)presentFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion;

@end
