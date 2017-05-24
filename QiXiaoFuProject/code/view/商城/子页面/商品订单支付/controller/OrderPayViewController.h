//
//  OrderPayViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderPayViewController : BaseViewController
@property (nonatomic, copy) NSString *pay_sn;
@property (nonatomic, assign) CGFloat order_price;
@property (nonatomic, copy) NSString *order_id;

@end
