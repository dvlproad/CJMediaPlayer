//
//  MTAVUtil.h
//  TestTableView
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAVUtil : NSObject


/**
 *  MD5加密
 *
 *  @param string 明文
 *
 *  @return 密文
 */
+ (NSString *)md5Sum:(NSString *)string;


/**
 *  判断URL是否为伪URL
 *
 *  @param url
 *
 *  @return 判断结果(yes or no)
 */
+ (BOOL)isFakeUrl:(NSURL *)url;


/**
 *  生成伪URL
 *
 *  @param realUrl 真实的URL
 *
 *  @return 伪URL
 */
+ (NSURL *)fakeUrl:(NSURL *)realUrl;



/**
 *  还原成真实URL
 *
 *  @param fakeUrl 伪URL
 *
 *  @return 真实的URL
 */
+ (NSURL *)realUrl:(NSURL *)fakeUrl;


/**
 *  清空缓存
 */
- (void)cleanCache;

@end
