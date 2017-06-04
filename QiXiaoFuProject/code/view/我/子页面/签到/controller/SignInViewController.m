//
//  SignInViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/1.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line3;
@property (weak, nonatomic) IBOutlet UIImageView *line4;
@property (weak, nonatomic) IBOutlet UIImageView *line5;
@property (weak, nonatomic) IBOutlet UIImageView *line6;

@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIImageView *imgV4;
@property (weak, nonatomic) IBOutlet UIImageView *imgV5;
@property (weak, nonatomic) IBOutlet UIImageView *imgV6;
@property (weak, nonatomic) IBOutlet UIImageView *imgV7;


@property (weak, nonatomic) IBOutlet UIView *subview;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签到";
    
    [self setColorWithIndex:0];
    
    [self setupSubViewsLayouts];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupSubViewsLayouts{
    self.signinBtn.layer.cornerRadius = 50;

    NSString *date = [Utool timestamp:[NSDate date]];
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"sign_time"] = date;
    
    [self showLoading];
    [MCNetTool postWithUrl:HttpSignState params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self dismissLoading];
        
        NSInteger is_sign = [[requestDic objectForKey:@"is_sign"] integerValue];
        NSInteger sign_day = [[requestDic objectForKey:@"sign_day"] integerValue];
        if (is_sign == 0){
            self.signinBtn.enabled = YES;
            [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        }else{
            self.signinBtn.enabled = NO;
            [self.signinBtn setTitle:@"已签到" forState:UIControlStateNormal];
        }
        
        if (sign_day > 0 && sign_day < 8){
            [self setColorWithIndex:sign_day];
        }
    } fail:^(NSString *error) {
        [self dismissLoading];
        self.signinBtn.enabled = YES;
        [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        [self showErrorText:error];
    }];
    
}

- (void)setColorWithIndex:(NSInteger)index{
    
    for (int i = 0; i < self.subview.subviews.count; i ++ ) {
        UIImageView *imgV = self.subview.subviews[i];
        if (i < index * 2 - 1){
            //选中状态
            if (i % 2 == 0){
            imgV.image = [UIImage imageNamed:@"sign_icon"];
            }else{
            imgV.image = [UIImage imageNamed:@"sign_line"];
            }
        }else{
            //未选中状态
            if (i % 2 == 0){
                imgV.image = [UIImage imageNamed:@"unsign_icon"];
            }else{
                imgV.image = [UIImage imageNamed:@"unsign_line"];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signAction {
    NSString *date = [Utool timestamp:[NSDate date]];
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"sign_time"] = date;
    
    [self showLoading];
    [MCNetTool postWithUrl:HttpSignIn params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self dismissLoading];
        
        NSInteger is_sign = [[requestDic objectForKey:@"is_sign"] integerValue];
        NSInteger sign_day = [[requestDic objectForKey:@"sign_day"] integerValue];
        if (is_sign == 0){
            self.signinBtn.enabled = YES;
            [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        }else{
            self.signinBtn.enabled = NO;
            [self.signinBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [self showSuccessText:@"已签到"];
        }
        
        if (sign_day > 0 && sign_day < 8){
            [self setColorWithIndex:sign_day];
        }
    } fail:^(NSString *error) {
        [self dismissLoading];
        self.signinBtn.enabled = YES;
        [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        [self showErrorText:error];
    }];
}


@end
