//
//  EngineerDetaileModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDetaileModel.h"

@implementation EngineerDetaileModel

+ (NSDictionary *)objectClassInArray{
    return @{@"service_sector" : [Service_Sector1 class],
             @"evaluation" : [Evaluation1 class],
//             @"service_brand" : [Service_Brand1 class],
             @"cer_images" : [Cer_Images class]};
}

@end


@implementation Service_Sector1

@end


@implementation Evaluation1
+ (NSDictionary *)objectClassInArray{
    return @{@"reply_list" : [Reply_List1 class]};
}

@end


@implementation Service_Brand1

@end


@implementation Cer_Images

@end

@implementation Reply_List1

@end

