//
//  LocalData.h
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/25.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalData : NSObject
//技术领域
+ (void)setUpService_sector:(NSString *)service_sectors;
+ (NSString *)getService_sector;

//发单信息保存
+ (void)saveSendTaskData:(NSDictionary *)dict;
+ (NSDictionary *)getSendTaskData;
+ (void)removeSendTaskData;

//补单信息保存
+ (void)saveReplaceTaskData:(NSDictionary *)dict;
+ (NSDictionary *)getReplaceTaskData;
+ (void)removeReplaceTaskData;

@end
