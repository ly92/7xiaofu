//
//  EngineerTureOrderFinishCheckCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerTureOrderFinishCheckCell.h"

@interface EngineerTureOrderFinishCheckCell()

@property (weak, nonatomic) IBOutlet UIButton *checkBtn1;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn11;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn2;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn22;

@end

@implementation EngineerTureOrderFinishCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)checkBtn11Action:(UIButton *)btn {
    
    
    if(btn.selected) return;
    
    btn.selected = !btn.selected;
    _checkBtn1.selected = btn.selected;
    _checkBtn2.selected =!btn.selected;
    _checkBtn22.selected =!btn.selected;
    
    if (_checkBtnCellBlobk) {
        _checkBtnCellBlobk(1);
    }
    
}
- (IBAction)checkBtn22Action:(UIButton *)btn {
    
    if(btn.selected) return;
    btn.selected = !btn.selected;
    _checkBtn2.selected = btn.selected;
    _checkBtn1.selected =!btn.selected;
    _checkBtn11.selected =!btn.selected;
    
    
    if (_checkBtnCellBlobk) {
        _checkBtnCellBlobk(2);
    }
    
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
