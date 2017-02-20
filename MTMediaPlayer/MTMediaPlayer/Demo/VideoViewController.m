//
//  VideoViewController.m
//  MTMediaPlayer
//
//  Created by dvlproad on 3/7/16.
//  Copyright © 2016 dvlproad. All rights reserved.
//

#import "VideoViewController.h"

#import "FrameAccessor.h"
#import "CJPlayerController.h"
#import "PureLayout.h"

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
//    NSURL *URL = [NSURL URLWithString:@"http://beauty1.meitudata.com/b5efb8ebc7716683808971fd9f6fd7f5.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"http://mvvideo4.meitudata.com/5664b438390f77375.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"https://mvvideo5.meitudata.com/550687c96ffd28130.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"http://mvvideo4.meitudata.com/5664b438390f77375.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"http://mvvideo5.meitudata.com/56d9292d529c48134.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"https://mvvideo5.meitudata.com/56de8739217626422.mp4"];
//    NSURL *URL = [NSURL URLWithString:@"https://mvvideo5.meitudata.com/56de8b2d38a6f8873.mp4"];
    NSURL *URL = [NSURL URLWithString:@"http://mvvideo5.meitudata.com/56d9292d529c48134.mp4"];
    [self.zhiPlayerView setURL:URL
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
