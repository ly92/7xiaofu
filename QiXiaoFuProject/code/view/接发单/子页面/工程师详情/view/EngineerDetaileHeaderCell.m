//
//  EngineerDetaileHeaderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDetaileHeaderCell.h"

@interface EngineerDetaileHeaderCell()

@property (weak, nonatomic) IBOutlet UIImageView *zizhiImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end


@implementation EngineerDetaileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconImageView.layer.cornerRadius=45/2;
    _iconImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setEngineerDetaileModel:(EngineerDetaileModel *)engineerDetaileModel{

    
    [_iconImageView setImageWithUrl:engineerDetaileModel.member_avatar placeholder:kDefaultImage_header];
    if (engineerDetaileModel.to_user_name.length > 0){
        _nameLab.text = engineerDetaileModel.to_user_name;
    }else{
        _nameLab.text = engineerDetaileModel.member_truename;
    }

    if([engineerDetaileModel.is_real intValue] ==0){
    //【0 未认证】

    }else if ([engineerDetaileModel.is_real intValue] ==1){
    //【1 已认证】
        _zizhiImageView.image = [UIImage imageNamed:@"img_yirenzheng"];
    }else{
    //【2 认证待审核】
    
    }

    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
