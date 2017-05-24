//
//  PayPriceViewCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PayPriceViewCell.h"

@implementation PayPriceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_switchView addTarget:self action:@selector(switchViewChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_priceTextField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];

}

- (void)switchViewChangeAction:(UISwitch * )sw{
    if(_switchViewBlock){
        _switchViewBlock(sw.on,sw);
    }
}

- (void)textFieldChangeAction:(UITextField *)textField{
    
    if (_priceTextFieldBlock) {
        _priceTextFieldBlock(textField.text);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
