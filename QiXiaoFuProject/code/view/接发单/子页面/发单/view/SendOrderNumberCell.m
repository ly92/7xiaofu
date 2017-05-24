//
//  SendOrderNumberCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SendOrderNumberCell.h"

@implementation SendOrderNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    [_numTextField addTarget:self action:@selector(numTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];

}

- (void)numTextFieldChangeAction:(UITextField *)textField{

    if (_numTextFieldBlock) {
        _numTextFieldBlock(textField.text);
    }
    
    
}

- (void)textFieldChangeAction:(UITextField *)textField{
    if (_textFieldBlock) {
        _textFieldBlock(textField.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
