//
//  OrderDetaileCancleCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetaileCancleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftLeftBtn;
 
@property (nonatomic, assign) NSInteger t_state;
@property (nonatomic, assign) NSInteger pay_statu;
@property (nonatomic, assign) NSInteger bill_statu;
@property (nonatomic, assign) NSInteger move_state;
@property (nonatomic, assign) NSInteger move_count;




@property(nonatomic, copy) void (^orderDetaileCancle_cancle)();

@property(nonatomic, copy) void (^orderDetaileCancle_GoPay)();

@property(nonatomic, copy) void (^orderDetaileCancle_CheHui)();


@property(nonatomic, copy) void (^orderDetaileCancle_ChongXinFaBu)();


@property(nonatomic, copy) void (^orderDetaileCancle_QuXiaoDingDan)();

@property(nonatomic, copy) void (^orderDetaileCancle_QueRenWanCheng)();


@property(nonatomic, copy) void (^orderDetaileCancle_Delete)();


@property(nonatomic, copy) void (^orderDetaileCancle_TongYi)();// 同意

@property(nonatomic, copy) void (^orderDetaileCancle_BuTongYi)();// 不同意

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnKaishiGongzuo)();

@property(nonatomic, copy) void (^orderDetaileTransfer_Btn)();//转移订单
@property(nonatomic, copy) void (^orderDetaileTransfer_BtnRefuse)();//转移订单
@property(nonatomic, copy) void (^orderDetaileTransfer_BtnAgree)();//转移订单


@end
