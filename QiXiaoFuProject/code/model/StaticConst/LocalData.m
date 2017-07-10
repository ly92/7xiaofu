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
//发单信息保存
#define sendTask_key [NSString stringWithFormat:@"sendTask_key_%@",kUserId]
//补单信息保存
#define raplaceTask_key [NSString stringWithFormat:@"raplaceTask_key_%@",kUserId]


@implementation LocalData
//技术领域
+ (void)setUpService_sector:(NSString *)service_sectors{
    if ([service_sectors yw_notNull]){
        [UD setObject:service_sectors forKey:sectors_key];
        [UD synchronize];
    }
}
+ (NSString *)getService_sector{
    NSString *str = [UD valueForKey:sectors_key];
    if ([str yw_notNull]){
        return str;
    }
    return @" ";
}

//发单信息保存
+ (void)saveSendTaskData:(NSDictionary *)dict{
    if (dict.allKeys.count > 0){
        [UD setObject:dict forKey:sendTask_key];
        [UD synchronize];
    }else{
        [UD setObject:[NSDictionary dictionary] forKey:sendTask_key];
        [UD synchronize];
    }
}
+ (NSDictionary *)getSendTaskData{
    NSDictionary *dict = [UD valueForKey:sendTask_key];
    if (dict.allKeys.count > 0){
        return dict;
    }
    return [NSDictionary dictionary];
}
+ (void)removeSendTaskData{
    [UD setObject:[NSDictionary dictionary] forKey:sendTask_key];
    [UD synchronize];
}


//补单信息保存
+ (void)saveReplaceTaskData:(NSDictionary *)dict{
    if (dict.allKeys.count > 0){
        [UD setObject:dict forKey:raplaceTask_key];
        [UD synchronize];
    }else{
        [UD setObject:[NSDictionary dictionary] forKey:raplaceTask_key];
        [UD synchronize];
    }
}
+ (NSDictionary *)getReplaceTaskData{
    NSDictionary *dict = [UD valueForKey:raplaceTask_key];
    if (dict.allKeys.count > 0){
        return dict;
    }
    return [NSDictionary dictionary];
}
+ (void)removeReplaceTaskData{
    [UD setObject:[NSDictionary dictionary] forKey:raplaceTask_key];
    [UD synchronize];

}
@end
