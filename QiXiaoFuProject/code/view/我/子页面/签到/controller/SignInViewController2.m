//
//  SignInViewController2.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/7/27.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SignInViewController2.h"
#import "UIView+Utils.h"

@interface SignInViewController2 ()
@property (weak, nonatomic) IBOutlet UILabel *signLbl;
@property (weak, nonatomic) IBOutlet UILabel *signDayLbl;
@property (weak, nonatomic) IBOutlet UIImageView *signLogoImgV;
@property (weak, nonatomic) IBOutlet UILabel *creditsLbl;
@property (weak, nonatomic) IBOutlet UIView *ruleView;
@property (weak, nonatomic) IBOutlet UIView *subRuleView;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;

@end

@implementation SignInViewController2



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签到";
    
    [self setColorWithIndex:0];
    
    [self.ruleView addTapAction:@selector(signRuleAction) forTarget:self];
    self.subRuleView.layer.cornerRadius = 5;
    
    [self setupSubViewsLayouts];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//
- (IBAction)signRuleAction {
    self.ruleView.hidden = !self.ruleView.hidden;
}

- (void)setupSubViewsLayouts{
    NSString *date = [Utool timestamp:[NSDate date]];
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"sign_time"] = date;
    
    [self showLoading];
    [MCNetTool postWithUrl:HttpSignState params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self dismissLoading];
        
        NSInteger is_sign = [[requestDic objectForKey:@"is_sign"] integerValue];
        NSInteger sign_day = [[requestDic objectForKey:@"sign_day"] integerValue];
        self.creditsLbl.text = [NSString stringWithFormat:@"总积分：%ld积分",[[requestDic objectForKey:@"integral"] integerValue]];
        self.signDayLbl.text = [NSString stringWithFormat:@"连续%ld天",[[requestDic objectForKey:@"total_sign_day"] integerValue]];
        if (is_sign == 0){
            self.signBtn.enabled = YES;
            self.signLbl.text = @"签到";
        }else{
            self.signBtn.enabled = NO;
            self.signLbl.text = @"已签到";
        }
        
        if (sign_day > 0 && sign_day < 8){
            [self setColorWithIndex:sign_day];
        }
    } fail:^(NSString *error) {
        [self dismissLoading];
        self.signBtn.enabled = YES;
        self.signLbl.text = @"签到";
        [self showErrorText:error];
    }];
    
}

- (void)setColorWithIndex:(NSInteger)index{
    
    self.signLogoImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"sign_logo_%ld",index]];
    
    
    
//    for (int i = 0; i < self.subview.subviews.count; i ++ ) {
//        UIImageView *imgV = self.subview.subviews[i];
//        if (i < index * 2 - 1){
//            //选中状态
//            if (i % 2 == 0){
//                imgV.image = [UIImage imageNamed:@"sign_icon"];
//            }else{
//                imgV.image = [UIImage imageNamed:@"sign_line"];
//            }
//        }else{
//            //未选中状态
//            if (i % 2 == 0){
//                imgV.image = [UIImage imageNamed:@"unsign_icon"];
//            }else{
//                imgV.image = [UIImage imageNamed:@"unsign_line"];
//            }
//        }
//    }
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
        self.creditsLbl.text = [NSString stringWithFormat:@"总积分：%ld积分",[[requestDic objectForKey:@"integral"] integerValue]];
        self.signDayLbl.text = [NSString stringWithFormat:@"连续%ld天",[[requestDic objectForKey:@"total_sign_day"] integerValue]];
        if (is_sign == 0){
            self.signLbl.text = @"签到";
            self.signBtn.enabled = YES;
        }else{
            self.signBtn.enabled = NO;
            self.signLbl.text = @"已签到";
            [self showSuccessText:@"已签到！"];
        }
        
        if (sign_day > 0 && sign_day < 8){
            [self setColorWithIndex:sign_day];
        }
    } fail:^(NSString *error) {
        [self dismissLoading];
        self.signBtn.enabled = YES;
        self.signLbl.text = @"签到";
        [self showErrorText:error];
    }];
}

@end
