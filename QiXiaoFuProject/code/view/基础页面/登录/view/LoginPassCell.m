//
//  LoginPassCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "LoginPassCell.h"
#import "NSString+Utils.h"
@interface LoginPassCell()



@end

@implementation LoginPassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [_passTextField addTarget:self action:@selector(passTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    
    // Initialization code
}

- (void)passTextFieldChangeAction:(UITextField *)textfield{
    
    NSString * password =textfield.text;
    if (_loginPassCellBlock) {
        _loginPassCellBlock(password,[password isPassword]);
    }
}

- (IBAction)eyeBtnAction:(UIButton *)btn {
    
    btn.selected = ! btn.selected;
    _passTextField.secureTextEntry = !btn.selected;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
