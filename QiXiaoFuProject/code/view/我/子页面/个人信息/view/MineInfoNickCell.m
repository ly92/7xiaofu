//
//  MineInfoNickCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MineInfoNickCell.h"

@interface MineInfoNickCell()<UITextFieldDelegate>



@end

@implementation MineInfoNickCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     [_textFiled addTarget:self action:@selector(textFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    _textFiled.delegate = self;
    // Initialization code
}
- (void)textFieldChangeAction:(UITextField *)textfield{
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSString * content =textField.text;
    
    if (_mineInfoNickCellBlock) {
        _mineInfoNickCellBlock(content);
    }

    return YES;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
