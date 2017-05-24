//
//  NSDictionary+NULL.m
//  meirong
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "NSDictionary+Null.h"


@implementation NSDictionary (Null)

-(NSString *)safeNullWithKey:(NSString *)key
{
    return checksNull([self objectForKey:key]);;

}
@end


