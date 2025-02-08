//
//  VideoHomeViewController.m
//  CJMediaPlayerDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "VideoHomeViewController.h"
#import <CQDemoKit/CJUIKitToastUtil.h>
#import <CQDemoKit/CJUIKitAlertUtil.h>

#import "VideoViewController.h"
#import "VideoListViewController.h"
#import "DemoNavigationController.h"
#import "VideoArrayViewController.h"
#import "avplayerVC.h"

@interface VideoHomeViewController ()

@property (nonatomic, strong) dispatch_queue_t commonConcurrentQueue; //创建并发队列

@end

@implementation VideoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Encrypt首页", nil);
    
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    
    // 单个视频的播放
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"单个视频的播放";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"单个视频的播放";
            //requestModule.classEntry = [VideoViewController class];
            requestModule.actionBlock = ^{
                VideoViewController *videoVC = [[VideoViewController alloc] init];
                [self presentViewController:videoVC animated:YES completion:nil];
            };
            [sectionDataModel.values addObject:requestModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // 视频列表的播放
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"视频列表的播放";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"视频列表的播放";
            //requestModule.classEntry = [VideoListViewController class];
            requestModule.actionBlock = ^{
                VideoListViewController *listVC = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
                DemoNavigationController *containerVC = [[DemoNavigationController alloc] initWithRootViewController:listVC];
                [self presentViewController:containerVC animated:YES completion:nil];
            };
            [sectionDataModel.values addObject:requestModule];
        }
        
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    // avplayerVC
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"avplayerVC";
        
        {
            CQDMModuleModel *requestModule = [[CQDMModuleModel alloc] init];
            requestModule.title = @"avplayerVC";
            //requestModule.classEntry = [VideoListViewController class];
            requestModule.actionBlock = ^{
            //    VideoArrayViewController *viewController = [[VideoArrayViewController alloc] init];
            //    [self.navigationController pushViewController:viewController animated:YES];
                
                avplayerVC *vc = [[avplayerVC alloc] init];
                [self presentViewController:vc animated:NO completion:nil];
            };
            [sectionDataModel.values addObject:requestModule];
        }
        
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
