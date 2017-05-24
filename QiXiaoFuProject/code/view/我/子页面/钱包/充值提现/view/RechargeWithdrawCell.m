//
//  RechargeWithdrawCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RechargeWithdrawCell.h"

@implementation RechargeWithdrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [_moneyTextField addTarget:self action:@selector(moneyTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    
    // Initialization code
}


- (void)moneyTextFieldChangeAction:(UITextField *)textFiled{

    if (_rechargeWithdrawCellBlock) {
        _rechargeWithdrawCellBlock(textFiled.text);
    }
    
 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
