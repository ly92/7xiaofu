//
//  AdressListController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "AdressModel.h"

@interface AdressListController : BaseViewController


@property (assign,nonatomic)NSInteger type;// 1 我-收货地址  2  选择收货地址

@property(nonatomic, copy) void (^adressListVCBlock)(AdressModel * adressModel);


@end
