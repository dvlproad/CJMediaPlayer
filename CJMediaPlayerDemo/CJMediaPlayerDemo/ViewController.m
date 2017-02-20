//
//  ViewController.m
//  MTMediaPlayer
//
//  Created by chacha on 3/7/16.
//  Copyright © 2016 meitu. All rights reserved.
//

#import "PureLayout.h"

#import "ViewController.h"
#import "VideoViewController.h"
#import "VideoListController.h"
#import "DemoNavigationController.h"

//#import "MPMediaPlayer.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *buttonVideo;
//@property (nonatomic, strong) MPMediaPlayer *mediaPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.buttonVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonVideo setTitle:@"Video" forState:UIControlStateNormal];
    [self.buttonVideo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonVideo.frame = CGRectMake(100.0f, 100.0f, 80.0f, 60.0f);
    [self.buttonVideo addTarget:self action:@selector(doButtonEnterVideoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonVideo];
    
    UIButton *tableViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:tableViewButton];
    [tableViewButton setTitle:@"Video List" forState:UIControlStateNormal];
    [tableViewButton addTarget:self action:@selector(jumpToTableView:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
    [tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 164, 150, 200)];
//    view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:view];
//    self.mediaPlayer = [[MPMediaPlayer alloc]init];
//    self.mediaPlayer.url = [NSURL URLWithString:@"https://mvvideo5.meitudata.com/56de8739217626422.mp4"];
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
    VideoListController *listVC = [[VideoListController alloc] init];
    DemoNavigationController *containerVC = [[DemoNavigationController alloc] initWithRootViewController:listVC];
    [self presentViewController:containerVC animated:YES completion:nil];
}

@end
