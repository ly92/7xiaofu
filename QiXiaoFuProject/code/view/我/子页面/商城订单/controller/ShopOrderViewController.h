//
//  ShopOrderViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

//商品订单状态的枚举
typedef NS_ENUM(NSInteger, ShoppingOrderStatus)
{
    OrderStatusCancel               = 0,   //已取消(展示)
    OrderStatusUnPayment            = 1,  //待付款(展示)
    OrderStatusReadyGo              = 2,  //已付款 待发货(展示)
    OrderStatusWaitingForConfirmed  = 3,  //待收货(展示)
//    OrderStatusUnComment            = 4,  //待评价
    OrderStatusComplete             = 4,  //已完成(展示)
    OrderStatusReturn               = 6,  //退货换货中
    OrderStatusAll                  = 100 //全部订单(展示,state_type字段为空时获取的是全部订单)

    
};

@interface ShopOrderViewController : BaseViewController

@property (nonatomic, assign)ShoppingOrderStatus shoppingOrderStatus;

@end
