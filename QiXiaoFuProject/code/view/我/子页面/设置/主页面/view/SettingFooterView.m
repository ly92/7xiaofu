//
//  SettingFooterView.m
//  meirong
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SettingFooterView.h"

@implementation SettingFooterView
+ (SettingFooterView *)settingFooterView {
    SettingFooterView *headerView = [[NSBundle mainBundle] loadNibNamed:@"SettingFooterView" owner:self options:nil][0];
//    [headerView.exitBtn setTitleColor:kBackgroundColor forState:UIControlStateNormal];
    return headerView;
}


@end
