//
//  SyetemMessageRemindCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SyetemMessageRemindCell.h"
#import "NSDate+Utils.h"

@interface SyetemMessageRemindCell ()

@property (weak, nonatomic) IBOutlet UIView *bgVIew;


@end


@implementation SyetemMessageRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _bgVIew.layer.cornerRadius = 10;
    _bgVIew.clipsToBounds = YES;
    
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath{

    _acceptBtn.tag = indexPath.section;
    _ignoreBtn.tag = indexPath.section;

}


- (void)setMessageModel:(SysTemMessageModel *)messageModel{
    _titleLab.text = messageModel.from_member_name;
    
    NSDate *time = [NSDate dateFromString:messageModel.message_time];
    if ([time isToday]){
     _timeLab.text = [NSString stringWithFormat:@"今天 %@",[Utool messageIndex_timeStamp2TimeFormatter:messageModel.message_time]];
    }else if ([time isYesterday]){
     _timeLab.text =  [NSString stringWithFormat:@"昨天 %@",[Utool messageIndex_timeStamp2TimeFormatter:messageModel.message_time]];
    }else{
     _timeLab.text = [Utool timeStampPointTimeFormatter:messageModel.message_time];
    }
    
   
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
