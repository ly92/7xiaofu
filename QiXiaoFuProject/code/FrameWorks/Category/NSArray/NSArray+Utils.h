//
//  NSArray+Utils.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

/**
 *  数组转字符串
 */
-(NSString *)string;

/*!
 *  @author fhj, 15-07-28 10:07:15
 *
 *  @brief  把数组根据 Str 分割成字符串
 */

//- (NSString *)componentsJoinedByString:(NSString *)str;


/**
 *  数组比较
 */
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array;


/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray;

/**
 *  数据计算差集
 */
//-(NSArray *)arrayForMinusWithOtherArray1:(NSArray *)otherArray;


/**
 * @brief 字典转换成json的Data类型
 *
 * @return 返回数据对象，失败时返回nil
 */
- (NSData *)JSONData_Ext NS_AVAILABLE(10_7, 5_0);

/**
 * @brief 字典对象转换成json字符串
 *
 * @return 返回字符串，失败时返回nil
 */
- (NSString *)JSONString_Ext NS_AVAILABLE(10_7, 5_0);


@end
