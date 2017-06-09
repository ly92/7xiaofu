//
//  AssociationCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssociationModel.h"

@interface AssociationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeftDis;
@property (weak, nonatomic) IBOutlet UIButton *settingMarkBtn;

@property (nonatomic, strong) User_To_Me *user_to_me;

@property (nonatomic, strong) Me_To_User *me_to_user;

@property (nonatomic, strong) AZi *azi;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property(nonatomic, copy) void (^openBlock)();//
@property(nonatomic, copy) void (^refreshBlock)();//
@end
