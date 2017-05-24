//
//  LoginCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "LoginCell.h"
#import "NSString+Utils.h"

@interface LoginCell()

@end

@implementation LoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [_accountTextField addTarget:self action:@selector(accountTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}

- (void)accountTextFieldChangeAction:(UITextField *)textfield{

     NSString * account =textfield.text;
    

    
     if (_loginCellBlock) {
        _loginCellBlock(account,[account isMobelphone]);
    }
    



}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
