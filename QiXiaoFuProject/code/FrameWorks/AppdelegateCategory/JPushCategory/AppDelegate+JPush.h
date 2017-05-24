//
//  AppDelegate+JPush.h
//  鸟网
//
//  Created by MiniC on 15/7/30.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
 #import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate (JPush)<UIAlertViewDelegate,JPUSHRegisterDelegate>

/*!
 *  @author fhj, 15-07-31 10:07:50
 *
 *  @brief 初始化 极光推送
 *
 */
- (void)initJpushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


- (void)jPushregisterDeviceToken:(NSData *)deviceToken;


@end
