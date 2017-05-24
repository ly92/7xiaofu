//
//  EditAdressMarkCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EditAdressMarkCell.h"

@implementation EditAdressMarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _textView.placeholder = @"请输入详细地址";
  
    
    _textView.completionBlock = ^(NSString * text){
        
        if (_editAdressMarkCellBlock) {
            
            _editAdressMarkCellBlock(text);
            
        }

    };
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
