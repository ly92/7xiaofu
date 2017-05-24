//
//  CommentReplyCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CommentReplyCell.h"

@interface CommentReplyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timelAb;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@end


@implementation CommentReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImageView.layer.cornerRadius=14;
    _iconImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setReply_List:(Reply_List *)reply_List{
    [_iconImageView setImageWithUrl:reply_List.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = reply_List.member_truename;
    _timelAb.text = [Utool comment_timeStamp2TimeFormatter:reply_List.time];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"回复：%@",reply_List.content]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kThemeColor
                          range:NSMakeRange(0, 3)];
    _contentLab.attributedText = AttributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
