//
//  AXPriceRangeCell.m
//  AXBaseMall
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 King. All rights reserved.
//

#import "FilterViewRangeCell.h"

#define textBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]
#define offset [UIScreen mainScreen].bounds.size.width/3*2

@interface FilterViewRangeCell ()

@end

@implementation FilterViewRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
    [self.priceText1 setBackgroundColor:textBackgroundColor];
    self.priceText1.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceText1.returnKeyType =UIReturnKeyDone;
    
    
    [self.priceText1 addTarget:self action:@selector(priceText1ChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    [self.priceText2 addTarget:self action:@selector(priceText2ChangeAction:) forControlEvents:UIControlEventEditingChanged];

    
    [self.priceText2 setBackgroundColor:textBackgroundColor];
    self.priceText2.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceText2.returnKeyType =UIReturnKeyDone;
}


- (void)priceText1ChangeAction:(UITextField * )textField{

    if (_aXPriceRange1CellBlock) {
        _aXPriceRange1CellBlock(textField.text);
    }
    
}
- (void)priceText2ChangeAction:(UITextField * )textField{
    
    if (_aXPriceRange2CellBlock) {
        _aXPriceRange2CellBlock(textField.text);
    }

}






- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.priceText1 resignFirstResponder];
    [self.priceText2 resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
