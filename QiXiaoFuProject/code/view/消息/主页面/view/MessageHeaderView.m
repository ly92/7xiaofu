//
//  MessageHeaderView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MessageHeaderView.h"

@implementation MessageHeaderView
+ (MessageHeaderView *)messageHeaderView{
    MessageHeaderView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    [item.iconImageView zy_cornerRadiusRoundingRect];
    
    item.countLab.layer.cornerRadius = 10;
    item.countLab.clipsToBounds  =YES;
    item.contentLab.textColor=YIWANG_LIGHT_GRAY_COLOR;
    
    return item;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
