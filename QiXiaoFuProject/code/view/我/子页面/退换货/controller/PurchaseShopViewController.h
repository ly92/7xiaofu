//
//  PurchaseShopViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface PurchaseShopViewController : BaseViewController
@property (nonatomic, copy) NSString *order_id;// 订单id

@property(nonatomic, copy) void (^purchaseShopViewBlock)();


@end
