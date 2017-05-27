//
//  AppDelegate.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainTabBarViewController *mainController;

@end

