//
//  RegisterCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RegisterCell.h"
#import "VerifyButton.h"

@interface RegisterCell()

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@end

@implementation RegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [_verifyTextField addTarget:self action:@selector(verifyTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];


    
     [_verifyBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    
    _verifyBtn.countDownButtonBlock = ^(UIButton * btn){
        
        LxDBAnyVar(@"开始获取验证码");
        if (_registerCodeCellBlock) {
            _registerCodeCellBlock();
        }
    };
    _verifyBtn.second = 60;


// Initialization code
}

- (void)verifyTextFieldChangeAction:(UITextField *)textfield{
    
    NSString * verify =textfield.text;
    
    if (_registerCellBlock) {
        _registerCellBlock(verify,YES);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
