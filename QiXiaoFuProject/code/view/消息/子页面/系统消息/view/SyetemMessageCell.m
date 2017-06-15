//
//  SyetemMessageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SyetemMessageCell.h"
#import "NSDate+Utils.h"

@interface SyetemMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *bgVIew;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;


@end

@implementation SyetemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _bgVIew.layer.cornerRadius = 10;
    _bgVIew.clipsToBounds = YES;
    
    // Initialization code
}


- (void)setMessageModel:(SysTemMessageModel *)messageModel{

    NSDate *time = [NSDate dateWithTimeIntervalSince1970:[messageModel.message_time doubleValue]];
    if ([time isToday]){
        _timeLab.text = [NSString stringWithFormat:@"今天 %@",[Utool messageIndex_timeStamp2TimeFormatter:messageModel.message_time]];
    }else if ([time isYesterday]){
        _timeLab.text =  [NSString stringWithFormat:@"昨天 %@",[Utool messageIndex_timeStamp2TimeFormatter:messageModel.message_time]];
    }else{
        _timeLab.text = [Utool timeStampPointTimeFormatter:messageModel.message_time];
    }
    
    _titleLab.text = messageModel.from_member_name;
    _contentLab.text = messageModel.message_body;
    
    if (messageModel.message_open ==0) {
        
        _titleLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _timeLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _contentLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
    }else{
        
        _titleLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _timeLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _contentLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
    }

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
