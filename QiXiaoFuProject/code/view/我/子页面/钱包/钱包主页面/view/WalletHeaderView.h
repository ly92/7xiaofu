//
//  WalletHeaderView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mingxiBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;
+ (WalletHeaderView *)walletHeaderView;

@end
