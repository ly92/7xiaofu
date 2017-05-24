//
//  ChongSendOrderModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChongSendOrderModel : NSObject

@property (nonatomic, copy) NSString *top_price;

@property (nonatomic, copy) NSString *bill_desc;

@property (nonatomic, copy) NSString *top_last_day;

@property (nonatomic, strong) NSArray <NSString *>*image;

@property (nonatomic, copy) NSString *service_price;

@property (nonatomic, copy) NSString *lng;

@property (nonatomic, copy) NSString *service_mod;

@property (nonatomic, copy) NSString *other_service_sector;

@property (nonatomic, copy) NSString *service_sector;

@property (nonatomic, copy) NSString *other_service_brand;

@property (nonatomic, copy) NSString *other_service_mod;

@property (nonatomic, copy) NSString *service_etime;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *service_city;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *service_brand;

@property (nonatomic, copy) NSString *service_form;

@property (nonatomic, copy) NSString *lat;

@property (nonatomic, copy) NSString *service_address;

@property (nonatomic, copy) NSString *top_day;

@property (nonatomic, copy) NSString *service_type;

@property (nonatomic, copy) NSString *service_stime;

@property (nonatomic, copy) NSString *number_unit;


@end

