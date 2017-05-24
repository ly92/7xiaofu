//
//  UIImageView+Load.h
//  SDWebImageLoadImageAnimation
//
//  Created by 冯 on 16/3/27.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>
 @interface UIImageView (Load)

- (void)setImageWithUrl:(id )url placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder;
@end