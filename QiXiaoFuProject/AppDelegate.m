//
//  AppDelegate.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+NewFeature.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AppDelegate+AliPay.h"
#import "AppDelegate+UMShare.h"

#import "AppDelegate+JPush.h"
#import "EaseModHelper.h"

#import "AppDelegate+EaseMob.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    application.applicationIconBadgeNumber = 0;
    
    
    _connectionState = EMConnectionConnected;

    
    //[NSThread sleepForTimeInterval:3.0];//设置启动页面时间
 
    // 设置baseurl
    [MCNetTool updateBaseUrl:HttpCommonURL];

    // 注册极光
    [self initJpushWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    
    DeLog(@"路径---  \n\n\n       %@\n\n\n",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);

    // 注册微信
    [self weiXinRegister];
    
    //  引导页
    [self newFeatureFinishBlock:^(NSInteger tag){
        
    }];
 
    // 注册环信
    [self easeMod:application options:launchOptions];
    
    // 初始化友盟
    [self initUMeng];
    
    [NSThread sleepForTimeInterval:1.0];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    [self configureAPIKey];// 注册高德地图

 
    [EaseModHelper asyncLoginEaseModWithUsername:kPhone success:^{
        DeLog(@"登录环信成功======%@",kPhone);
        
    } failure:^(EMError *aError) {
        DeLog(@"登录环信失败 ====%@",aError);
    }];
    
    return YES;
}


#pragma mark -  注册环信

- (void)easeMod:(UIApplication *)application options:(NSDictionary *)launchOptions{

    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"7xiaofu#7xiaofu"];
    
//    
//    options.apnsCertName = @"7xf_hx_dev";
//    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"7xiaofu#7xiaofu" apnsCertName:@"7xf_hx_dev" otherConfig:nil];

//    options.apnsCertName = @"7xf_dis";
//    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"7xiaofu#7xiaofu" apnsCertName:@"7xf_dis" otherConfig:nil];

    
#ifdef DEBUG
    options.apnsCertName = @"7xiaofu_dev";
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"7xiaofu#7xiaofu" apnsCertName:@"7xiaofu_dev" otherConfig:nil];
#else
    options.apnsCertName = @"7xiaofu_dis";
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"7xiaofu#7xiaofu" apnsCertName:@"7xiaofu_dis" otherConfig:nil];
#endif
    
    
    
    [[EMClient sharedClient] initializeSDKWithOptions:options];

}

#pragma mark -- 收到远程消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
 
    [JPUSHService handleRemoteNotification:userInfo];
    
    DeLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

 
}



#pragma mark -- app已经进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTaskNotificationname" object:nil];
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

#pragma mark  --app将要进入前台(首次启动不会调用)
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    [EaseModHelper asyncLoginEaseModWithUsername:kPhone success:^{
        DeLog(@"进入前台登录环信成功");
        
    } failure:^(EMError *aError) {
        DeLog(@"进入前台登录环信失败 ==========%@",aError);
    }];
  
    //清空图标
    [application setApplicationIconBadgeNumber:0];
    
    [application cancelAllLocalNotifications];
    
    // 注册极光推送别名
    [JPUSHService setAlias:kPhone callbackSelector:nil object:self];
    
}


- (void)configureAPIKey
{
    
    
//    NSString *APIKey = @"5f8ced32e16675dad2e8ffcd839c4f0b";// zpf
//
     NSString *APIKey = @"c5301bb2b0677f87ed81ecdd5c1e5fbe";// 7xf

     [AMapServices sharedServices].apiKey = APIKey;

    
}

//// 禁用第三方输入法
//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier NS_AVAILABLE_IOS(8_0){
//    return NO;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark --三方应用打开app
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    [self aLiPayWithApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    BOOL isYes = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    //    return [self UMengActionWithUrl:url];
    return isYes;
}

//  IOS9 特有
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if(!result){
        //处理其他openrul
        return [self aLiPayWithApplication:app openURL:url sourceApplication:nil annotation:nil];
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

//注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 注册极光推送
    [self jPushregisterDeviceToken:deviceToken];
    
    [self easeRegisterDeviceToken:deviceToken];
    
}




@end
