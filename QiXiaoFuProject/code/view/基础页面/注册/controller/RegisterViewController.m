//
//  RegisterViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterFooterView.h"
#import "LoginCell.h"
#import "LoginPassCell.h"
#import "RegisterCell.h"
#import "XieYiViewController.h"
#import "NSString+Utils.h"
#import "TPKeyboardAvoidingTableView.h"
#import "EaseModHelper.h"
#import "JPUSHService.h"


@interface RegisterViewController (){

    NSString * _account;
    NSString * _verifyCode;
    NSString * _inviteCode;
    NSString * _password;
    
    
    NSInteger _checkType;// 1 不同意  2 同意



}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";

 
    
    _account = @"";
    _verifyCode= @"";
    _inviteCode= @"";
    _password= @"";

    _checkType= 1;
    
    
    
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 205)];
    
    RegisterFooterView * footerView = [RegisterFooterView registerFooterView];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 205);
    [footer addSubview:footerView];
     _tableView.tableFooterView = footer;;
    
    [_tableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:nil] forCellReuseIdentifier:@"LoginCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"LoginPassCell" bundle:nil] forCellReuseIdentifier:@"LoginPassCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RegisterCell" bundle:nil] forCellReuseIdentifier:@"RegisterCell"];
    
    
    [footerView.checkBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        btn.selected =!btn.selected;
        
        _checkType = btn.selected==YES?2:1;
        
    }];
    

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
            [self showErrorText:@"请输入正确格式的密码!"];
            return;
        }
        
        if (_checkType == 1) {
            [self showErrorText:@"请同意注册协议"];
            return;
        }
        
        NSMutableDictionary * dict = [NSMutableDictionary new];
        dict[@"phone"] =_account;
        dict[@"verif"] =_verifyCode;
        if (_inviteCode.length != 0) {
            dict[@"inviter_code"] =_inviteCode;
        }
        dict[@"password"] =_password;
        dict[@"password_confirm"] =_password;
 
        
        [self showLoading];

        [MCNetTool postWithUrl:HttpRegister params:dict success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:msg];
            
            [EaseModHelper registerEaseModWithAccount:_account  withCompletion:^(NSString *username, NSString *error) {
                
                DeLog(@"环信登录陈宫----  %@-----%@",error,username);
                
            }];
            
//            [self.navigationController popViewControllerAnimated:YES];
            /**
             {
             repCode = "00",
             repMsg = "注册成功",
             listData = 	{
             phone = "18612333016",
             userid = "ffb60a5ab266629a4bf9ac91ddb97fb9",
             tags = 	(
             ),
             store_id = 1,
             store_name = "",
             },
             }
             */
            
            NSString *userID = [requestDic objectForKey:@"userid"];
            
            [self goLogin];
            
            [self addIntegral:userID];
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];

    }];
    
    [footerView.protocolBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        XieYiViewController * vc = [[XieYiViewController alloc]init];
        vc.title =@"注册协议";
        vc.type =1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
 
    // Do any additional setup after loading the view from its nib.
}


//如果实名认证则请求添加积分
- (void)addIntegral:(NSString *)userId{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = userId;
    params[@"type"] = @"1";//1:注册 2:实名认证
    
    [MCNetTool postWithUrl:HttpAddRedits params:params success:^(NSDictionary *requestDic, NSString *msg) {
    } fail:^(NSString *error) {
    }];
}



- (void)goLogin{

    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    dict[@"username"] =_account; // 账号
    dict[@"password"] =[_password MD5];// 密码（加密）
    dict[@"client"] =@"ios";// 平台
    
    [MCNetTool postWithUrl:HttpPhoneLogin params:dict success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
    
        [MobClick profileSignInWithPUID:_account];// 友盟统计
        
        UserInfoModel * userModel = [UserInfoModel mj_objectWithKeyValues:requestDic];
        userModel.phone = _account;
        userModel.password =_password;
        
        [JPUSHService setAlias:_account callbackSelector:nil object:self];// 极光注册别名
        
        
        
        [UserManager archiverModel:userModel];// 个人信息保存
        
        // 登录环信
        [EaseModHelper loginEaseModWithAccount:_account withCompletion:^(NSString * account, NSString *error) {
            
            [self showSuccessText:msg];

            LxDBAnyVar(account);
        }];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];


}
     




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        LoginCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
        cell.loginCellBlock = ^(NSString * account ,BOOL pass){
            
            _account = account;
            
            LxDBAnyVar(_account);

            
         };
//        [cell.accountTextField becomeFirstResponder];
         return cell;
    }
    if (indexPath.row == 1) {
     RegisterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
        
        cell.registerCellBlock = ^(NSString * verify ,BOOL pass){
//            if ([_account isMobelphone]) {
//                [cell.verifyBtn runVerifyButtonSecondTime];
//            }
            _verifyCode = verify;
            
        };
        
        cell.registerCodeCellBlock= ^(){
 
             if (![_account isMobelphone]) {
                
                [self showErrorText:@"请输入正确的手机号码!"];
                return;
            }
             NSDictionary * dict = @{@"mobile":_account,
                                    @"t":@"1"};
            [MCNetTool postWithUrl:HttpVerify params:dict success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                
                [cell.verifyBtn runVerifyButtonSecondTime];

            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
          };
         return cell;
    }
    
    if (indexPath.row == 2) {
        LoginCell *cell =[tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
        cell.accountTextField.placeholder = @"请输入邀请码(选填)";
        cell.accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.loginCellBlock = ^(NSString * password ,BOOL pass){
            _inviteCode = password;
         };
        return cell;
    }
    if (indexPath.row == 3) {
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
