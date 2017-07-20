//
//  AppDelegate+NewFeature.m
//  鸟网
//
//  Created by MiniC on 15/7/30.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "AppDelegate+NewFeature.h"
#import "MainTabBarViewController.h"

#import "LCNewFeatureVC.h"



@implementation AppDelegate (NewFeature)

- (void)newFeatureFinishBlock:(finishBlock)finisshBlock{
    
#pragma mark 1. 是否应该显示新特性界面
    
        [self featureVCFinishBlock:^(NSInteger tag) {
            finisshBlock(tag);
        }];
}




- (void)featureVCFinishBlock:(finishBlock)finisshBlock{
    BOOL showNewFeature = [LCNewFeatureVC shouldShowNewFeature];
    // 演示--每次都进入新特性界面, 实际项目不需要此句代码
//    showNewFeature = YES;
//    showNewFeature = NO;//  每一次都不显示新特性界面

    if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]){
        showNewFeature = NO;
    }
    
    if (showNewFeature) {
        
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, kScreenHeight - 150, kScreenWidth, 100);
        btn.backgroundColor = [UIColor clearColor];
        
        
        [btn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self enterMianCv];
            
            finisshBlock(0);
            
            
        }];
        
        LCNewFeatureVC * newFeatureVC = [LCNewFeatureVC initWithImageName:@"new_feature"
                                imageCount:4
                           showPageControl:NO
                               enterButton:btn
                               finishBlock:^(NSInteger tag){
                                   
                                   [[UIApplication sharedApplication] setStatusBarHidden:NO];
                                   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                                   
                                   [self enterMianCv];
                                   
                                   finisshBlock(tag);
                                   
                               }];
        newFeatureVC.statusBarStyle = LCStatusBarStyleNone;
        self.window.rootViewController = newFeatureVC;
//        [self fadeAnimationFinishBlock:^(NSInteger tag){
//        }];
        
    } else {    // 如果不需要显示新特性界面
        
        [self enterMianCv];
    }
}



//  进入主界面
- (void)enterMianCv{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //
    MainTabBarViewController * mainTabbarVc = [[MainTabBarViewController alloc]init];
    self.window.rootViewController = mainTabbarVc;
    
}








@end
