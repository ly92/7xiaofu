//
//  ShopOrderModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderModel.h"

@implementation ShopOrderModel

+ (NSDictionary *)objectClassInArray{
    return @{@"order_list" : [Order_List class]};
}

@end


@implementation Order_List

@end


