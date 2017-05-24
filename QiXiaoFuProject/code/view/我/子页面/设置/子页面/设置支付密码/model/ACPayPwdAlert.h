//
//  ACPayPwdAlert.h
//  ACPayPwdView
//
//  Created by ablett on 16/6/16.
//  Copyright © 2016年 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPayPwdAlert : UIView

@property (copy, nonatomic) NSString *title;                        ///< 标题
@property (assign, nonatomic) NSUInteger length;                    ///< 密码长度
@property (copy, nonatomic) void (^completeAction)(NSString *text); ///< 回调 Block

- (void)show;

@end


/*
 

 ACPayPwdAlert *pwdAlert = [[ACPayPwdAlert alloc] init];
 pwdAlert.title = @"请输入支付密码";
 pwdAlert.completeAction = ^(NSString *pwd){
    NSLog(@"==pwd:%@", pwd);
 };
 [pwdAlert show];

 
 
 
 */