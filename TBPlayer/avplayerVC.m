//
//  avplayerVC.m
//  TBPlayer
//
//  Created by qianjianeng on 16/2/27.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "avplayerVC.h"
#import "TBPlayer.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface avplayerVC ()

@property (nonatomic, strong) TBPlayer *player;
@property (nonatomic, strong) UIView *showView;
@end

@implementation avplayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showView = [[UIView alloc] init];
    self.showView.backgroundColor = [UIColor redColor];
    self.showView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.showView];
    
    
    
//    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *movePath =  [document stringByAppendingPathComponent:@"保存数据.mp4"];
//    NSURL *localURL = [NSURL fileURLWithPath:movePath];
    

//    NSString *Url  = @"http://tb-video.bdstatic.com/tieba-smallvideo/86_671b0a2e1eab73e48eb3aafcbae5dcaa.mp4";
    NSString *Url = @"https://v11-default.365yg.com/1c7883e48a1eafa0718e81ba60366c6e/67a78ff5/video/tos/cn/tos-cn-ve-15/ok492pE6eFAoNnDnAv3GD4gIDfA7FAQxqBAnwE/?a=2011&ch=0&cr=0&dr=0&cd=0%7C0%7C0%7C0&cv=1&br=2371&bt=2371&cs=0&ds=3&ft=aT_7TQQqUYqfJEZPo0OW_QYaUqiX5DH4oVJE6BUgJvPD-Ipz&mime_type=video_mp4&qs=0&rc=Ozw2OTQ6Z2g8ODxoPDVnZkBpM2t0OHU5cmtqeDMzNGkzM0A2YGM0Li82XjExYy5jMzQzYSNwaXMtMmRrb2dgLS1kLTBzcw%3D%3D&btag=80000e00010000&dy_q=1739030996&feature_id=aa7df520beeae8e397df15f38df0454c&l=202502090009563198B7753D5397379997";
    NSURL *URL = [NSURL URLWithString:Url];
    [[TBPlayer sharedInstance] playWithUrl:URL showView:self.showView];

}




@end
