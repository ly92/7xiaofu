//
//  NSArray+Utils.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "NSArray+Utils.h"

@implementation NSArray (Utils)



#pragma mark  数组转字符串
-(NSString *)string{
    
    if(self==nil || self.count==0) return @"";
    
    NSMutableString *str=[NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,",obj];
    }];
    
    //删除最后一个','
    NSString *strForRight = [str substringWithRange:NSMakeRange(0, str.length-1)];
    
    return strForRight;
}
/*!
 *  @author fhj, 15-07-28 10:07:15
 *
 *  @brief  把数组根据 Str 分割成字符串
 */

- (NSString *)componentsJoinedByString1:(NSString *)str{
    return [self componentsJoinedByString:str];
}



#pragma mark  数组比较
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array{
    
    NSSet *set1=[NSSet setWithArray:self];
    
    NSSet *set2=[NSSet setWithArray:array];
    
    return [set1 isEqualToSet:set2];
}


/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray{
    
    NSMutableArray *intersectionArray=[NSMutableArray array];
    
    if(self.count==0) return nil;
    if(otherArray==nil) return nil;
    
    //遍历
    for (id obj in self) {
        
        if(![otherArray containsObject:obj]) continue;
        
        //添加
        [intersectionArray addObject:obj];
    }
    
    return intersectionArray;
}



/**
 *  数据计算差集
 */
-(NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray{
    
    if(self==nil) return nil;
    if(otherArray==nil) return self;
    NSMutableArray *minusArray=[NSMutableArray arrayWithArray:self];
    //遍历
    for (id obj in otherArray) {
        if(![self containsObject:obj]) continue;
        //添加
        [minusArray removeObject:obj];
    }
    return minusArray;
}




- (NSData *)JSONData_Ext
{
    
    //    if (![NSJSONSerialization isValidJSONObject:self]) {
    //        return nil;
    //    }
    NSError * error=nil;
    NSData * data=nil;
    NSException * exce=nil;
    @try {
        ///这里的options参数为kNilOptions,转换为json的时候不添加\n格式化换行
        ///当该参数为NSJSONWritingPrettyPrinted时，添加\n格式化换行，方便阅读
        data= [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    }
    @catch (NSException *exception) {
        exce=exception;
    }
    @finally {
        
    }
    
    if (error || exce) {
        //@throw exce;
        return nil;
    }
    
    return data;
    
}

- (NSString *)JSONString_Ext
{
    
    NSData * data=[self JSONData_Ext];
    if (data) {
        __autoreleasing  NSString *  string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}








@end
