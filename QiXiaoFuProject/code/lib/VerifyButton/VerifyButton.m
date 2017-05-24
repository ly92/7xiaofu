//
//  VerifyButton.m
//  VerifyButton
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//


#import "VerifyButton.h"

@implementation VerifyButton
{
    NSTimer *_timer;
    int _initialTimer;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitle:@"获取验证码" forState:0];
        self.layer.cornerRadius = 5.0;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addTarget:self action:@selector(verifyButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.layer.cornerRadius = 5.0;
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addTarget:self action:@selector(verifyButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}
-(void)setSecond:(int)second{
    _second = second;
    _initialTimer = _second;
}
-(void)verifyButtonClickAction:(VerifyButton *)btn{
    
    //获取验证码
    if (_countDownButtonBlock) {
        _countDownButtonBlock(btn);
    }

 
}
// 开始跑时间
- (void)runVerifyButtonSecondTime{
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%02d 秒后重新获取",_second] forState:UIControlStateDisabled];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];

}

-(void)timerStart:(NSTimer *)theTimer {
    if (_initialTimer == 1){
        _initialTimer = _second;
        [self stop];
    }else{
        _initialTimer--;
        [self setTitle:[NSString stringWithFormat:@"%02d 秒后重新获取",_initialTimer] forState:UIControlStateDisabled];
    }
}
- (void)stop{
     if (_timer) {
        [_timer invalidate]; //停止计时器
        self.enabled = YES;
        [self setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}
-(void)dealloc{  //销毁计时器
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
