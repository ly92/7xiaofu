//
//  RechargeWithdrawFooterView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RechargeWithdrawFooterView.h"

@implementation RechargeWithdrawFooterView
+ (RechargeWithdrawFooterView *)footerView{
    RechargeWithdrawFooterView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
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
