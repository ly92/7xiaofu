//
//  OrderDetailHeaderView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetailHeaderView.h"

@implementation OrderDetailHeaderView

+ (OrderDetailHeaderView *)orderDetailHeaderView{
    OrderDetailHeaderView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return item;
}

- (IBAction)orderNumBtnAction {
    NSString *str = self.orderNumBtn.titleLabel.text;
    NSString *orderNum = [str stringByReplacingOccurrencesOfString:@"订单序号 " withString:@""];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = orderNum;
    [self showSuccessText:[NSString stringWithFormat:@"已复制订单号：%@",orderNum]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
