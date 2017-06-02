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

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UILabel *line4;
@property (weak, nonatomic) IBOutlet UILabel *line5;
@property (weak, nonatomic) IBOutlet UILabel *line6;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;
@property (weak, nonatomic) IBOutlet UIView *subview;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签到";
    
    [self setupSubViewsLayouts];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self signAction];
}

- (void)setupSubViewsLayouts{
    self.signinBtn.layer.cornerRadius = 50;
    self.lbl1.layer.cornerRadius = 10;
    self.lbl2.layer.cornerRadius = 10;
    self.lbl3.layer.cornerRadius = 10;
    self.lbl4.layer.cornerRadius = 10;
    self.lbl5.layer.cornerRadius = 10;
    self.lbl6.layer.cornerRadius = 10;
    self.lbl7.layer.cornerRadius = 10;
    
    self.textView.contentOffset = CGPointMake(0, 0);
    
    for (UIView *view in self.subview.subviews) {
        view.backgroundColor = [UIColor grayColor];
    }
}

- (void)setColorWithIndex:(NSInteger)index{
    
    for (int i = 0; i < index * 2 -1; i ++) {
        UIView *view = self.subview.subviews[i];
        view.backgroundColor = [UIColor orangeColor];
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
            self.signinBtn.backgroundColor = [UIColor orangeColor];
            [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        }else{
            self.signinBtn.enabled = NO;
            self.signinBtn.backgroundColor = [UIColor grayColor];
            [self.signinBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [self showSuccessText:@"已签到"];
        }
        
        if (sign_day > 0 && sign_day < 8){
            [self setColorWithIndex:sign_day];
        }
    } fail:^(NSString *error) {
        [self dismissLoading];
        self.signinBtn.enabled = YES;
        self.signinBtn.backgroundColor = [UIColor orangeColor];
        [self.signinBtn setTitle:@"签到" forState:UIControlStateNormal];
        [self showErrorText:error];
    }];
}


@end
