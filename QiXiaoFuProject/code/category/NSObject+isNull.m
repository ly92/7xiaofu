//
//  NSObject+isNull.m
//  YiWangClient
//
//  Created by DarkAngel on 16/1/22.
//  Copyright © 2016年 一网全城. All rights reserved.
//

#import "NSObject+isNull.h"

@implementation NSObject (isNull)
/*!
 *  判断是否为空,有问题，已废弃
 *
 *  @return YES or NO
 */
- (BOOL)yw_isNull
{
    if (self && ![self isEqual:[NSNull null]]) {
        return NO;
    }else{
        return YES;
    }
}
/*!
 *  判断是否为空
 *
 *  @return YES or NO
 */
-(BOOL)yw_notNull
{
    if (self && ![self isEqual:[NSNull null]]) {
        return YES;
    }else{
        return NO;
    }



}


@end
