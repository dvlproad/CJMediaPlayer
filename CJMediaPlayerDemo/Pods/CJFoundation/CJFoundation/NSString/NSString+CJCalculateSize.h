//
//  NSString+CJCalculateSize.h
//  CJFoundationDemo
//
//  Created by lichq on 7/9/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (CJCalculateSize)

- (CGFloat)getTextHeightByTextFont:(UIFont *)textFont
                      maxTextWidth:(CGFloat)maxTextWidth;

- (CGFloat)getTextWidthByTextFont:(UIFont *)textFont
                    maxTextHeight:(CGFloat)maxTextHeight;

@end
