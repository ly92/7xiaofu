//
//  ShopOrderHeaderView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderModel.h"
#import "OrderDetaileModel.h"


@interface ShopOrderHeaderView : UIView

//+ (ShopOrderHeaderView *)shopOrderHeaderView;

@property (nonatomic, strong) ShopOrderModel *shopOrderModel;

@property (nonatomic, strong) OrderDetaileModel *orderDetaileModel;

@property (nonatomic, strong) NSIndexPath *indexPath;;
@property (nonatomic, copy) NSString * order_id;;

@end
