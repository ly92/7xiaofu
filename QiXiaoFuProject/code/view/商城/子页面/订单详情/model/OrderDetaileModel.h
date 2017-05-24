//
//  OrderDetaileModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goodss_List,Payments_List,Goods_Sn_Type;
@interface OrderDetaileModel : NSObject

@property (nonatomic, copy) NSString *distribution_info;//配送方式描述

@property (nonatomic, copy) NSString *pay_sn;//订单支付号

@property (nonatomic, copy) NSString *logistics_last_time;//物流的最后时间

@property (nonatomic, copy) NSString *logistics_last_message;//物流的最后状态

@property (nonatomic, copy) NSString *order_note;//我的购物订单备注

@property (nonatomic, strong) NSArray<Goodss_List *> *goods_list;

@property (nonatomic, copy) NSString *order_price;//订单价格

@property (nonatomic, assign) NSInteger order_end_time;//	下单剩余时间 返回剩余的时间秒数，如果过期或其他情况则返回字符串0

@property (nonatomic, copy) NSString *store_name;//店铺名称

@property (nonatomic, copy) NSString *actual_price;//实付价格

@property (nonatomic, copy) NSString *order_sn;// 订单号

@property (nonatomic, copy) NSString *add_time;//下单时间

@property (nonatomic, copy) NSString *mob_phone;//收货人手机号

@property (nonatomic, copy) NSString *true_name;//	收货人姓名

@property (nonatomic, copy) NSString *state_desc;//订单文字描述

@property (nonatomic, assign) NSInteger state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】

@property (nonatomic, copy) NSString *payment_name;//支付方式名称

@property (nonatomic, strong) NSArray<Payments_List *> *payment_list;

@property (nonatomic, copy) NSString *logistics_url;//物流详信息的H5页面链接地址

@property (nonatomic, copy) NSString *payment_img;//支付方式图片

@property (nonatomic, copy) NSString *address;// 收货人地址

@property (nonatomic, copy) NSString *preferential_price;//	优惠价格

@property (nonatomic, copy) NSString *order_beizhu;//商家备注信息

@property (nonatomic, strong) NSArray<Goods_Sn_Type *> *goods_sn_type;



@end


@interface Goodss_List : NSObject

@property (nonatomic, copy) NSString *goods_num;//商品数量

@property (nonatomic, copy) NSString *goods_image_icon;//商品图标地址 如：新，热，促，赠。。。。。。。

@property (nonatomic, copy) NSString *goods_img;//商品图片

@property (nonatomic, copy) NSString *goods_pay_price;//商品价格

@property (nonatomic, copy) NSString *goods_sum;//商品小计

@property (nonatomic, copy) NSString *goods_name;//商品名称

@property (nonatomic, copy) NSString *goods_image_type;//商品图标状态 位运算 【0：无】【1：新】【2：热】【4：促】【8：赠】

@property (nonatomic, copy) NSString *goods_id;//商品ID




@end


@interface Payments_List : NSObject

@property (nonatomic, copy) NSString *payment_id;

@property (nonatomic, copy) NSString *payment_name;

@property (nonatomic, copy) NSString *payment_state;

@property (nonatomic, copy) NSString *payment_desc;

@property (nonatomic, copy) NSString *payment_code;

@property (nonatomic, copy) NSString *payment_config;

@property (nonatomic, copy) NSString *is_default;

@property (nonatomic, copy) NSString *payment_img;//支付方式图片

@end


@interface Goods_Sn_Type : NSObject

@property (nonatomic, copy) NSString *goods_type_name;

@property (nonatomic, copy) NSString *goods_sn;

@end










