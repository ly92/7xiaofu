//
//  SettingPayPassWordViewController.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingPayPassWordViewController : BaseViewController

@property (nonatomic, assign) BOOL isSetNewPassWord;


@property(nonatomic, copy) void (^settingPayPassWordSuccBlock)();


@end
