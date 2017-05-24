//
//  ForgetPassViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RegisterFooterView.h"
#import "LoginCell.h"
#import "LoginPassCell.h"
#import "RegisterCell.h"
#import "NSString+Utils.h"

@interface ForgetPassViewController (){
    
    NSString * _account;
    NSString * _verifyCode;
    NSString * _password;
    
    
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    
    
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    foot.backgroundColor = [UIColor clearColor];
    RegisterFooterView * footerView = [RegisterFooterView registerFooterView];
    [footerView.registerBtn setTitle:@"保存" forState:UIControlStateNormal];
    footerView.protocolBtn.hidden = YES;
    footerView.protocolLab.hidden = YES;
    footerView.checkBtn.hidden = YES;

    footerView.frame = CGRectMake(0, 0, kScreenWidth, 205);
    [foot addSubview:footerView];
    
    _tableView.tableFooterView = foot;;
    
    [_tableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"LoginCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPassCell" bundle:nil] forCellReuseIdentifier:@"LoginPassCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RegisterCell" bundle:nil] forCellReuseIdentifier:@"RegisterCell"];
    
    
    [footerView.registerBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
 
        
        if (![_account isMobelphone]) {
            
            [self showErrorText:@"请输入正确的手机号码!"];
            return;
        }
        if (_verifyCode.length != 4) {
            
            [self showErrorText:@"请输入4位验证码!"];
            return;
        }
        if (![_password isPassword]) {
            [self showErrorText:@"请输入6-16为密码!"];
            return;
        }

        NSMutableDictionary * dict = [NSMutableDictionary new];
        dict[@"phone"] =_account ;
        dict[@"password"] =_password ;
        dict[@"verif"] =_verifyCode ;

        [MCNetTool postWithUrl:HttpResetPass params:dict success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:@"密码修改成功"];
            [self .navigationController popViewControllerAnimated:YES];
        } fail:^(NSString *error) {
            [self  showErrorText:error];
        }];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)cancelAction:(UIBarButtonItem *)item{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LoginCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
        cell.loginCellBlock = ^(NSString * account ,BOOL pass){
             _account = account;
         };
        return cell;
    }
    if (indexPath.row == 1) {
        __weak RegisterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
        cell.registerCellBlock = ^(NSString * verify ,BOOL pass){
            
            if ([_account isMobelphone]) {
                [cell.verifyBtn runVerifyButtonSecondTime];
            }
            _verifyCode = verify;
         };
        cell.registerCodeCellBlock= ^(){
            
            if (![_account isMobelphone]) {
                [self showErrorText:@"请输入正确的手机号码!"];
                return;
            }
            
            NSMutableDictionary * dict = [NSMutableDictionary new];
            dict[@"mobile"] =_account;
            dict[@"t"] =@"2";
            [MCNetTool postWithUrl:HttpVerify params:dict success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                
                [cell.verifyBtn runVerifyButtonSecondTime];

            } fail:^(NSString *error) {
                [self  showErrorText:error];
            }];
        };
        return cell;
    }
    if (indexPath.row == 2) {
        LoginPassCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginPassCell"];
        cell.loginPassCellBlock = ^(NSString * password ,BOOL pass){
            _password = password;
        };
        return cell;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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
