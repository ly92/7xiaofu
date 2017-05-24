//
//  GoodsDetaileModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "GoodsDetaileModel.h"

@implementation GoodsDetaileModel

+ (NSDictionary *)objectClassInArray{
    return @{@"store_server" : [Store_Server class]};
}
@end


@implementation Store_Info

@end


@implementation Store_Credit

@end


@implementation Store_Deliverycredit

@end


@implementation Store_Desccredit

@end


@implementation Store_Servicecredit

@end


@implementation Goods_Info

+ (NSDictionary *)objectClassInArray{
    return @{@"goods_attr" : [Goods_Attr class]};
}

@end


@implementation Goods_Attr

@end

@implementation Store_Server

@end



