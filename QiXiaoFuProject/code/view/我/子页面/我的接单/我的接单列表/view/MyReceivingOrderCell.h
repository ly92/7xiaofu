//
//  MyReceivingOrderCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySendOrderModel.h"

@interface MyReceivingOrderCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) MySendOrderModel *mySendOrderModel;

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_cancle)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_GoPay)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_CheHui)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_ChongXinFaBu)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_QuXiaoDingDan)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_QueRenWanCheng)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_Delete)(MySendOrderModel * sendOrderModel,NSIndexPath * cellIndexPath);


@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_TongYi)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_BuTongYi)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnState_Comment)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnChat)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^myReceivingOrderCellWithBtnKaishiGongzuo)(MySendOrderModel * sendOrderModel);

@end
