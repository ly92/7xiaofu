//
//  MySendOrderViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//  我的发单列表页

#import "BaseViewController.h"

//发单状态的枚举
typedef NS_ENUM(NSInteger, SendOrderStatus)
{
    SendOrderStatusRevoke               = 0,   //撤销
    SendOrderStatusUnReceive            = 1,  //待接单(展示)
    SendOrderStatusReceived             = 2,  //已接单(展示)
    SendOrderStatusComplete             = 3,  //已完成(展示)
    SendOrderStatusExpire               = 4,  //已过期 or 已失效
    SendOrderStatusCancel               = 5,  //已取消(显示)
    SendOrderStatusChangePrice          = 6,  //调价中(展示)
    
    
};
@interface MySendOrderViewController : BaseViewController


@property (nonatomic, assign)SendOrderStatus sendOrderStatus;

@end
