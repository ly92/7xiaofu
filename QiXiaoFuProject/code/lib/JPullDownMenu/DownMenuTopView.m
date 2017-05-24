//
//  DownMenuTopView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "DownMenuTopView.h"

@implementation DownMenuTopView

+ (DownMenuTopView *)downMenuTopView{
      DownMenuTopView *headerView = [[NSBundle mainBundle] loadNibNamed:@"DownMenuTopView" owner:self options:nil][0];
    return headerView;
 }



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
