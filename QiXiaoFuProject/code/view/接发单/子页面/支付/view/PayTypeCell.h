//
//  PayTypeCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *aliPayTitle;
@property (weak, nonatomic) IBOutlet UILabel *wechatPayTitleLab;


@property (weak, nonatomic) IBOutlet UIButton *alipayCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatPayCheckBtn;

@property (weak, nonatomic) IBOutlet UIButton *alipayCheckBtn_D;

@property (weak, nonatomic) IBOutlet UIButton *wechatPayCheckBtn_D;


@property(nonatomic, copy) void (^payTypeCellBlobk)(NSInteger payType);// paytype 1  支付宝 2 微信


- (void)changeBtnState:(CGFloat )price;


@end
