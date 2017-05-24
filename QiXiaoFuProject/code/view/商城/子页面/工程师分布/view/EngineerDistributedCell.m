//
//  EngineerDistributedCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDistributedCell.h"

@implementation EngineerDistributedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _iconImageView.layer.cornerRadius = 45/2;
    _iconImageView.clipsToBounds = YES;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
