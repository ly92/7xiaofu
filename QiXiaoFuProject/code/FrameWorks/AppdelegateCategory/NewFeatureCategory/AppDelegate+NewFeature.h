//
//  AppDelegate+NewFeature.h
//  鸟网
//
//  Created by MiniC on 15/7/30.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "AppDelegate.h"

/**
 *  完成新特性界面展示后的block回调
 */
typedef void (^finishsBlock)(NSInteger tag);

@interface AppDelegate (NewFeature)

/**
 *  @author hongjian_feng, 15-08-06 22:08:17
 *
 *  程序第一次安装或者的是版本更新后的 新特性展示（引导页）
 *
 */
- (void)newFeatureFinishBlock:(finishsBlock)finishBlock;

@end
