//
//  CommentCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CommentCell.h"
#import "LPLevelView.h"

@interface CommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timelAb;

@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (nonatomic, strong) LPLevelView *lView;


@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconImageView.layer.cornerRadius=14;
    _iconImageView.clipsToBounds = YES;

    
    _starView.backgroundColor = [UIColor clearColor];
    
    _lView = [LPLevelView new];
    _lView.frame = CGRectMake(0, 0, 80, 18);
    _lView.iconColor = [UIColor colorWithRed:0.97 green:0.78 blue:0.30 alpha:1.00];
    _lView.iconSize = CGSizeMake(30, 30);
    _lView.canScore = NO;
    _lView.levelShowEmpty = NO;
    _lView.level = 1;
    [_lView setScoreBlock:^(float level) {
        NSLog(@"打分：%f", level);
        
    }];
    [_starView addSubview:_lView];
     _lView.centerY = 9;

    // Initialization code
}

- (void)setEvaluation1:(Evaluation1 *)evaluation1{


    [_iconImageView setImageWithUrl:evaluation1.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = evaluation1.member_truename;
    _timelAb.text = [Utool comment_timeStamp2TimeFormatter:evaluation1.time];
    _lView.level = evaluation1.stars;
    _contentLab.text = evaluation1.content;
     
}


- (void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;

    
    [_iconImageView setImageWithUrl:commentModel.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = commentModel.member_truename;
    _timelAb.text = [Utool comment_timeStamp2TimeFormatter:commentModel.time];
    _lView.level = [commentModel.stars floatValue];
    _contentLab.text = commentModel.content;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
