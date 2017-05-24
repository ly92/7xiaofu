//
//  MySendOrderCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySendOrderModel.h"

@interface MySendOrderCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) MySendOrderModel *mySendOrderModel;


@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_cancle)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_GoPay)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_CheHui)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_ChongXinFaBu)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_QuXiaoDingDan)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_QueRenWanCheng)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_Delete)(MySendOrderModel * sendOrderModel,NSIndexPath * cellIndexPath);


@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_TongYi)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_BuTongYi)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^mySendOrderCellWithBtnState_Comment)(MySendOrderModel * sendOrderModel);


@property(nonatomic, copy) void (^mySendOrderCellWithBtnChat)(MySendOrderModel * sendOrderModel);

@property(nonatomic, copy) void (^orderSendDetaileCancle_WeiWanCheng)(MySendOrderModel * sendOrderModel);// 未完成




@end
