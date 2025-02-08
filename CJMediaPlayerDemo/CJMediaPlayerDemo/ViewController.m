//
//  ViewController.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/21.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "ViewController.h"

#import <PureLayout/PureLayout.h>
#import "VideoViewController.h"
#import "VideoListViewController.h"
#import "DemoNavigationController.h"
#import "VideoArrayViewController.h"
#import "avplayerVC.h"
//#import "CJMediaPlayer.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *buttonVideo;
//@property (nonatomic, strong) CJMediaPlayer *mediaPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"首页", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buttonVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonVideo setTitle:@"单个视频的播放" forState:UIControlStateNormal];
    [self.buttonVideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonVideo.frame = CGRectMake(100.0f, 100.0f, 80.0f, 60.0f);
    [self.buttonVideo addTarget:self action:@selector(doButtonEnterVideoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonVideo];
    
    UIButton *tableViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:tableViewButton];
    [tableViewButton setTitle:@"视频列表的播放" forState:UIControlStateNormal];
    [tableViewButton addTarget:self action:@selector(jumpToTableView:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
    [tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 164, 150, 200)];
//    view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:view];
//    self.mediaPlayer = [[CJMediaPlayer alloc]init];
//    self.mediaPlayer.url = [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4"];
//    [self.mediaPlayer.videoView setFrame:CGRectMake(0, 0, 150, 200)];
//    [view addSubview:self.mediaPlayer.videoView];
//    [self.mediaPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doButtonEnterVideoView:(id)sender
{
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    [self presentViewController:videoVC animated:YES completion:nil];
    
}

- (void)jumpToTableView:(UIButton *)sender {
    VideoListViewController *listVC = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
    DemoNavigationController *containerVC = [[DemoNavigationController alloc] initWithRootViewController:listVC];
    [self presentViewController:containerVC animated:YES completion:nil];
}

- (IBAction)goVideoArrayViewController:(id)sender {
//    VideoArrayViewController *viewController = [[VideoArrayViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    
    avplayerVC *vc = [[avplayerVC alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}



@end
