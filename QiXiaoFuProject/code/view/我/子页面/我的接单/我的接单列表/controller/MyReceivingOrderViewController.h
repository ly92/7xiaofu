//
//  MyReceivingOrderViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//  我的接单列表页

#import "BaseViewController.h"

//接单状态的枚举
typedef NS_ENUM(NSInteger, ReceiveOrderStaus)
{
    ReceiveOrderStausRevoke               = 0,   //撤销
    ReceiveOrderStausUnReceive            = 1,  //待接单
    ReceiveOrderStausReceived             = 2,  //已接单(展示)
    ReceiveOrderStausComplete             = 3,  //已完成(展示)
    ReceiveOrderStatusExpire              = 4,  //已过期 or 已失效
    ReceiveOrderStausCancel               = 5,  //已取消(展示)
    ReceiveOrderStausChangePrice          = 6,  //调价中(展示)
    ReceiveOrderStausReplenishment        = 7   //补单
    
    
};
@interface MyReceivingOrderViewController : BaseViewController
//接单的状态
@property (nonatomic, assign)ReceiveOrderStaus receiveOrderStatus;

@end
