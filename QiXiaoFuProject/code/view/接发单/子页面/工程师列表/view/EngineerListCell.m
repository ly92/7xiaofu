//
//  EngineerCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerListCell.h"

@interface EngineerListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *lingyuLab;

@property (weak, nonatomic) IBOutlet UILabel *quyuLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *yearLab;

@end


@implementation EngineerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius=10;
    _bgView.clipsToBounds = YES;

    _iconImageView.layer.cornerRadius=14;
    _iconImageView.clipsToBounds = YES;
    
    
    // Initialization code
}

- (void)setEngineerModel:(EngineerModel *)engineerModel{

    _engineerModel = engineerModel;
    
    [_iconImageView setImageWithUrl:engineerModel.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = engineerModel.member_truename;
    NSString *spaceTimeStr = [NSString stringWithFormat:@"%@-%@",[Utool timeStamp3TimeFormatter:engineerModel.service_stime],
                              [Utool timeStamp3TimeFormatter:engineerModel.service_etime]];
    if ([spaceTimeStr hasPrefix:@"1970年01月01日"]){
        _timeLab.text = @"未设置";
    }else{
        _timeLab.text = spaceTimeStr;
    }
    _yearLab.text = [NSString stringWithFormat:@"%@年",engineerModel.working_year];

    _quyuLab.text = checkNull([engineerModel.tack_citys componentsJoinedByString:@"、"], @"   ");
    _lingyuLab.text = [engineerModel.service_sector componentsJoinedByString:@"、"];

    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
