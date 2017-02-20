//
//  MTPlayerNetwork.h
//  MeituFrameWork
//
//  Created by JoyChiang on 13-8-30.
//  Copyright (c) 2013年 JoyChiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPlayerNetwork : NSObject

/**
*	@brief	判断当前是否有网络
*
*	@return	有网络返回YES，否则返回NO
*/
+ (BOOL)isNetworkAvailable;

/**
*	@brief	当前是否处于wifi网络状态
*
*	@return	处于wifi网络状态下返回YES，否则返回NO
*/
+ (BOOL)isNetworkWIFI;

/**
*	@brief	当前是否处于3G网络状态
*
*	@return	处于3G网络状态下返回YES，否则返回NO
*/
+ (BOOL)isNetworkWWAN;

/**
*	@brief	检测当前网络是否可用
*
*	@param 	showAlert 	当不可用时是否弹出提示
*
*	@return	当前网络可用返回YES，否则返回NO
*/
+ (BOOL)checkNetworkAvailability:(BOOL)showAlert;

@end