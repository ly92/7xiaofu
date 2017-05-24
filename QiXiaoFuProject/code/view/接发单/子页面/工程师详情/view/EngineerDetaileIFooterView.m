//
//  EngineerDetaileIFooterView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDetaileIFooterView.h"

@implementation EngineerDetaileIFooterView
+ (EngineerDetaileIFooterView *)engineerDetaileIFooterView{
    EngineerDetaileIFooterView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
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
