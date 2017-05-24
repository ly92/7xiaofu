//
//  SettingPayPassWordViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SettingPayPassWordViewController.h"
#import "PayPassWordView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Utils.h"

@interface SettingPayPassWordViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) PayPassWordView *payPassWordView1;
@property (nonatomic, strong) PayPassWordView *payPassWordView2;
@property (nonatomic, strong) PayPassWordView *payPassWordView3;

@property (nonatomic, copy) NSString  *pass1;
@property (nonatomic, copy) NSString  *pass2;
@property (nonatomic, copy) NSString  *pass3;

@property (nonatomic, copy) NSString  *passTitle;




@end

@implementation SettingPayPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_isSetNewPassWord) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
        _passTitle = @"请输入6位数字密码";
        self.navigationItem.title = @"修改支付密码1/3";
        
        
        
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self payPassWordView1];
        _payPassWordView2.frame = CGRectMake(kScreenWidth, 30, kScreenWidth, 300);
    
    }else{
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
        _passTitle = @"请设置6位数字新密码";
        self.navigationItem.title = @"设置支付密码1/2";
        
        [self payPassWordView2WithOld_paypwd:nil];
    }

    // Do any additional setup after loading the view from its nib.
}


- (PayPassWordView *)payPassWordView1{

     if (!_payPassWordView1) {
        _payPassWordView1 = [[PayPassWordView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 300)];
        _payPassWordView1.title = @"请输入原密码";
        WEAKSELF
        _payPassWordView1.completeAction = ^(NSString *pwd){
            NSLog(@"==pwd:%@", pwd);
            
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"paypwd"] = [pwd MD5];
     
            //  验证输入的原支付密码是否争取为
            [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
                
                
                NSInteger  statu = [requestDic[@"statu"] integerValue];
                
                if (statu == 3) {
                    [weakSelf showErrorText:@"原密码不正确"];
                    return ;
                }
                
                if(weakSelf.isSetNewPassWord){
                    weakSelf.navigationItem.title = @"修改支付密码2/3";
                }
                [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
                [weakSelf payPassWordView2WithOld_paypwd:pwd];
                weakSelf.payPassWordView2.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 300);

                
            } fail:^(NSString *error) {
                
                [weakSelf showErrorText:error];

            }];
            
        };
        [_payPassWordView1 showView:_scrollView];
    }
     return _payPassWordView1;
}

- (PayPassWordView *)payPassWordView2WithOld_paypwd:(NSString *)old_paypwd{
    
    if (!_payPassWordView2) {
        _payPassWordView2 = [[PayPassWordView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 300)];
        _payPassWordView2.title = _passTitle;
        WEAKSELF
        _payPassWordView2.completeAction = ^(NSString *pwd){
            NSLog(@"==pwd:%@", pwd);
            
            if(!weakSelf.isSetNewPassWord){
                weakSelf.navigationItem.title = @"设置支付密码2/2";
            }else{
                 weakSelf.navigationItem.title = @"修改支付密码3/3";
            }
            
            [weakSelf.scrollView setContentOffset:CGPointMake(kScreenWidth*2, 0) animated:YES];
            [weakSelf payPassWordView3WithPass:pwd withOld_paypwd:old_paypwd];
            weakSelf.payPassWordView3.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, 300);
            
            
        };
        [_payPassWordView2 showView:_scrollView];
    }
    return _payPassWordView2;
}

- (PayPassWordView *)payPassWordView3WithPass:(NSString *)pass withOld_paypwd:(NSString *)old_paypwd{
    
    
    WEAKSELF
    
    if (!_payPassWordView3) {
        _payPassWordView3 = [[PayPassWordView alloc] initWithFrame:CGRectMake(kScreenWidth, 30, kScreenWidth, 300)];
        _payPassWordView3.title = @"重复密码";
        _payPassWordView3.completeAction = ^(NSString *pwd){
            NSLog(@"==pwd:%@", pwd);
            
            if(![pass isEqualToString:pwd]){
                [weakSelf showErrorText:@"两次输入的密码不一致"];
                return ;
            }
            
            if ( !weakSelf.isSetNewPassWord) {
                //设置支付密码
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"paypwd"] = pwd;
  
                
                [MCNetTool postWithUrl:HttpMeSetPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [weakSelf showSuccessText:@"支付密码设置成功"];
                    
                    if (weakSelf.settingPayPassWordSuccBlock) {
                        weakSelf.settingPayPassWordSuccBlock();
                    }
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                } fail:^(NSString *error) {
                    [weakSelf showErrorText:error];
                }];
                
            }else{
                // 修改支付密码

                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"old_paypwd"] = old_paypwd;
                params[@"paypwd"] = pwd;

                
                [MCNetTool postWithUrl:HttpMeUpPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [weakSelf showSuccessText:@"支付密码修改成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } fail:^(NSString *error) {
                    [weakSelf showErrorText:error];
                }];
            }
        };
        [_payPassWordView3 showView:_scrollView];
    }
    return _payPassWordView3;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
