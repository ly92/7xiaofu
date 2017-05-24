//
//  PayPriceViewCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPriceViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property(nonatomic, copy) void (^switchViewBlock)(BOOL on,UISwitch * sw);
@property(nonatomic, copy) void (^priceTextFieldBlock)(NSString * text);

@end
