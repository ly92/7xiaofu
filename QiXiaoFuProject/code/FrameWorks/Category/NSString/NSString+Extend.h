//
//  NSString+Extend.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/19.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)


//添加一个方法: 不区分大小写比较字符串
-(int)caseCompareString:(NSString *)str1;
//翻转字符串
- (NSString*) reverseString;

//统计子串出现的次数
- (NSInteger) stringSubstringCount:(NSString *)substr;
@end
