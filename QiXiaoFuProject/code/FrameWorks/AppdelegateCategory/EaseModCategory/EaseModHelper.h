//
//  EaseModHelper.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EaseModHelper : NSObject


/**
 环信注册

 @param account    账号
 @param password   密码
 @param completion 注册成功回调
 */
+ (void)registerEaseModWithAccount:(NSString *)account
                    withCompletion:(void (^)(NSString *username,
                                             NSString *error))completion;


/**
 环信登录
 @param account    账号
 @param password   密码
 @param completion 登录成功回调
 */
+ (void)loginEaseModWithAccount:(NSString *)account
                 withCompletion:(void (^)( NSString *aUsername,
                                          NSString *error))completion;




/**
 环信退出登录
 @param token ，在被动退出时传 NO，在主动退出时传 YES。
 @param completion 退出登录成功回调
 */
+ (void)autoLoginEaseModWithUnbindDeviceToken:(BOOL )token;


/**
 环信登录(异步)

 @param aUsername 账号
 @param aPassword 密码
 @param aSuccessBlock 登录成功回调
 @param aFailureBlock 登录成功回调
 */
+ (void)asyncLoginEaseModWithUsername:(NSString *)aUsername
                              success:(void (^)())aSuccessBlock
                              failure:(void (^)(EMError *aError))aFailureBlock;



@end
