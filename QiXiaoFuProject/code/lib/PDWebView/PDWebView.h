//
//  ZLCWebView.h
//  测试
//
//  Created by shining3d on 16/6/17.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface PDWebView : UIWebView<UIWebViewDelegate>

#pragma mark - Public Properties



#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame;

#pragma mark - Static Initializers
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;

@property (nonatomic, assign) CGFloat progressViewOffset;



/** showImage 与 safariOpenUrl 不能同时使用 */
@property (nonatomic, assign) BOOL showImage;// 点击放大图片 默认： NO
@property (nonatomic, assign) BOOL safariOpenUrl;// 点击Url 使用系统safari浏览器打开链接  默认： NO

@property (nonatomic, assign) BOOL showProgress;// 是不是显示进度条 默认： YES


@end
