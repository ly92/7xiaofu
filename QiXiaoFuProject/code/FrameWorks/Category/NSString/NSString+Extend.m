//
//  NSString+Extend.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/19.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)


//添加一个方法: 不区分大小写比较字符串
-(int)caseCompareString:(NSString *)str1
{
    
    NSString * str2 = [self copy];
    
    str1 = [str1 uppercaseString];
    str2 = [str2 uppercaseString];
    return [str1 compare:str2];
}


//翻转字符串
//  "hello world"
//  "dlrow olleh"
//思路: 创建一个新的空字符串, 每次从原字符串中取出一个字符,附加的新字符串的后面, 最后返回新字符串
- (NSString*) reverseString
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    NSString * s = [self copy];
    //每次从原字符串中取出一个字符,附加的新字符串的后面
    long len=[s length];
    for (long i=len-1; i>=0; i--) {
        unichar c = [s characterAtIndex:i];
        [mstr appendFormat:@"%C",c];
    }
    return mstr;
}


//统计子串出现的次数
//"jin tian tian qi hai xing o!"
//  统计"tian"
//思路: 每次查找tian字符串,查找到次数+1, 并去掉找到的tian
//              如果找不到, 说明找完了
- (NSInteger) stringSubstringCount:(NSString *)substr;
{
    NSString * s = [self copy];
    NSInteger count=0;
    NSRange range;
    //  while((c=getchar()) != '\n')
    while ((range = [s rangeOfString:substr]).location != NSNotFound ) {
        //说明找到了一个
        count++;
        //去掉已经查找过的部分
        s = [s  substringFromIndex:range.location+range.length];
    }
    
    return count;
}





@end
