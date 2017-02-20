//
//  NSString+MPIURLEncode.h
//  MeituMV
//
//  Created by WangLe on 15/8/21.
//  Copyright (c) 2015年 美图网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MPIURLEncode)

/**
 *  对字符串做HTTP编码
 *
 *  @param string 字符串
 *
 *  @return 编码后的HTTP字符串
 */
- (NSString *)mpi_URLEncode;

/**
 *  对字符串做HTTP编码
 *
 *  @param string 字符串
 *
 *  @return 编码后的HTTP字符串
 */
- (NSString *)mpi_URLDecode;

@end
