//
//  SendOrderSwitchCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UISwitch *zhidingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@property(nonatomic, copy) void (^textFieldBlock)(NSString * text);


@property(nonatomic, copy) void (^zhidingSwitchBlock)(BOOL on);


@end
