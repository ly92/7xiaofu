//
//  PickerViewCell.m
//  CollectionViewSelect
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self updateCheckBtnState];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.user = nil;
    self.disabled = NO;
    
    [self updateCheckBtnState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self updateCheckBtnState];
}

- (void)setDisabled:(BOOL)disabled {
    if (_disabled == disabled) {
        return;
    }
    _disabled = disabled;
    
    [self updateViews];
}

- (void)updateCheckBtnState {
    
    
     self.titleBtn.selected = self.selected;
}

- (void)setUser:(User *)user {
    if (_user == user) {
        return;
    }
    _user = user;
    
    [self updateViews];
}

- (void)updateViews {
     [self updateNameLabel];
}

- (void)updateNameLabel {
    if (self.user) {
        
        NSString * name = [self.user.nickName length] ? self.user.nickName : @"此人不具名";
        
        [self.titleBtn setTitle:name forState:UIControlStateNormal];
    } else {
         [self.titleBtn setTitle:@"" forState:UIControlStateNormal];
     }
    
    self.titleBtn.alpha = self.disabled ? 0.5 : 1;
}

@end
