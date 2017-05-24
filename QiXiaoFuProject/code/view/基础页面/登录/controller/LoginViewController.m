//
//  LoginViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginHeaderView.h"
#import "LoginFooterView.h"
#import "LoginCell.h"
#import "LoginPassCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RegisterViewController.h"
#import "ForgetPassViewController.h"
#import "NSString+Utils.h"
#import "UserInfoModel.h"
#import "JPUSHService.h"
#import "EaseModHelper.h"


@interface LoginViewController (){

    NSString  * _account;
    NSString  * _password;
    NSInteger   _num;

}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) LoginFooterView *footerView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    
    _num = 0;
    
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelAction:)];

    
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    
    LoginHeaderView * headerView = [LoginHeaderView loginHeaderView];
    headerView.frame = header.bounds;
    [header addSubview:headerView];
    _tableView.tableHeaderView = header;;
    
    
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _footerView = [LoginFooterView loginFooterView];
    _footerView.frame = foot.bounds;
    [foot addSubview:_footerView];
    _tableView.tableFooterView = foot;;
    
    
    _footerView.loginBtn.enabled = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"LoginCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPassCell" bundle:nil] forCellReuseIdentifier:@"LoginPassCell"];

    
    [_footerView.loginBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        [self login];
        
    }];
    
    [_footerView.registerBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
         RegisterViewController * vc = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
         [self.navigationController pushViewController:vc animated:YES];
     }];
    [_footerView.forgetPassBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        ForgetPassViewController * vc = [[ForgetPassViewController alloc]initWithNibName:@"ForgetPassViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)login{

    if (![_account isMobelphone]) {
        
        [self showErrorText:@"请输入正确的手机号码!"];
         return;
    }
    if (![_password isPassword]) {
        [self showErrorText:@"请输入正确格式的密码！"];
        return;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
     dict[@"username"] =_account;
     dict[@"password"] =[_password MD5];
     dict[@"client"] =@"ios";


    [self showLoading];
    
    [MCNetTool postWithUrl:HttpPhoneLogin params:dict success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self showSuccessText:msg];
        
        [MobClick profileSignInWithPUID:_account];
        
        UserInfoModel * userModel = [UserInfoModel mj_objectWithKeyValues:requestDic];
        userModel.phone = _account;
        userModel.password =_password;
        
        
        [JPUSHService setAlias:_account callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [UserManager archiverModel:userModel];

        [EaseModHelper loginEaseModWithAccount:_account withCompletion:^(NSString * account, NSString *error) {
            LxDBAnyVar(account);
        }];
        [self dismissViewControllerAnimated:YES completion:^{

            
        }];
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        

    }];

}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    //用于极光单推的方式2 别名： alias
    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
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
    return 2;
}

- (void)logonBtnEnabled:(BOOL )reg{
    _num = reg?_num+1:_num-1;
    
    
    if (kPhone.length != 0) {
        
        if([_password isPassword]){
            _footerView.loginBtn.enabled = YES;
        }else{
            _footerView.loginBtn.enabled = NO;
        }
    }else{
    
        if([_account isMobelphone] && [_password isPassword]){
            _footerView.loginBtn.enabled = YES;
        }else{
            _footerView.loginBtn.enabled = NO;
        }
    
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LoginCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
        
        if(kPhone.length != 0){
            cell.accountTextField.text = kPhone;
            _account =kPhone;
        }else{
            cell.accountTextField.text = @"";
        }
        cell.loginCellBlock = ^(NSString * account ,BOOL pass){
             _account = account;
            [self logonBtnEnabled:pass];
            DeLog(@"-------   %@------  %d",account,pass);
         };
        return cell;
    }
    if (indexPath.row == 1) {
        LoginPassCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginPassCell"];
        cell.loginPassCellBlock = ^(NSString * password ,BOOL pass){
            _password = password;
            [self logonBtnEnabled:pass];
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
