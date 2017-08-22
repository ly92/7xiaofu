//
//  KnowledgeListCell.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/22.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "KnowledgeListCell.h"

@implementation KnowledgeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImgV.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
