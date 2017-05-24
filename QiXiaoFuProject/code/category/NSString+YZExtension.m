//
//  NSString+Extension.m
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 gyh. All rights reserved.
//

#import "NSString+YZExtension.h"

@implementation NSString (YZExtension)
- (CGSize)yzSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
