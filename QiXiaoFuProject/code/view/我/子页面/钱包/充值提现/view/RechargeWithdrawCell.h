//
//  RechargeWithdrawCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BXTextField.h"
@interface RechargeWithdrawCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
 


@property(nonatomic, copy) void (^rechargeWithdrawCellBlock)(NSString * money);






@end
