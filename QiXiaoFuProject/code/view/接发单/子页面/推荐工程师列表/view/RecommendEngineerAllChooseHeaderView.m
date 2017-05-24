//
//  RecommendEngineerAllChooseHeaderView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RecommendEngineerAllChooseHeaderView.h"

@implementation RecommendEngineerAllChooseHeaderView

+ (RecommendEngineerAllChooseHeaderView *)recommendEngineerAllChooseHeaderView{
    RecommendEngineerAllChooseHeaderView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
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
