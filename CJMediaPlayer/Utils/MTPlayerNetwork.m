//
//  MTNetwork.m
//  MeituFrameWork
//
//  Created by JoyChiang on 13-8-30.
//  Copyright (c) 2013年 JoyChiang. All rights reserved.
//

#import "MTPlayerNetwork.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>

@implementation MTPlayerNetwork

/**
*	@brief	判断当前是否有网络
*
*	@return	有网络返回YES，否则返回NO
*/
+ (BOOL)isNetworkAvailable {
    return [Reachability reachabilityForInternetConnection].isReachable;
}

/**
*	@brief	当前是否处于wifi网络状态
*
*	@return	处于wifi网络状态下返回YES，否则返回NO
*/
+ (BOOL)isNetworkWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

/**
*	@brief	当前是否处于3G网络状态
*
*	@return	处于3G网络状态下返回YES，否则返回NO
*/
+ (BOOL)isNetworkWWAN {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}

/**
*	@brief	检测当前网络是否可用
*
*	@param 	showAlert 	当不可用时是否弹出提示
*
*	@return	当前网络可用返回YES，否则返回NO
*/
+ (BOOL)checkNetworkAvailability:(BOOL)showAlert {
    BOOL available = [MTPlayerNetwork isNetworkAvailable];
    if (!available && showAlert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:NSLocalizedString(@"当前无网络可以使用，请确保您已经开启GPRS或WIFI", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }

    return available;
}

@end