//
//  ChooseSeviceDomainCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseSeviceDomainCell.h"

@implementation ChooseSeviceDomainCell

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
    
    
    self.chooseBtn.selected = self.selected;
}

- (void)setUser:(Service_Sector12 *)user {
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
        
        NSString * name = [self.user.gc_name length] ? self.user.gc_name : @"此人不具名";
        
        [self.chooseBtn setTitle:name forState:UIControlStateNormal];
    } else {
        [self.chooseBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    self.chooseBtn.alpha = self.disabled ? 0.5 : 1;
}




@end
