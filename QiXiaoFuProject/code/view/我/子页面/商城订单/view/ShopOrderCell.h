//
//  ShopOrderCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderModel.h"
#import "OrderDetaileModel.h"



@interface ShopOrderCell : UITableViewCell



@property (nonatomic, strong) ShopOrderModel *shopOrderModel;

@property (nonatomic, strong) OrderDetaileModel *orderDetaileModel;

@property (nonatomic, strong) NSIndexPath *indexPath;;


@end
