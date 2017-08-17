//
//  EnrollEngineerCell.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/17.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "EnrollEngineerCell.h"


@implementation EnrollEngineerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImgV.layer.cornerRadius = 17.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectedAction {
    if (self.selectedEngineerBlock != nil){
        self.selectedEngineerBlock();
    }
}

@end
