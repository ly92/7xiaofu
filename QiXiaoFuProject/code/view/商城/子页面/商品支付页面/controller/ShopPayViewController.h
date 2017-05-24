//
//  ShopPayViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//  商城支付界面

#import "BaseViewController.h"

@interface ShopPayViewController : BaseViewController
@property (nonatomic, copy) NSString  *cart_id;
@property (nonatomic, assign) NSInteger ifcart;  //  结算方式 【1，购物车】 【0，立即购买】
@property (nonatomic, strong) NSArray *cartGoodsArray;
@end
