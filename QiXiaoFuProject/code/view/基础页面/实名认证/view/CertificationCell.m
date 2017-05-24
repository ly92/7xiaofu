//
//  CertificationCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CertificationCell.h"

@interface CertificationCell()<UITextFieldDelegate>

@end

@implementation CertificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentTextField.delegate = self;
    [_contentTextField addTarget:self action:@selector(accountTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}

- (void)accountTextFieldChangeAction:(UITextField *)textfield{
    
    NSString * content =textfield.text;
    
    if (_certificationCellBlock) {
        _certificationCellBlock(content,YES);
    }
    
}

#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_type == 1) {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = [textField .text length] + [string length] - range.length;
        return newLength <= 11;
    }
    
    if (_type == 2) {
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = [textField .text length] + [string length] - range.length;
        return newLength <= 18;
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
