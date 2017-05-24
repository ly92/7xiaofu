//
//  AppDelegate+AliPay.m
//  鸟网
//
//  Created by MiniC on 15/7/30.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "AppDelegate+AliPay.h"

//alipay 支付宝
#import <AlipaySDK/AlipaySDK.h>

@implementation AppDelegate (AliPay)

- (BOOL)aLiPayWithApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
 
    if(!url){
        return NO;
    }
//    如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    #ifdef DEBUG
            DeLog(@"result = %@",resultDic);
    #endif
            //   9000  为支付成功
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alipayResult" object:[resultDic objectForKey:@"resultStatus"]];

        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
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
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
#ifdef DEBUG
            DeLog(@"result = %@",resultDic);
#endif
        }];
    }
    //微信支付
    if ([url.host isEqualToString:@"pay"]) {
         return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//  注册微信支付
- (void)weiXinRegister{
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
}
#pragma mark - 微信支付回调
-(void) onResp:(BaseResp*)resp
{
    
    LxDBAnyVar(resp.errStr);
    LxDBAnyVar(resp.errCode);

    
      if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                DeLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:@"1"];
            }
                break;
                
            default:
            {
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                 DeLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXpayresult" object:@"0"];

            }
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
   
}
-(void) onReq:(BaseReq*)req{


    LxDBAnyVar(req.openID);
 


}



@end
