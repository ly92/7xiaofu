//
//  FTabBarViewController.h
//
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 minic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;
@interface MainTabBarViewController : UITabBarController<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (nonatomic, strong) TabBar *customTabBar;

- (void)jumpToChatList;

- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end




