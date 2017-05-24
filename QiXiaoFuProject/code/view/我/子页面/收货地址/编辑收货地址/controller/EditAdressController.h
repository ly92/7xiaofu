//
//  EditAdressController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"
#import "AdressModel.h"

@interface EditAdressController : BaseViewController

@property (nonatomic, assign) NSInteger isEdit;//  isEdit  1  添加  2 编辑

@property (nonatomic, strong) AdressModel * adressModel;

@property(nonatomic, copy) void (^ editAdressBlock)();


@end
