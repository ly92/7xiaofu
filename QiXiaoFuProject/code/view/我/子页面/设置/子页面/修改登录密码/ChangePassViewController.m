//
//  ChangePassViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChangePassViewController.h"
#import "RegisterFooterView.h"

#import "LoginCell.h"
#import "LoginPassCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RegisterViewController.h"
#import "ForgetPassViewController.h"
#import "NSString+Utils.h"

@interface ChangePassViewController ()
{
    
    NSString * _idCard;
    NSString * _password;
    NSString * _newPassword;
    
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    
    
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelAction:)];
    
 
    
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    _tableView.tableFooterView = footer;;

    RegisterFooterView * footerView = [RegisterFooterView registerFooterView];
    footerView.frame = footer.bounds;
    [footerView.registerBtn setTitle:@"保存" forState:UIControlStateNormal];
    footerView.protocolBtn.hidden = YES;
    footerView.protocolLab.hidden = YES;
    footerView.checkBtn.hidden = YES;
    [footer addSubview:footerView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"LoginCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPassCell" bundle:nil] forCellReuseIdentifier:@"LoginPassCell"];
    
    [footerView.registerBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        
        if (![_idCard checkUserIdCard]) {
            
            [self showErrorText:@"请输入正确的身份证号码!"];
            return;
        }
        if (_password.length != 6) {
            [self showErrorText:@"请输入原密码!"];
            return;
        }
        if (![_newPassword isPassword]) {
            [self showErrorText:@"请输入6-16为新密码!"];
            return;
        }
        
        
        
        
        NSMutableDictionary * dict = [NSMutableDictionary new];
        dict[@"store_id"] =@"1" ;//	店铺ID
        dict[@"userid"] =kUserId ;//用户ID
        dict[@"old_password"] =_password ;//原密码
        dict[@"password"] =_newPassword ;//	密码
        dict[@"password_confirm"] =_newPassword ;//	确认密码
        dict[@"card"] =_idCard ;//身份证号

        
        [MCNetTool postWithUrl:HttpOp_Edit_password params:dict success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:msg];
             [self.navigationController popViewControllerAnimated:YES];
         } fail:^(NSString *error) {
            [self  showErrorText:error];
        }];
    }];

    
    // Do any additional setup after loading the view from its nib.
}



- (void)cancelAction:(UIBarButtonItem *)item{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
        cell.accountTextField.placeholder = @"请输入身份证号码";
        cell.accountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.loginCellBlock = ^(NSString * account ,BOOL pass){
 
            _idCard = account;
            
        };
//        [cell.accountTextField becomeFirstResponder];
        return cell;
    }
    if (indexPath.row == 1) {
        LoginPassCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginPassCell"];
        cell.eyeBtn.hidden = YES;
        cell.passTextField.placeholder = @"请输入原密码";
        cell.loginPassCellBlock = ^(NSString * password ,BOOL pass){
            _password = password;
            
        };
        return cell;
    }
    if (indexPath.row == 2) {
        LoginPassCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginPassCell"];
        cell.loginPassCellBlock = ^(NSString * password ,BOOL pass){
            _newPassword = password;
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
