//
//  SendOrderSwitchCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SendOrderSwitchCell.h"

@interface SendOrderSwitchCell()<UITextFieldDelegate>

@end

@implementation SendOrderSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     [_textField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [_zhidingSwitch addTarget:self action:@selector(zhidingSwitchChangeAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)textFieldChangeAction:(UITextField *)textField{
    
    if (_textFieldBlock) {
        _textFieldBlock(textField.text);
    }

}

- (void)zhidingSwitchChangeAction:(UISwitch * )sw{

    if(_zhidingSwitchBlock){
        _zhidingSwitchBlock(sw.on);
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textAlignment = NSTextAlignmentLeft;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textAlignment = NSTextAlignmentRight;
}


@end
