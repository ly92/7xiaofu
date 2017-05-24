//
//  NSDictionary+NULL.h
//  meirong
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define checksNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]


@interface NSDictionary (Null)

@end
