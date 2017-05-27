//
//  AssociationViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface AssociationViewController : BaseViewController
@property (nonatomic, assign) BOOL isFromTrans;//是否为转移订单时选择用户
@property (nonatomic, copy) NSString *orderId;//待转移的订单ID


@end
