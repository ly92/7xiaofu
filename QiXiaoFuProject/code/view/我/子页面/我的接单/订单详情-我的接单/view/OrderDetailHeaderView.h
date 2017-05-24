//
//  OrderDetailHeaderView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;


+ (OrderDetailHeaderView *)orderDetailHeaderView;

@end
