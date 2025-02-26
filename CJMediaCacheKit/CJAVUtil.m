//
//  CJAVUtil.m
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 16/3/9.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "CJAVUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#import "Cache/CJAVResourceCache.h"


static NSString *fakeSchemePrefix = @"streaming";

@implementation CJAVUtil


#pragma mark - Util



/**
 *  MD5加密
 *
 *  @param string 明文
 *
 *  @return 密文
 */
+ (NSString *)md5Sum:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *strBuffer = [NSMutableString string];
    for (int i = 0; i< CC_MD5_DIGEST_LENGTH; ++i) {
        [strBuffer appendFormat:@"%02x", (unsigned int)digest[i]];
    }
    return strBuffer;
}


/**
 *  判断URL是否为伪URL
 *
 *  @param url  要判断的URL
 *
 *  @return 判断结果(yes or no)
 */
+ (BOOL)isFakeUrl:(NSURL *)url {
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:url resolvingAgainstBaseURL:NO];
    
    NSString *scheme = components.scheme;
    BOOL isFakeScheme = [scheme hasPrefix:fakeSchemePrefix];
    return isFakeScheme;
}



/**
 *  生成伪URL
 *
 *  @param realUrl 真实的URL
 *
 *  @return 伪URL
 */
+ (NSURL *)fakeUrl:(NSURL *)realUrl {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:realUrl resolvingAgainstBaseURL:NO];
    
    NSString *scheme = components.scheme;
    scheme = [fakeSchemePrefix stringByAppendingString:scheme];
    components.scheme = scheme;
    
    return components.URL;
}



/**
 *  还原成真实URL
 *
 *  @param fakeUrl 伪URL
 *
 *  @return 真实的URL
 */
+ (NSURL *)realUrl:(NSURL *)fakeUrl {
    
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:fakeUrl resolvingAgainstBaseURL:NO];
    
    NSString *scheme = components.scheme;
    BOOL isFakeScheme = [scheme hasPrefix:fakeSchemePrefix];
    if (isFakeScheme) {
        scheme = [scheme substringFromIndex:[fakeSchemePrefix length]];
        components.scheme = scheme;
    }
    return components.URL;
}



- (void)cleanCache
{
    [CJAVResourceCache cleanCache];
}


@end
