//
//  NSString+Size.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGFloat)textSizeReturnWidth_WithFontSize:(CGFloat )fontSize constrainedToSize:(CGFloat)height;
- (CGFloat)textSizeReturnHeight_WithFontSize:(CGFloat )fontSize constrainedToSize:(CGFloat)width;
- (CGSize)textSizeWithFontSize:(CGFloat )fontSize constrainedToSize:(CGSize)size;
- (CGSize)textSizeWithFontSize:(CGFloat )fontSize constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
