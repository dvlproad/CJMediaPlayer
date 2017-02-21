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
    

    NSURL *url2 = [NSURL URLWithString:@"http://mvvideo2.meitudata.com/56b810ecc4e5c693.mp4"];
    [[TBPlayer sharedInstance] playWithUrl:url2 showView:self.showView];

}




@end
