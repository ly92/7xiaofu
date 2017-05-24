//
//  MeHeadReusableView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MeHeadReusableView.h"

@implementation MeHeadReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headerImageBtn.layer.cornerRadius =  64/2;
    _headerImageBtn.clipsToBounds = YES;
    // Initialization code
}

@end
