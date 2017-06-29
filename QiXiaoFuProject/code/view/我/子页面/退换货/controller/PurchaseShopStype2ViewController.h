//
//  PurchaseShopStype2ViewController.h
//  QiXiaoFuProject
//
//  Created by ly on 2017/6/29.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface PurchaseShopStype2ViewController : BaseViewController
@property (nonatomic, copy) NSString *order_id;// 订单id
@property (nonatomic, copy) NSString *refund_type;
@property(nonatomic, copy) void (^purchaseShopViewBlock)();
@end
