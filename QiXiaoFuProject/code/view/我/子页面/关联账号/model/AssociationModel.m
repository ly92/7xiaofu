//
//  AssociationModel.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AssociationModel.h"

@implementation AssociationModel

+ (NSDictionary *)objectClassInArray{
    return @{@"me_to_user" : [Me_To_User class]};
}

@end


@implementation User_To_Me

@end


@implementation Me_To_User
+ (NSDictionary *)objectClassInArray{
    return @{@"zi" : [AZi class]};
}
@end

@implementation AZi

@end


@implementation EnrollEnigeer

@end
