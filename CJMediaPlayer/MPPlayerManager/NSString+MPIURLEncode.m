//
//  NSString+MPIURLEncode.m
//  MeituMV
//
//  Created by WangLe on 15/8/21.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

#import "NSString+MPIURLEncode.h"

static NSString * const CharactersToBeEscapedInQueryString = @"!*'\"();:@&=+$,/?%#[]% ";

@implementation NSString (MPIURLEncode)

- (NSString *)mpi_URLEncode {
    return [self URLEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)mpi_URLDecode {
    return [self URLDecodeUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Private

- (NSString *)URLEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)CharactersToBeEscapedInQueryString,
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)URLDecodeUsingEncoding:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
