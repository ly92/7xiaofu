//
//  ProductModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *entry_name;

@property (nonatomic, assign) NSInteger is_top;

@property (nonatomic, copy) NSString *service_city;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *service_stime;

@property (nonatomic, copy) NSString *inputtime;

@property (nonatomic, copy) NSString *bill_user_name;

@property (nonatomic, copy) NSString *bill_user_avatar;

@property (nonatomic, copy) NSString *service_etime;

@property (nonatomic, copy) NSString *service_price;

@property (nonatomic, copy) NSString *bill_user_id;

@property (nonatomic, copy) NSString *bill_statu;

@end

