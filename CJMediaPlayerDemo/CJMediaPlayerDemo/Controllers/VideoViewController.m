//
//  VideoViewController.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "VideoViewController.h"
#import "CJPlayerController.h"
#import <PureLayout/PureLayout.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoViewController ()

@property (nonatomic, strong) UIButton *buttonCancel;
@property (nonatomic, strong) CJPlayerController *zhiPlayerView; //视频播放
@property (nonatomic, assign) BOOL didUpdateViewConstraints;


@end


@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}

- (void)setupView {
    self.buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.buttonCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonCancel.frame = CGRectMake(0.0f, 0.0f, 80.0f, 60.0f);
    [self.buttonCancel addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonCancel];
    
    if (!self.zhiPlayerView)
    {
        self.zhiPlayerView = [[CJPlayerController alloc]init];
        [self.zhiPlayerView.view setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:self.zhiPlayerView.view];
        self.zhiPlayerView.view.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiPlayerView.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:50]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiPlayerView.view
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1
                                                               constant:20]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiPlayerView.view
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:-20]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.zhiPlayerView.view
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:-50]];
    }

    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.zhiPlayerView.fullscreen) {
        return;
    }

    //下面的URL为测试URL
    NSURL *URL = [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"];
    [self.zhiPlayerView setVideoURL:URL
                         coverImage:nil
                          needCache:YES
                           maskType:CJPlayerMaskViewTypeNormal];

    [self.zhiPlayerView play];
}


#pragma mark - Action

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
