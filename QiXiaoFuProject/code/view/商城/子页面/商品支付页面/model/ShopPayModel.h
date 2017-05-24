//
//  ShopPayModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopPayModel : NSObject



// 发单
@property (nonatomic, assign) NSInteger is_pay;//是否调用支付【0 否 1是 ； 0为使用钱包已完成全额支付】

@property (nonatomic, copy) NSString *bill_id;//发单成功的 发单id



// 商城
@property (nonatomic, copy) NSString *goods_count;//购物车总数

@property (nonatomic, copy) NSString *order_total;//订单金额

@property (nonatomic, copy) NSString *order_id;//订单id


// 公共信息
@property (nonatomic, copy) NSString *price_number;//购物车总价

@property (nonatomic, copy) NSString *order_title;//订单标题


@property (nonatomic, copy) NSString *appid;//微信公众账号ID

@property (nonatomic, copy) NSString *partnerid;//商户号

@property (nonatomic, assign) NSInteger timestamp;//时间戳

@property (nonatomic, copy) NSString *noncestr;//随机字符串

@property (nonatomic, copy) NSString *pay_sn;  //支付单号

@property (nonatomic, copy) NSString *package;//扩展字段

@property (nonatomic, copy) NSString *appKey;// 微信appkey

@property (nonatomic, copy) NSString *call_api_url;//第三方回调地址

@property (nonatomic, copy) NSString *prepayid;// 预支付交易会话ID

@property (nonatomic, copy) NSString *sign;// 签名


@end









//                正确返回参数说明：
//
//                参数名	类型	说明
//                pay_sn	string	支付单号
//                goods_count	string	购物车总数
//                price_number	string	购物车总价

//                order_total	是	string	订单金额
//                order_title	是	string	订单标题

//                call_api_url	是	string	第三方回调地址

//                appid	是	string	微信公众账号ID
//                noncestr	是	string	随机字符串
//                package	是	string	扩展字段
//                partnerid	是	string	商户号
//                prepayid	是	string	预支付交易会话ID
//                timestamp	是	string	时间戳
//                sign	是	string	签名


