//
//  UtilsMacro.h
//  Pomelo
//
//  Created by dq Chen on 15/5/19.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

// 定义nslog 发布 release 版本自动屏蔽

#ifndef DEBUG_ZHI

#if USE_API_SETTING
    #define DEBUG_ZHI 1
#else
    #define DEBUG_ZHI 0
#endif

#if DEBUG_ZHI
	#define MTPlayerLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#else
	#define MTPlayerLog(fmt, ...) /* */
#endif

//软件版本号
#define SOFTWARE_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define MTScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define MTScreenHeight [[UIScreen mainScreen] bounds].size.height

#endif	// #ifndef DEBUG_ZHI
