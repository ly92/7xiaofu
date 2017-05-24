//
//  MineInfoCell.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "MineInfoCell.h"

@implementation MineInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconImageView.layer.cornerRadius = 25;
    _iconImageView.layer.masksToBounds = YES;
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
