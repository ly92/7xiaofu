//
//  AssociationViewControllerA.h
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/31.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface AssociationViewControllerA : BaseViewController
@property (nonatomic, assign) BOOL isFromTrans;//是否为转移订单时选择用户
@property (nonatomic, copy) NSString *orderId;//待转移的订单ID
@end
