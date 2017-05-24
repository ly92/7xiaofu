//
//  UIWebView+JavaScript.h
//  eCarry
//
//  Created by whde on 15/11/10.
//  Copyright © 2015年 Joybon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScript)
///  获取某个标签的结点个数
- (int)nodeCountOfTag:(NSString *)tag;

///  获取当前页面URL
- (NSString *)getCurrentURL;

///  获取标题
- (NSString *)getTitle;

///  获取文章内容
- (NSString *)getContent;

///  获取图片
- (NSMutableArray *)getImgs;

///  获取当前页面所有链接
- (NSArray *)getOnClicks;

///  改变背景颜色
- (void)setBackgroundColor:(UIColor *)color;

///  为所有图片添加点击事件(网页中有些图片添加无效)
- (void)addClickEventOnImg;

///  改变指定标签的字体颜色
- (void)setFontColor:(UIColor *)color withTag:(NSString *)tagName;

///  改变指定标签的字体大小
- (void)setFontSize:(int)size withTag:(NSString *)tagName;

///  设置网页没有拷贝粘贴
- (void)disableTouchCallout;


/**
 *  获取WebView的高度
 *
 */
- (CGFloat )webViewHeight;
/**
 *  获取WebView的高度(图片适应Webview的宽度)
 *
 *  @param offset 图片的大小
 *
 */
- (CGFloat)webViewAutoImageHeightWithOffset:(CGFloat )offset;


@end
