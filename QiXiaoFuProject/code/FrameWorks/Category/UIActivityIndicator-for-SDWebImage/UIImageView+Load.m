//
//  UIImageView+Load.m
//  SDWebImageLoadImageAnimation
//
//  Created by 冯 on 16/3/27.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "UIImageView+Load.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@implementation UIImageView (Load)
/** 显示图片 */
- (UIImageView *)imageView{
    static char imageViewKey;
    UIImageView * _imageView = objc_getAssociatedObject(self, &imageViewKey);
 
    if (_imageView == nil){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
         _imageView.alpha = 0;
        objc_setAssociatedObject(self, &imageViewKey, _imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    __weak UIImageView* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself addSubview:_imageView];
    });
    return _imageView;
}


/**菊花  */
- (UIActivityIndicatorView *)activityIndicator{
    static char activityIndicatorKey;
    UIActivityIndicatorView * _activityIndicator = objc_getAssociatedObject(self, &activityIndicatorKey);
    if (_activityIndicator == nil){
        _activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objc_setAssociatedObject(self, &activityIndicatorKey, _activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    __weak UIImageView* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        _activityIndicator.center = wself.center;
        [wself addSubview:_activityIndicator];
    });
    return _activityIndicator;
}



- (void)setImageWithUrl:(id )imageUrl placeholderImage:(UIImage *)placeholder{

    self.image = placeholder;
    
    
    
    if ([imageUrl isKindOfClass:[NSString class]]){
        if ([imageUrl isEqualToString:@""] == NO){
            imageUrl = [NSURL URLWithString:imageUrl];
        }
    }
    if ([imageUrl isKindOfClass:[NSURL class]] == NO){
        return;
    }
    
    __weak UIImageView *wself = self;
    __weak __block UIImageView *imageView = [self imageView];
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    LxDBAnyVar(self);

    imageView.alpha = 0;
    imageView.contentMode = self.contentMode;
    
    __weak __block UIActivityIndicatorView * activityIndicator = [self activityIndicator];
    [activityIndicator startAnimating];
    
    
    [imageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        float progress = (float)receivedSize/expectedSize;
        
        NSLog(@"--- 图片下载的进度---  %f",progress);
        
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
        if(!activityIndicator){
            activityIndicator = [wself activityIndicator];
        }
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        
        
        
        if(!imageView){
            imageView = [wself imageView];
        }
        if (image){
            
            if (cacheType == 0) {
                imageView.alpha = 0.f;
                imageView.image = image;

                // 执行动画
                [UIView animateWithDuration:0.50f animations:^{
                    imageView.alpha = 1.f;
                 }];
            }else{
                imageView.alpha = 1.f;
                imageView.image = image;
  
            }
        }
        else
        {
          
        }
    }];

}

- (void)setImageWithUrl:(NSString *)url placeholder:(UIImage *)placeholder{
    self.image = placeholder;
    [self sd_setImageWithURL:[NSURL URLWithString:url]
                      placeholderImage:placeholder
                               options:SDWebImageDelayPlaceholder
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (cacheType == 1 || cacheType == 2) {return;} // 0新下载，1磁盘缓存，2内存缓存
                                 self.alpha = 0;
                                 [UIView animateWithDuration:0.5 animations:^{
                                     self.alpha = 1;
                                 }];
                             }
     ];

}



@end
