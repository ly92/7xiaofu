//
//  EaseModHelper.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EaseModHelper.h"

@implementation EaseModHelper


/**
 环信注册
 @param account    账号
 @param password   密码
 @param completion 注册成功回调
 */
+ (void)registerEaseModWithAccount:(NSString *)account
                 withCompletion:(void (^)(NSString *username,
                                        NSString *error))completion  {
                               
    EMError *error = [[EMClient sharedClient] registerWithUsername:account password:@"11"];
    
    if (error==nil) {
        completion(account,@"注册成功");
    }
    
}


/**
 环信登录
 @param account    账号
 @param password   密码
 @param completion 登录成功回调
 */
+ (void)loginEaseModWithAccount:(NSString *)account
                    withCompletion:(void (^)( NSString *aUsername,
                                             NSString *error))completion
{
    
    
    if ([MCNetTool net]) {
        
        if(account.length != 0){
            
            EMError *error = [[EMClient sharedClient] loginWithUsername:account password:@"11"];
            if (!error) {
                DeLog(@"环信----------登录成功");
                
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
            }else{
                DeLog(@"环信----------登陆失败  -- %@",error);
            }
            
        }
    }
    
}


+ (void)asyncLoginEaseModWithUsername:(NSString *)aUsername
                              success:(void (^)())aSuccessBlock
                              failure:(void (^)(EMError *aError))aFailureBlock{

    
    
//    if ([MCNetTool net]) {
//        
//        if(aUsername.length != 0){
//           
//            
//            
//            [[EMClient sharedClient] asyncLoginWithUsername:aUsername password:@"11" success:^{
//                
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//                
//                DeLog(@"环信----------登录成功");
//                
//            } failure:^(EMError *aError) {
//                
//                DeLog(@"环信----------登陆失败  -- %@",aError);
//            }];
//            
//        }
//    }
    
}






/**
 环信退出登录
 @param token ，在被动退出时传 NO，在主动退出时传 YES。
 @param completion 退出登录成功回调
 */
+ (void)autoLoginEaseModWithUnbindDeviceToken:(BOOL )token{

    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        DeLog(@"环信----------退出成功");
    }
    
}





@end
