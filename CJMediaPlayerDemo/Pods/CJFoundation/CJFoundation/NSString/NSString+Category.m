//
//  NSString+Category.m
//  CJFoundationDemo
//
//  Created by lichq on 14-12-16.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

#pragma mark - 将NSString转化成标准日期NSDate
- (NSDate *)standDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; //解决NSString转NSDate差8小时的问题
    
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

#pragma mark - base64转成UIImage
- (UIImage *)base64ToImage{
    NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage    = [UIImage imageWithData:_decodedImageData];
    NSLog(@"===Decoded image size: %@", NSStringFromCGSize(_decodedImage.size));
    return _decodedImage;
//    return [UIImage imageNamed:@"icon.png"];
}

- (NSAttributedString *)attributedSubString1:(NSString *)string1 font1:(UIFont *)font1 color1:(UIColor *)color1 subString2:(NSString *)string2 font2:(UIFont *)font2 color2:(UIColor *)color2{
    
    return [self attributedSubString1:string1 font1:font1 color1:color1 udlin1:NO subString2:string2 font2:font2 color2:color2 udlin2:NO];
}


- (NSAttributedString *)attributedSubString1:(NSString *)string1 font1:(UIFont *)font1 color1:(UIColor *)color1 udlin1:(BOOL)unlin1 subString2:(NSString *)string2 font2:(UIFont *)font2 color2:(UIColor *)color2 udlin2:(BOOL)unlin2{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    NSRange rang1 = [self rangeOfString:string1];
    if (rang1.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:font1 range:rang1];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color1 range:rang1];
        
        if (unlin1) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang1];
        }
    }
    
    NSRange rang2 = [self rangeOfString:string2];
    if (rang2.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:font2 range:rang2];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color2 range:rang2];
        
        if (unlin2) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang2];
        }
    }
    
    return attributedString;
}


- (NSAttributedString *)attributedSubString:(NSString *)string font:(UIFont *)font color:(UIColor *)color udline:(BOOL)unline{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    
    NSRange range = [self rangeOfString:string];
    if (range.location != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName value:font range:range];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        if (unline) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        }
    }
    
    return attributedString;
}


@end
