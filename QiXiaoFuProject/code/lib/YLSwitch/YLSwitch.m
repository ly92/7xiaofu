//
//  YLSwitch.m
// QQ:896525689
// Email:zhangyuluios@163.com
//                 _
// /\   /\        | |
// \ \_/ / _   _  | |     _   _
//  \_ _/ | | | | | |    | | | |
//   / \  | |_| | | |__/\| |_| |
//   \_/   \__,_| |_|__,/ \__,_|
//
//  Created by shuogao on 16/6/24.
//  Copyright © 2016年 Yulu Zhang. All rights reserved.
//

#import "YLSwitch.h"
@interface YLSwitch ()

@property (nonatomic,strong) UIButton *leftButton;//左侧按钮
@property (nonatomic,strong) UIButton *rightButton;//右侧按钮
@property (nonatomic,strong) UIButton *thumbView;//滑块
@property (nonatomic,strong) NSString *leftTitles;//左标题
@property (nonatomic,strong) NSString *rightTitles;//右标题
@end

@implementation YLSwitch

#pragma mark -- init

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setLeftAndRightButton];
        self.backgroundColor = [UIColor colorWithRed:243/255. green:143/255. blue:179/255. alpha:1.];
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.;
    }
    return self;
}

- (void)setLeftAndRightButton {

    self.leftButton = [UIButton buttonWithType:UIButtonTypeSystem];

    self.leftButton.frame = CGRectMake(0, 1, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 2);

    self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.rightButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, 1, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 2);

    [self.leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];


    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];

    self.thumbView = [UIButton buttonWithType:UIButtonTypeSystem];
    self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
    self.thumbView.layer.cornerRadius = CGRectGetHeight(self.thumbView.frame) / 2.;
    self.thumbView.backgroundColor = [UIColor whiteColor];

    //取消闪烁
    self.thumbView.adjustsImageWhenHighlighted = NO;
    self.rightButton.adjustsImageWhenHighlighted = NO;
    self.leftButton.adjustsImageWhenHighlighted = NO;

    [self.rightButton setTitle:@"second" forState:UIControlStateNormal];
    [self.leftButton setTitle:@"frist" forState:UIControlStateNormal];
    [self.thumbView setTitle:@"frist" forState:UIControlStateNormal];

    //字体颜色
    UIColor *blackColor = [UIColor whiteColor];
    [self.thumbView setTitleColor:RGB(223, 81, 50) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:blackColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:blackColor forState:UIControlStateNormal];


    [self addSubview:self.thumbView];

    //拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(change:)];
    [self.thumbView addGestureRecognizer:panGesture];
}


#pragma mark -- PanGestureRecognizerEvent

- (void)change:(UIPanGestureRecognizer *)sender {



    CGPoint point = [sender translationInView:self.thumbView];

     //向右
    if (point.x > 0) {

        //不能超过范围
        if (point.x > CGRectGetWidth(self.thumbView.frame)) {
            point.x = CGRectGetWidth(self.thumbView.frame);
        }
        self.thumbView.frame = CGRectMake(point.x, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

        //停止了拖动
        if ([sender state] == UIGestureRecognizerStateEnded) {


            if (point.x >= CGRectGetWidth(self.thumbView.frame) / 2) {

                self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);
                [self.thumbView setTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text forState:UIControlStateNormal];

                 [self settingDelegateWithState:1 title:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text];

            }else {

                self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1,CGRectGetHeight(self.frame) - 2);

            }
        }

    }else {

        //向左
        if (point.x < -CGRectGetWidth(self.thumbView.frame)) {
            point.x = -CGRectGetWidth(self.thumbView.frame);
        }
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 + point.x - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

        //停止了拖动

        if ([sender state] == UIGestureRecognizerStateEnded) {

            if (point.x <= -CGRectGetWidth(self.thumbView.frame) / 2) {

                self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1,CGRectGetHeight(self.frame) - 2);
                [self.thumbView setTitle:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text forState:UIControlStateNormal];
                
                [self settingDelegateWithState:0 title:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text];

                
                
            }else {

                self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

            }
        }

    }

}

#pragma mark -- set/get...

- (void)setLeftTitle:(NSString *)leftTitle{

    if (leftTitle) {
        _leftTitles = leftTitle;
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self.thumbView setTitle:leftTitle forState:UIControlStateNormal];

    }
}

- (void)setRightTitle:(NSString *)rightTitle{

    if (rightTitle) {
        _rightTitles = rightTitle;
        [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
//        [self.thumbView setTitle:rightTitle forState:UIControlStateNormal];
    }

}

- (void)setBgColor:(UIColor *)bgColor {

    if (bgColor) {
        self.backgroundColor = bgColor;
    }
}

- (void)setThumbColor:(UIColor *)thumbColor {

    if (thumbColor) {
        self.thumbView.backgroundColor = thumbColor;
    }
}
#pragma mark -- 左右两侧点击事件

- (void)leftButton:(UIButton *)button {

    //向左
    [self.thumbView setTitle:_leftTitles != nil ? _leftTitles : self.leftButton.titleLabel.text forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.thumbView.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

    } completion:^(BOOL finished) {

    }];
  
    if (button) {
        [self settingDelegateWithState:0 title:_leftTitles != nil?_leftTitles:self.leftButton.titleLabel.text];
     }
 
}

- (void)rightButton:(UIButton *)button {
    
    //向右
    [self.thumbView setTitle:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.thumbView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 1, 1, CGRectGetWidth(self.frame) / 2 - 1, CGRectGetHeight(self.frame) - 2);

    } completion:^(BOOL finished) {

    }];

    
    if (button) {
        [self settingDelegateWithState:1 title:_rightTitles != nil?_rightTitles:self.rightButton.titleLabel.text];
     }
 
}



- (void)settingDelegateWithState:(NSInteger )state title:(NSString *)title{

    if (_delegate && [_delegate respondsToSelector:@selector(switchState:title:)]) {
        [_delegate switchState:state title:title];
    }
}


- (void)jumpto:(NSInteger )index{
    
    if (index ==0) {
        
        [self leftButton:nil];
    }
    if (index ==1) {
        
        [self rightButton:nil];
    }
    
    
}




@end
