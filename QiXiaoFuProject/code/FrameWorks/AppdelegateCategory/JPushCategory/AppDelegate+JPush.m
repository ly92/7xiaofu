//
//  AppDelegate+JPush.m
//  鸟网
//
//  Created by MiniC on 15/7/30.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "ProductDetaileViewController.h"
#import "WalletViewController.h"
#import "BlockUIAlertView.h"
#import "OrderDetailViewController.h"
#import "CertificationViewController.h"
#import "OrderDetailViewController.h"
#import "MySendOrderDetaileViewController.h"
#import "MainTabBarViewController.h"
#import "BaseNavigationController.h"
#import "OrderDetaileViewController.h"


#import "JKNotifier.h"

//#import "BXTabBarController.h"
//#import "ProductInfoViewController.h"
//#import "SubjectViewController.h"


//static  NSString * jPushAPP_KEY = @"59e56ce9c03024c95fd33ef7";// zpf

static  NSString * jPushAPP_KEY = @"134f2e6898e617952d78e96f";// 7xf
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


@implementation AppDelegate (JPush)



#pragma mark - 极光推送

- (void)initJpushWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
//    else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:jPushAPP_KEY
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DeLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            DeLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    [JPUSHService crashLogON];
}

- (void)jPushregisterDeviceToken:(NSData *)deviceToken{

    DeLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];

}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)applicationhandleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    
    
    
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    DeLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    
    
    [self push:userInfo withAnimated:YES];

    
    completionHandler(UIBackgroundFetchResultNewData);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DeLog(@"iOS10 前台收到远程通知:%@", userInfo);
        
        [self push:userInfo withAnimated:YES];

    }
    else {
        // 判断为本地通知
        DeLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
        [self push:userInfo withAnimated:YES];

    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        DeLog(@"iOS10 收到远程通知:%@", userInfo);
        
        [self push:userInfo withAnimated:YES];

    }
    else {
        // 判断为本地通知
        DeLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
        
        [self push:userInfo withAnimated:YES];
        
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

- (void)push:(NSDictionary *)params withAnimated:(BOOL)animated{
    
   
//    --	{
//        _j_msgid = 1441008682,
//        content = "车市内容",
//        aps = 	{
//            alert = "测试标题",
//            badge = 1,
//            sound = "default",
//        },
//        title = "测试标题",
//        details_id = "37",
//        list_id = "",
//        type = 1,
//        push_type = "1",
//    }----
    
//    NSString * content = params[@"content"];     // 推送内容
//    NSString * title = params[@"title"];     // 推送标题
//    NSString * details_id = params[@"details_id"];     // 详情id（项目id 产品id）
    NSString * jump_id = params[@"jump_id"];     // 类型
    NSInteger  jump_type = [params[@"jump_type"] integerValue];     // 1 项目  2 产品
 
    
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    
    if (tabVC == nil)
    {
        MainTabBarViewController * mainTabbarVc = [[MainTabBarViewController alloc]init];
        tabVC = mainTabbarVc;
    }
    else
    {
        tabVC = (UITabBarController *)self.window.rootViewController;
    }
    
    BaseNavigationController *pushClassStance = (BaseNavigationController *)tabVC.viewControllers[tabVC.selectedIndex];

    
    
    // 【71：项目详情】【72：接单详情】【73：发单详情】【74：跳转到钱包详情里，此时jump_id为空】【75：众筹详情】
    
    if (jump_type ==71) {
        // 项目详情
        ProductDetaileViewController * vc  = [[ProductDetaileViewController alloc]initWithNibName:@"ProductDetaileViewController" bundle:nil];
        vc.p_id =jump_id;
        [pushClassStance pushViewController:vc animated:YES];
        
    }
    if (jump_type ==72) {
        OrderDetailViewController * vc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
        vc.pro_id = jump_id;
        [pushClassStance pushViewController:vc animated:YES];
    }
    if (jump_type ==73) {
        MySendOrderDetaileViewController * vc = [[MySendOrderDetaileViewController alloc]initWithNibName:@"MySendOrderDetaileViewController" bundle:nil];
        vc.pro_id =jump_id;
        [pushClassStance pushViewController:vc animated:YES];
        
    }
    
    if (jump_type ==74) {
        WalletViewController * vc = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
        [pushClassStance pushViewController:vc animated:YES];
        
    }
    if (jump_type ==76) {
        OrderDetaileViewController * vc = [[OrderDetaileViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
        vc.order_id =jump_id;
        [pushClassStance pushViewController:vc animated:YES];
    }

}



@end
