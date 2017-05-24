//
//  MessageHeaderView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 fhj. All rights reserved.
//  系统消息cell的样式

#import <UIKit/UIKit.h>

@interface MessageHeaderView : UIView
+ (MessageHeaderView *)messageHeaderView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;





@end
