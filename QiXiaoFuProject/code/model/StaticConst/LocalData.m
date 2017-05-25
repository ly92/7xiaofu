//
//  LocalData.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/25.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "LocalData.h"

#define UD [NSUserDefaults standardUserDefaults]

//技术领域
#define sectors_key [NSString stringWithFormat:@"service_sectors_%@",kUserId]

@implementation LocalData
//技术领域
+ (void)setUpService_sector:(NSString *)service_sectors{
    if ([service_sectors yw_notNull]){
        [UD setObject:service_sectors forKey:sectors_key];
    }
}
+ (NSString *)getService_sector{
    NSString *str = [UD valueForKey:sectors_key];
    if ([str yw_notNull]){
        return str;
    }
    return @" ";
}
@end
