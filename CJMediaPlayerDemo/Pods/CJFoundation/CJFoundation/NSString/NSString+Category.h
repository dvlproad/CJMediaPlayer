//
//  NSString+Category.h
//  CJFoundationDemo
//
//  Created by lichq on 14-12-16.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "NSString+Validate.h"

@interface NSString (Category)

//将NSString转化成标准日期NSDate
- (NSDate *)standDate;

//base64转成UIImage
- (UIImage *)base64ToImage;

- (NSAttributedString *)attributedSubString1:(NSString *)string1 font1:(UIFont *)font1 color1:(UIColor *)color1 subString2:(NSString *)string2 font2:(UIFont *)font2 color2:(UIColor *)color2;

- (NSAttributedString *)attributedSubString1:(NSString *)string1 font1:(UIFont *)font1 color1:(UIColor *)color1 udlin1:(BOOL)unlin1 subString2:(NSString *)string2 font2:(UIFont *)font2 color2:(UIColor *)color2 udlin2:(BOOL)unlin2;

- (NSAttributedString *)attributedSubString:(NSString *)string font:(UIFont *)font color:(UIColor *)color udline:(BOOL)unline;

@end
