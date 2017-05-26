//
//  RechargeWithdrawViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RechargeWithdrawViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RechargeWithdrawCell.h"
#import "PayTypeCell.h"
#import "RechargeWithdrawFooterView.h"
#import "ShopPayModel.h"
#import "AliPayManager.h"
#import "WeiXinPayManager.h"
#import "ShareModel.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SettingPayPassWordViewController.h"
#import "GalenPayPasswordView.h"
#import "NSString+Utils.h"
#import "ForgetPayPassViewController.h"
#import "BlockUIAlertView.h"


@interface RechargeWithdrawViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSString * sectionTitle;
    
    NSInteger _payType;// 默认支付宝

    NSString * _money;
    
    NSString * _payName;
    
    NSString * _alpayAccount;// 支付宝账号
    NSString * _accountName;// 开户行姓名
    NSString * _bankName;// 银行名称

    
    NSInteger _payPassState;// 谁否设置了支付密码

    
    NSString * _keTixianMoney;
    
    NSString * _tixianPlas;

    
    

}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tabelVeiw;

@property (strong, nonatomic) NSMutableArray *quaryArray;
@property (nonatomic,copy)NSString * zuidiedu;//资金沉淀金额


@end

@implementation RechargeWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = _vcType==1?@"充值":@"提现";//@"充值提现";
    
    _quaryArray = [NSMutableArray new];
    [_quaryArray addObject:@"  "];

    [_tabelVeiw registerNib:[UINib nibWithNibName:@"RechargeWithdrawCell" bundle:nil] forCellReuseIdentifier:@"RechargeWithdrawCell"];
    [_tabelVeiw registerNib:[UINib nibWithNibName:@"PayTypeCell" bundle:nil] forCellReuseIdentifier:@"PayTypeCell"];

    sectionTitle= _vcType==1?@"选择充值金额":@"选择提现金额";
    
    
    
    
    _payType =2;// 默认支付宝
    _payName =    @"支付宝";
    _bankName = @"支付宝";
    
    [self checkPayOrderPwdRequest];
    
    [self regsigNetPayNoti];
    
    
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    RechargeWithdrawFooterView * footerView = [RechargeWithdrawFooterView footerView];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    [foot addSubview:footerView];
     _tabelVeiw.tableFooterView = foot;
    
    [footerView.submitBtn setTitle:self.navigationItem.title forState:UIControlStateNormal];
    
    [footerView.submitBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
       
        if (_vcType==1) {
            [self rechargeRequest];// 充值
        }else{
        
        
            [self reCrash];//  提现
            
        }
        
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 充值

- (void)rechargeRequest{

    
    if(_money.length == 0){
    
        [self showErrorText:@"请输入金额"];
        return;
    
    };
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"price"] = _money;
    params[@"pay_name"] = _payType==2?@"支付宝":@"微信";
    params[@"payment_id"] = @(_payType);
    
    
    [MCNetTool postWithUrl:HttpMeRecharge params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShopPayModel * shopPayModel = [ShopPayModel mj_objectWithKeyValues:requestDic];
        
        if (_payType == 2) {
            // 支付宝支付
            [[AliPayManager sharedAliPayManager] pay:shopPayModel];
        }
        else if (_payType == 6) {
            // 微信支付
            [[WeiXinPayManager sharedManager] weiXinPay:shopPayModel];
        }
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
    

}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _vcType ==1?2:3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return _quaryArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RechargeWithdrawCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RechargeWithdrawCell"];
        cell.titleLab.text =_vcType==1?[NSString stringWithFormat:@"充值金额(¥)"]:[NSString stringWithFormat:@"提现金额(¥)"];
        
        
        cell.moneyTextField.placeholder = _vcType==1?@"请输入充值金额":_tixianPlas;
        cell.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.titleLab.hidden = NO;
        cell.moneyTextField.hidden = NO;

        cell.rechargeWithdrawCellBlock = ^(NSString * money){
            _money = money;
        };
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath .row == 0) {
            PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell"];
            cell.wechatPayTitleLab.text = @"微信";
            cell.payTypeCellBlobk = ^(NSInteger payType){
                _payType = ( payType ==1?2:6);
                _payName =( payType ==1?@"支付宝":@"微信");
                
                LxDBAnyVar(_payType);
                
                if(_vcType == 2 && _payType == 2){
                    
                    NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:0 inSection:2];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath0,nil] withRowAnimation:UITableViewRowAnimationNone];
                     [_quaryArray removeObjectAtIndex:1];//移除数据源的数据
                    NSIndexPath *cellIndexPath1 = [NSIndexPath indexPathForRow:1 inSection:2];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath1] withRowAnimation:UITableViewRowAnimationTop];//移除
                    [_quaryArray removeObjectAtIndex:1];//移除数据源的数据
                    NSIndexPath *cellIndexPath2 = [NSIndexPath indexPathForRow:1 inSection:2];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath2] withRowAnimation:UITableViewRowAnimationTop];//移除
                    
                    _bankName = @"支付宝";
                    
                }else if(_vcType == 2 && _payType == 6){
                    
                    
                    _bankName = @"";
                
                    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:0 inSection:2];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
                    NSMutableArray *indexPaths1 = [[NSMutableArray alloc] init];
                    NSIndexPath *cellIndexPath1 = [NSIndexPath indexPathForRow:_quaryArray.count inSection:2];
                    [indexPaths1 addObject: cellIndexPath1];
                    [_quaryArray addObject:@"   "];
                     //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:indexPaths1 withRowAnimation:UITableViewRowAnimationTop];
                    [tableView endUpdates];
                    
                    
                    
                    NSMutableArray *indexPaths2 = [[NSMutableArray alloc] init];
                    NSIndexPath *cellIndexPath2 = [NSIndexPath indexPathForRow:_quaryArray.count inSection:2];
                    [indexPaths2 addObject: cellIndexPath2];
                    [_quaryArray addObject:@"   "];
                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:indexPaths2 withRowAnimation:UITableViewRowAnimationTop];
                    [tableView endUpdates];

                    
                    
                    
                }
            };
            return cell;
        }

    }
    if (indexPath.section ==2) {
        
        if (indexPath.row == 0) {
            RechargeWithdrawCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RechargeWithdrawCell"];
            cell.titleLab.text =@"支付宝账号";
            cell.moneyTextField.placeholder = @"请输入支付宝账号";
            cell.moneyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
             if (_payType == 2) {
                cell.titleLab.text =@"支付宝账号";
                cell.moneyTextField.placeholder = @"请输入支付宝账号";

             }else{
            
                cell.titleLab.text =@"微信绑定的银行卡号";
                cell.moneyTextField.placeholder = @"请输入银行卡账号";

            }
             cell.rechargeWithdrawCellBlock = ^(NSString * money){
                
                _alpayAccount = money;
                
            };
            

            return cell;

        }
        if (indexPath.row == 1) {
            
            RechargeWithdrawCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RechargeWithdrawCell"];
            cell.titleLab.text =@"银行卡开户行";
            cell.moneyTextField.placeholder = @"请输入银行名称";
            cell.moneyTextField.keyboardType = UIKeyboardTypeDefault;
             cell.rechargeWithdrawCellBlock = ^(NSString * money){
                
                _bankName = money;
                
            };
            
            return cell;

            
            
        }
        if (indexPath.row == 2) {
             RechargeWithdrawCell *cell =[tableView dequeueReusableCellWithIdentifier:@"RechargeWithdrawCell"];
            cell.titleLab.text =@"开户行姓名";
            cell.moneyTextField.placeholder = @"请输入姓名";
            cell.moneyTextField.keyboardType = UIKeyboardTypeDefault;
            cell.rechargeWithdrawCellBlock = ^(NSString * money){
                
                _accountName = money;
             };
            
            return cell;
        }

        
    }
    return nil;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  50;
    }
     if (indexPath.section == 1) {
         return 152;
    }
    if (indexPath.section == 2) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
         UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        titleLab.text = [NSString stringWithFormat:@"   %@",sectionTitle];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = [UIColor darkGrayColor];
        return titleLab;
     }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.0f;
    }
  return 10.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0 && _vcType==2) {
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.text = [NSString stringWithFormat:@"   可提现金额: ¥%@",_available_predeposit];
        titleLab.textColor = [UIColor darkGrayColor];
        return titleLab;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return _vcType==1?0.0001f:30.0f;
    }
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



#pragma mark - 检测是否设置支付密码

- (void)checkPayOrderPwdRequest{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    
    [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _payPassState = [requestDic[@"statu"] integerValue];
        _zuidiedu = requestDic[@"zuidiedu"];
        
        _keTixianMoney = [NSString stringWithFormat:@"%@",@([_available_predeposit floatValue] - [_zuidiedu floatValue])];
        
        _tixianPlas = [_keTixianMoney floatValue]< 0?@"您的提现金额不足":_keTixianMoney;

        [_tabelVeiw reloadData];

    } fail:^(NSString *error) {
        
    }];
    
}


#pragma mark - 提现

- (void)reCrash {
    
    
    

    
    
    if(_money.length == 0){
        [self showErrorText:@"请输入金额"];
        return;
    };
    
    if ([_money floatValue] > [_keTixianMoney floatValue]) {
        [self showErrorText:@"你的提现金额不足"];
        return;
    }
    
    if(_bankName.length == 0 && _payType == 6){
        
        [self showErrorText:@"请输入银行名称"];
        return;
        
    };
    
    if(_alpayAccount.length == 0){
        
        [self showErrorText:_payType==2?@"请输入支付宝账号":@"请输入银行卡账号"];
        return;
        
    };
    
    if(_accountName.length == 0 && _payType==6){
        
        [self showErrorText:@"请输入银行卡用户名"];
        return;
        
    };
    
    NSString *memo = @"";
    if (_payType == 2){
        memo = @"确定提现到支付宝：";
    }else{
        memo = @"确定提现到银行卡：";
    }
    memo = [NSString stringWithFormat:@"\n%@%@\n",memo,_alpayAccount];
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:memo cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            // 使用钱包   ---去输入平台支付密码
            if (_payPassState == 0 ) {
                // 【0 未设置】  去设置 钱包支付密码
                
                SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
                vc.isSetNewPassWord = NO;
                vc.navigationItem.title = @"设置支付密码";
                
                vc.settingPayPassWordSuccBlock=^(){

                    [self checkPayOrderPwdRequest];
                    
                    [self inputPayPass];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (_payPassState == 1 ){
                //【1 已设置】
                
                [self inputPayPass];
                
            }
        }
    } otherButtonTitles:@"确定"];
    [alert show];
 }

#pragma mark - 输入平台支付密码

- (void)inputPayPass{
    
    
    GalenPayPasswordView *payPassword=[GalenPayPasswordView tradeView];
    [payPassword showInView:self.view.window];
    
    __block typeof(GalenPayPasswordView *) weekPayPassword = payPassword;
    [payPassword setInputPassFinish:^(NSString * pwd) {
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"paypwd"] = [pwd MD5];
        
        //  验证输入的原支付密码是否争取为
        [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            if ([requestDic[@"statu"] integerValue] == 2) {
                //  【2 支付密码正确】
                //  去支付
                [weekPayPassword hiddenPayPasswordView];
                
                [self submintRequestWithPayPass:pwd];
                
                
            }else if ([requestDic[@"statu"] integerValue] == 3){
                
                [self showErrorText:@"支付密码不正确"];
                [weekPayPassword removeAllNumbers];
                
            }
            
            
        } fail:^(NSString *error) {
            
            [self showErrorText:error];
            
        }];
        
        //        [weekPayPassword showProgressView:@"正在处理..."];
        //
        //        [weekPayPassword performSelector:@selector(showSuccess:) withObject:self afterDelay:3.0];
        
        
    }];
    
    [payPassword setLessPassword:^{
        [weekPayPassword hiddenPayPasswordView];
        
        ForgetPayPassViewController * vc = [[ForgetPayPassViewController alloc]initWithNibName:@"ForgetPayPassViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
#pragma mark - 提交发单请求
- (void)submintRequestWithPayPass:(NSString *)payPass{
    
    
    [self showText:@"正在提交请求"];
    
    
    
    if(_money.length == 0){
        
        [self showErrorText:@"请输入金额"];
        return;
        
    };
    
    
    if(_bankName.length == 0 && _payType == 6){
        
        [self showErrorText:@"请输入银行名称"];
        return;
        
    };
    
    if(_alpayAccount.length == 0){
        
        [self showErrorText:_payType==2?@"请输入支付宝账号":@"请输入银行卡账号"];
        return;
        
    };
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"price"] = _money;//要提现的金额【大于100】
    params[@"member_paypwd"] = [payPass MD5];//支付密码 【MD5加密后32位字符串】
    params[@"payment_id"] = @(_payType);//提现方式ID【2 支付宝】【6 微信】
    params[@"payment_name"] = _bankName;//提现银行名称【如：支付宝，建设银行】
    params[@"bank_no"] = _alpayAccount;
    params[@"bank_user"] = _accountName;
    
    [MCNetTool postWithUrl:HttpMeReCash params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        
        [self dismissLoading];
        
        
        [Utool performBlock:^{
            
            [self showSuccessText:@"请求提交成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.0f];
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
}














































#pragma mark - 注册支付宝 微信 通知
- (void)regsigNetPayNoti{
    
    //注册监听-支付宝
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealAlipayResult:) name:@"alipayResult" object:nil];
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWXpayResult:) name:@"WXpayresult" object:nil];
    
}

-(void)dealAlipayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"9000"]){
        //在这里写支付成功之后的回调操作
        DeLog(@"支付宝支付成功");
        
        [self showSuccessText:@"充值成功"];
        
        [Utool performBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.5f];

        
    }else{
        //在这里写支付失败之后的回调操作
        DeLog(@"支付宝支付失败");
        
//        kTipAlert(@"支付宝支付失败");
        
        
        
    }
    
}
-(void)dealWXpayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"1"]){
        //在这里写支付成功之后的回调操作
        DeLog(@"微信支付成功");
        
        [self showSuccessText:@"充值成功"];
        
        [Utool performBlock:^{
            
            [self.navigationController popViewControllerAnimated:YES];

        } afterDelay:1.5f];
        
        
    }else{
        //在这里写支付失败之后的回调操作
        DeLog(@"微信支付失败");
        
        kTipAlert(@"微信支付失败");
        
    }
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
