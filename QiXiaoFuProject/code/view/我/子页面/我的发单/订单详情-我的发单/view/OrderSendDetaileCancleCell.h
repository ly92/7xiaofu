//
//  OrderSendDetaileCancleCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetaileProModel.h"

@interface OrderSendDetaileCancleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftLeftBtn;

//@property (nonatomic, copy) NSString *is_eval;
//@property (nonatomic, assign) NSInteger t_state;
//@property (nonatomic, assign) NSInteger bill_statu;
//@property (nonatomic, assign) NSInteger pay_statu;

@property (nonatomic, strong) OrderDetaileProModel * orderDetaileProModel;

@property(nonatomic, copy) void (^orderSendDetaileCancle_cancle)();// 取消订单

@property(nonatomic, copy) void (^orderSendDetaileCancle_GoPay)();// 去支付

@property(nonatomic, copy) void (^orderSendDetaileCancle_CheHui)();// 撤回

@property(nonatomic, copy) void (^orderSendDetaileCancle_ChongXinFaBu)();// 重新发布

@property(nonatomic, copy) void (^orderSendDetaileCancle_QueRenWanCheng)();// 确认完成


@property(nonatomic, copy) void (^orderSendDetaileCancle_Delete)();// 删除

@property(nonatomic, copy) void (^orderSendDetaileCancle_Tiaojia)(UIButton * btn);// 调价

@property(nonatomic, copy) void (^orderSendDetaileCancle_Comment)();// 去评价
@property(nonatomic, copy) void (^orderSendDetaileSee_Comment)();// 查看评价
@property(nonatomic, copy) void (^orderSendDetaileCancle_WeiWanCheng)();// 未完成
@property(nonatomic, copy) void (^orderSendDetaileUsedGoods_Btn)();//




@end
