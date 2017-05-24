//
//  ShopPayAdressCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarClearingModel.h"
#import "AdressModel.h"
#import "OrderDetaileModel.h"


@interface ShopPayAdressCell : UITableViewCell



@property (nonatomic ,assign)BOOL changeAdress;



@property (nonatomic, strong) ShopCarClearingModel *shopCarClearingModel;


@property (nonatomic, strong) AdressModel *adressModel;


@property (nonatomic, strong) OrderDetaileModel * orderDetaileModel;


@end
