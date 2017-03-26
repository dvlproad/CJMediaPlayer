//
//  NSString+CJCalculateSize.m
//  CJFoundationDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "NSString+CJCalculateSize.h"

@implementation NSString (CJCalculateSize)

- (CGFloat)getTextHeightByTextFont:(UIFont *)textFont
                      maxTextWidth:(CGFloat)maxTextWidth {
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(maxTextWidth, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:textFont}
                                         context:nil];
    return CGRectGetHeight(textRect)+2;
}

- (CGFloat)getTextWidthByTextFont:(UIFont *)textFont
                   maxTextHeight:(CGFloat)maxTextHeight {

    NSDictionary *attribute = @{NSFontAttributeName:textFont};
    CGSize size = CGSizeMake(MAXFLOAT, maxTextHeight);
    
    CGRect textRect = [self boundingRectWithSize:size
                                         options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    
    return CGRectGetWidth(textRect);
}

@end
