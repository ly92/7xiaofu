//
//  WeiXinPayManager.m
//  TomatoDemo
//
//  Created by 冯洪建 on 15/8/18.
//  Copyright (c) 2015年 hongjian feng. All rights reserved.
//

#import "WeiXinPayManager.h"
#import "WeiXinPartnerConfig.h"

@implementation WeiXinPayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WeiXinPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeiXinPayManager alloc] init];
    });
    return instance;
}



- (void)weiXinPay:(ShopPayModel *)shopPayModel {

    if (![WXApi isWXAppInstalled]) {
        DeLog(@"没有安装微信");
        return ;
    }else if (![WXApi isWXAppSupportApi]){
        DeLog(@"不支持微信支付");
        return ;
    }
    DeLog(@"------  安装了微信并且支持微信支付");

    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = shopPayModel.partnerid;/** 商家向财付通申请的商家id */
    req.prepayId            = shopPayModel.prepayid; /** 预支付订单 */
    req.nonceStr            = shopPayModel.noncestr;/** 随机串，防重发 */
    req.timeStamp           = (int)shopPayModel.timestamp;/** 时间戳，防重发 */
    req.package             = shopPayModel.package;/** 商家根据财付通文档填写的数据和签名 */
    req.sign                = shopPayModel.sign; /** 商家根据微信开放平台文档对数据做的签名 */
    
   BOOL  status =  [WXApi sendReq:req];
    
    DeLog(@"微信支付的状态----%d",status);
}



+ (NSString *)jumpToBizPay:(NSString *)url {
    
    
    
    if (![WXApi isWXAppInstalled]) {
        DeLog(@"没有安装微信");
        return nil;
    }else if (![WXApi isWXAppSupportApi]){
    
        DeLog(@"不支持微信支付");
        return nil;
    }
    
    DeLog(@"------  安装了微信并且支持微信支付");
    
    
    
    url = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   =url;//
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        DeLog(@"微信支付-----url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                DeLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}


//客户端提示信息
+(void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


@end


@implementation WXProduct

@end




