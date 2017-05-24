//
//  OrderDetaileModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileModel.h"

@implementation OrderDetaileModel

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_list" : [Goodss_List class],
             @"payment_list" : [Payments_List class],
             @"goods_sn_type" : [Goods_Sn_Type class]};
}

@end


@implementation Goodss_List

@end


@implementation Payments_List

@end

@implementation Goods_Sn_Type

@end

