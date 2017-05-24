//
//  AdressModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdressModel : NSObject

@property (copy,nonatomic)NSString * address;
@property (copy,nonatomic)NSString * area_info;
@property (copy,nonatomic)NSString * area_id;
@property (copy,nonatomic)NSString * city_id;
@property (copy,nonatomic)NSString * true_name;
@property (copy,nonatomic)NSString * address_id;
@property (copy,nonatomic)NSString * mob_phone;
@property (assign,nonatomic)NSInteger  is_default;
@property (copy,nonatomic)NSString * prov_id;

@end
