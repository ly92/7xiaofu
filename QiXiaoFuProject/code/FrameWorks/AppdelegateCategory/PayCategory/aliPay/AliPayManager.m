//
//  AliPayManager.m
//  TomatoDemo
//
//  Created by 冯洪建 on 15/8/18.
//  Copyright (c) 2015年 hongjian feng. All rights reserved.
//

#import "AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"


@implementation AliPayManager

TomatoSingletonM(AliPayManager)

- (void)pay:(ShopPayModel *)shopPayModel{
    
    //当手机没有没有安装支付宝客户端时，调用 支付宝web网页  显示出 底层 window
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [[[UIApplication sharedApplication] windows] objectAtIndex:0].hidden = NO;
    }
    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    企业支付宝帐号	    https://www.alipay.com/   wuxue@7xiaofu.com              7Xiaofu
//    支付密码：7Xiaofu_777
//    合作者身份(PID)   2088421611509935
//    App ID：2016091801919414
    

    NSString *appID =@"2016091801919414";//shopPayModel.appid;
    // 私钥
    NSString *privateKey  = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMwP7ZPMkciLr1ap1wes0RRebboaRhyXXR1WI4RLeYSJibpSEQC/P8g/S5TTvjl4CoEBYPf9fFPMn3h9QEq6zwl6LpqgsK6WgLME1A22ARPWcEcjeNZvQ3lLv3wwmbohqbMxenOmxNIL3VvYzet6R0o4yT+dE1RIrDFmgD2VrIapAgMBAAECgYBAaO6mbjW9xUls42L6CzRbZ4re6RgkQiqj7eJ8CY6rpPYSF4FCaRtqy3/B1CwA28EFAzhmTl6F3NqhH3fBnsFmPh3S2O62KV2215Uvhpq3cm1T85vWHCAeOPh0mdo1eDu9eyyTEHO/yYpFh4XedDTvN8qreOaAWrmUs+qGuvAhAQJBAOZ6A9eroTlJM7fCDkWiWumPwVKYm94bxNrB7ZT8tSV+fRpRm538MbAjUr02e0EqtnYdbo0jVGRK9PvvxmwZF1ECQQDiqRFeJnPbctkB7QGLni7y6B3Zl0QlaTdvZeNTrUO5M8dXzv6iGze4Ps/Jc0cC/RnaQqJDa4Q4gmjTa1S3MNPZAkEA3rcVs3l0yIjGY1IwvHWRaJWz+P7j0BQBfGteDFTPL7Y1ahNmT5p+4Xig4ZseK/D8dNMoG1cCnBAbAMHJengcoQJAC/IZJjsklAZDhaR2FmOp2cd9+z/LqaUX9NkL2BcjoJkoAmq4ZNbGYwF8dgOLVI7+U9B7OM5r04ab+7iGaHk8UQJAD3wMeuUFphfsHTUyPWSFKGw1mVlkSlRRIHQdgCj2Cm7PesQK9cm9A3b4UBg7AIvOGEtroIBapwdCxr2nbndYgg==";
    
    
        /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    //NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
    order.notify_url = shopPayModel.call_api_url;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = shopPayModel.order_title;
    order.biz_content.subject = shopPayModel.order_title;//[NSString stringWithFormat:@"%@ x %@",shopPayModel.order_title,shopPayModel.goods_count];
    order.biz_content.out_trade_no = shopPayModel.pay_sn; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%@", shopPayModel.order_total]; //商品价格
//    order.biz_content.seller_id = @"2088421611509935";
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    DeLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"qixiaofuAlipay";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            NSString * result = [resultDic objectForKey:@"resultStatus"];
            //当手机没有没有安装支付宝客户端时，调用支付宝web网页 回调隐藏底层 window
            if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
                [[[UIApplication sharedApplication] windows] objectAtIndex:0].hidden = YES;
            }
            if ([result isEqualToString:@"9000"]) {
                DeLog(@"支付宝————支付结果result = %@  ---    支付成功", resultDic);
            }else{
                DeLog(@"支付宝————支付结果result = %@   ------  支付失败", resultDic);
            }
            
        }];
    }
}




#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

- (void)doAlipayAuth
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *pid = @"";
    NSString *appID = @"";
    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = pid;
    authInfo.appID = appID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:authInfoStr];
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                           }];
    }
}



@end


