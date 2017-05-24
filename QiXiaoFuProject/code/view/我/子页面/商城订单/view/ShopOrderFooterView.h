//
//  ShopOrderFooterView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderModel.h"
#import "OrderDetaileModel.h"

@interface ShopOrderFooterView : UIView
+ (ShopOrderFooterView *)shopOrderFooterView;


@property (nonatomic, strong) ShopOrderModel *shopOrderModel;

@property (nonatomic, strong) OrderDetaileModel *orderDetaileModel;

@property (nonatomic, strong) NSIndexPath *indexPath;;
@property (nonatomic, copy) NSString * order_id;;


@property(nonatomic, copy) void (^shopOrderCellCancleBlock)(NSString * order_id,NSIndexPath * cellIndexPath);
@property(nonatomic, copy) void (^shopOrderCellPayBlock)(NSString * order_id,NSString * pay_sn,NSString * order_price,NSIndexPath * cellIndexPath);
@property(nonatomic, copy) void (^shopOrderCellTiXingFaHuoBlock)(NSString * order_sn,NSIndexPath * cellIndexPath);
@property(nonatomic, copy) void (^shopOrderCellQueRenShouHuoBlock)(NSString * order_id,NSIndexPath * cellIndexPath);
@property(nonatomic, copy) void (^shopOrderCellDeleateBlock)(NSString * order_id,NSIndexPath * cellIndexPath);
@property(nonatomic, copy) void (^shopOrderCellTuiHuanHuoBlock)(NSString * order_id,NSIndexPath * cellIndexPath);


@end
