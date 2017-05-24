//
//  ShopOrderModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Order_List;
@interface ShopOrderModel : NSObject

@property (nonatomic, copy) NSString *pay_sn;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, strong) NSArray<Order_List *> *order_list;

@property (nonatomic, copy) NSString *order_amount;

@property (nonatomic, assign) NSInteger state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】

@property (nonatomic, copy) NSString *order_sn;

@property (nonatomic, assign) NSInteger order_end_time;

@property (nonatomic, copy) NSString *distribution_info;

@end

@interface Order_List : NSObject

@property (nonatomic, copy) NSString *goods_id;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *goods_image;

@property (nonatomic, copy) NSString *goods_num;

@property (nonatomic, copy) NSString *goods_name;

@property (nonatomic, copy) NSString *goods_price;



@end

