//
//  SystemMessageModel.m
//  QiXiaoFuProject
//
//  Created by 付彦彰 on 2017/5/16.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "YZSystemMessageModel.h"

@implementation YZSystemMessageModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"countnum_all_count" : [YZUnReadMessageModel class]};
}


@end



@implementation YZUnReadMessageModel

@end
