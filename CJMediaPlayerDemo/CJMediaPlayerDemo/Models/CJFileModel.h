//
//  CJFileModel.h
//  CJMediaPlayerDemo
//
//  Created by dvlproad on 2016/3/25.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CJFileSourceType) {
    CJFileSourceTypeLocalSandbox = 1,   /**< 本地沙盒文件 */
    CJFileSourceTypeLocalBundle,    /**< 本地Bundle文件 */
    CJFileSourceTypeNetwork,        /**< 网络文件 */
};

@interface CJFileModel : NSObject


@property (nonatomic, copy, readonly) NSString *localRelativePath;/**< 本地相对路径(因为沙盒路径会变) */
//@property (nonatomic, copy, readonly) NSString *localAbsolutePath;/**< 本地绝对路径 */
@property (nonatomic, copy, readonly) NSString *networkAbsoluteUrl;/**< 网络绝对路径(有时会省略前缀) */
@property (nonatomic, copy, readonly) NSURL *absoluteURL;

- (instancetype)initWithNetworkAbsoluteUrl:(NSString *)networkAbsoluteUrl;

- (instancetype)initWithLocalRelativePath:(NSString *)localRelativePath
                               sourceType:(CJFileSourceType)sourceType;

- (instancetype)initWithLocalAbsolutePath:(NSString *)localAbsolutePath
                               sourceType:(CJFileSourceType)sourceType;

@end
