//
//  NSString+Validate.h
//  CJFoundationDemo
//
//  Created by lichq on 6/25/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

//源自：iOS - 正则表达式判断邮箱、身份证..是否正确：http://www.2cto.com/kf/201311/256494.html

//邮箱
- (BOOL)validateEmail;

//手机号码验证
- (BOOL)validateMobile;

//车牌号验证
- (BOOL)validateCarNo;

//车型
- (BOOL)validateCarType;

//用户名
- (BOOL)validateUserName;

//密码
- (BOOL)validatePassword;

//昵称
- (BOOL)validateNickname;

//身份证号
- (BOOL)validateIdentityCard;

@end
