//
//  YWNoNetworkView.h
//  YiWangClient
//
//  Created by DarkAngel on 14-3-31.
//  Copyright (c) 2014年 一网全城. All rights reserved.
//
//  系统名称：
//  功能描述：数据加载失败，无网络视图
//  修改记录：(仅记录功能修改)

#import <UIKit/UIKit.h>

typedef void(^ReloadBlock)(void);

@interface YWNoNetworkView : UIView

+ (instancetype)sharedInstance;
/**
 *  显示数据加载失败
 *
 *  @param view   需要显示的view
 *  @param reload 重新加载数据的处理
 */
+ (void)showNoNetworkInView:(UIView *)view reloadBlock:(ReloadBlock)reload;
/**
 *  设置全屏显示
 */
+ (void)setShowsInFullScreen;

/*!
 *	@brief	手动移除视图
 *
 *	@return	void
 */
- (void)removeTheView;


@end
