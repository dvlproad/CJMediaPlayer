//
//  NSString+Attributed.m
//  CJFoundationDemo
//
//  Created by lichq on 7/21/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NSString+Attributed.h"

@implementation NSString (Attributed)

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
