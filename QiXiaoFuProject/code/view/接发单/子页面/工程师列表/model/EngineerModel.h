//
//  EngineerModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EngineerModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *service_sector;

@property (nonatomic, copy) NSString * working_year;

@property (nonatomic, copy) NSString *member_truename;

@property (nonatomic, strong) NSArray<NSString *> *tack_citys;

@property (nonatomic, copy) NSString *member_id;

@property (nonatomic, copy) NSString *member_avatar;

@property (nonatomic, copy) NSString *service_stime;

@property (nonatomic, copy) NSString *service_etime;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *lng;

@end

