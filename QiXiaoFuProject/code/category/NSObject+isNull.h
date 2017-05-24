//
//  NSObject+isNull.h
//  YiWangClient
//
//  Created by DarkAngel on 16/1/22.
//  Copyright © 2016年 一网全城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (isNull)
/*!
 *   判断是否为空,有问题，已废弃
 *
 *  @return YES or NO
 */
//- (BOOL)yw_isNull;//这种方式有问题 空指针调用判断会出错


/**
 判断是否为空,修正后的判断

 @return YES or NO
 */
-(BOOL)yw_notNull;
@end
