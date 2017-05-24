//
//  VerifyButton.h
//  VerifyButton
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//


#import <UIKit/UIKit.h>
@class VerifyButton;
typedef void (^ClickCountDownButtonBlock)(UIButton * btn);

@interface VerifyButton : UIButton
@property(nonatomic , assign) int second; //开始时间数
@property(nonatomic , copy) ClickCountDownButtonBlock countDownButtonBlock; //点击按钮
// 开始跑时间
- (void)runVerifyButtonSecondTime;
@end
