//
//  ShowaddbillModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShowaddbillModel.h"

@implementation ShowaddbillModel

+ (NSDictionary *)objectClassInArray{
    return @{@"service_type" : [Service_Type class], @"service_sector" : [Service_Sector12 class], @"service_form" : [Service_Form class], @"payment_list" : [Payment_List1 class]};
}


@end


@implementation Service_Type

@end


@implementation Service_Sector12

+ (NSDictionary *)objectClassInArray{
    return @{ @"list" : [Service_Sector22 class]};
}

@end
@implementation Service_Sector22

@end

@implementation Service_Form

@end


@implementation Payment_List1

@end


