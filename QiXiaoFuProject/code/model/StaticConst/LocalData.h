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
@end
