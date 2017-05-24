//
//  EditAdressCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EditAdressCell.h"
#import "NSString+Utils.h"

@implementation EditAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    [_textField addTarget:self action:@selector(accountTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    
    // Initialization code
}

- (void)accountTextFieldChangeAction:(UITextField *)textfield{
    
    NSString * content =textfield.text;
    
    if (_editAdressCellBlock) {
        if (_indexPath.row == 0) {
            _editAdressCellBlock(content,content.length != 0);
         }
        if (_indexPath.row == 1) {
            _editAdressCellBlock(content,[content isMobelphone]);
        }
        
    }
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
