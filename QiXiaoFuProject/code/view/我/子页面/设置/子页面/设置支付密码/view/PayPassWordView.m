//
//  PayPassWordView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PayPassWordView.h"
#import "ACPwdInputView.h"
#import "UIView+ACExtension.h"


#define kColorComplete kThemeColor
#define kColorNormal   [UIColor colorWithWhite:0.584 alpha:1.000]



@interface PayPassWordView()

@property (strong, nonatomic) UILabel *titleLabel;          ///< 标题
@property (strong, nonatomic) ACPwdInputView *pwdInputView; ///< 输入区
@property (strong, nonatomic) UIButton *completeBtn;        ///< 确定
@property (assign, nonatomic, getter=isComplete) BOOL complete; ///< 是否完成
@property (copy, nonatomic) NSString *pwd;                      ///< 密码


@end

@implementation PayPassWordView



#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    //set default value
    self.length = 6;
    
    CGFloat padding = 20.f;
    CGFloat margin = 15.f;
    CGFloat width = frame.size.width;
    CGFloat titleH = 20.f;
    CGFloat inputH = (width-padding*2)/self.length;
    CGFloat btnH = 30.f;
    CGFloat height = titleH+inputH+btnH+margin*4+1.f;
    
    
    self.frame = CGRectMake(0, 0, width, height);
    self.backgroundColor = [UIColor whiteColor];
    
    /** title label */
    self.titleLabel.frame = CGRectMake(padding, margin, inputH*self.length, titleH);
    

    self.pwdInputView.frame = CGRectMake(padding, self.titleLabel.bottom+margin, inputH*self.length, inputH);
    
    
    /** complete button */
    self.completeBtn.frame = CGRectMake(0, self.pwdInputView.bottom + padding + 20, (self.width)/3, btnH);
    
    self.completeBtn.centerX =self.width/2;
    [self addSubview:self.titleLabel];
     [self addSubview:self.pwdInputView];
     [self addSubview:self.completeBtn];
    
    __weak typeof(&*self)weakSelf = self;
    self.pwdInputView.inputDidCompletion = ^(NSString *pwd) {
        if (pwd.length == weakSelf.pwdInputView.length) {
            weakSelf.pwd = pwd;
            weakSelf.complete = YES;
        }else {
            weakSelf.pwd = @"";
            weakSelf.complete = NO;
        }
    };
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Setter/Getter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTrueBtntitle:(NSString *)trueBtntitle{
    _trueBtntitle = trueBtntitle;
    [_completeBtn setTitle:_trueBtntitle forState:UIControlStateNormal];
}

- (void)setLength:(NSUInteger)length {
    _length = length;
    self.pwdInputView.length = length;
}

- (void)setComplete:(BOOL)complete {
    _complete = complete;
    if (complete) {
        self.completeBtn.enabled = YES;
        [self.completeBtn setTitleColor:kColorComplete forState:UIControlStateNormal];
        [_completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_btnbox_red"] forState:UIControlStateNormal];

    }else {
        self.completeBtn.enabled = NO;
        [self.completeBtn setTitleColor:kColorNormal forState:UIControlStateNormal];
        [_completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_btnbox_gray"] forState:UIControlStateNormal];

    }
}

- (ACPwdInputView *)pwdInputView {
    if (!_pwdInputView) {
        _pwdInputView = [[ACPwdInputView alloc] init];
    }
    return _pwdInputView;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithWhite:0.202 alpha:1.000];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _titleLabel;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_completeBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:kColorNormal forState:UIControlStateNormal];
        [_completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_btnbox_gray"] forState:UIControlStateNormal];
        [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [_completeBtn setEnabled:NO];
        [_completeBtn addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

#pragma mark - Public
- (void)showView:(UIView *)view{

    [view addSubview:self];

    [self.pwdInputView becomeFirstResponder];


}


#pragma mark - Privite

- (void)complete:(id)sender {
    if (_completeAction) {
        _completeAction(self.pwd);
    }
}






@end
