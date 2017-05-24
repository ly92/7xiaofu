//
//  ShopListModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopListModel.h"

@implementation ShopListModel


+ (NSDictionary *)objectClassInArray{
    return @{@"goods_list" : [Goods_List class], @"area_list" : [Area_List class], @"searching_type" : [Searching_Type class]};
}

@end


@implementation Goods_List

@end


@implementation Area_List

@end


@implementation Searching_Type

+ (NSDictionary *)objectClassInArray{
    return @{@"value" : [Value class]};
}

@end


@implementation Value

@end


