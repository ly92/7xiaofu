//
//  OrderDetaileModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileProModel.h"

@implementation OrderDetaileProModel

+ (NSDictionary *)objectClassInArray{
    return @{@"payment_list" : [Payment_List23 class],
             @"goods" : [GoodsModel class]
             };
}

@end

@implementation Payment_List23

@end

@implementation GoodsModel

@end

