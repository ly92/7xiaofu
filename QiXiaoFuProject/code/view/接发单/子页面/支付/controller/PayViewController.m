//
//  PayViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PayViewController.h"
#import "PayHeaderViewCell.h"
#import "PayPriceViewCell.h"
#import "PayTypeCell.h"
#import "SendOrderCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SettingPayPassWordViewController.h"
#import "GalenPayPasswordView.h"
#import "NSString+Utils.h"

#import "AliPayManager.h"
#import "WeiXinPayManager.h"
#import "ShopPaySuccViewController.h"
#import "ShopPayModel.h"

#import "MatchingEngineerListVC.h"
#import "ForgetPayPassViewController.h"
#import "BlockUIAlertView.h"

@interface PayViewController (){

    CGFloat _sever_price;// 服务金额
    CGFloat _top_price;// 置顶的金额
    CGFloat _wallet_price;//使用钱包的金额
    CGFloat _netPaypPrice;//网络支付的金额
    CGFloat _price;//总共支付的金额
    
    
    NSInteger _payPassState;// 使用个人钱包的  支付密码  的状态  【0 未设置】【1 已设置】【2 支付密码正确】
    
    BOOL _useWallet;// 是否使用钱包
    NSInteger _payType;// 支付方式ID 【0 使用钱包全额支付 2 支付宝支付 6微信支付】
    
    
    NSString * _orderId;// 发单 id


}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic, strong) NSMutableArray *quyuArray;




@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付";
    
    
    _quyuArray = [NSMutableArray new];
    [_quyuArray addObject:@"0"];

    _useWallet =  NO;
    _payType = 2;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PayHeaderViewCell" bundle:nil] forCellReuseIdentifier:@"PayHeaderViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PayPriceViewCell" bundle:nil] forCellReuseIdentifier:@"PayPriceViewCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"PayTypeCell" bundle:nil] forCellReuseIdentifier:@"PayTypeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendOrderCell"];
 
    _tableView.tableFooterView = [UIView new];
    
    
    
    _sever_price = [_requestParams[@"service_price"] floatValue];
    _top_price = [_requestParams[@"top_day"] integerValue] * _showaddbillModel.top_price;
    
    
    [self checkPayPwdRequest];
    
    
    [self updatPayPrice];
    
    
    [self regsigNetPayNoti];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (_requestParams.count == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - 计算支付的价钱
- (void)updatPayPrice{

    _price = _sever_price +_top_price;
    
    _netPaypPrice = _price;

    _priceLab.text = [NSString stringWithFormat:@"共支付:¥%.2f",_price];
    
}


#pragma mark - 检测是否设置支付密码

- (void)checkPayPwdRequest{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
 
    
    [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _payPassState = [requestDic[@"statu"] integerValue];
        
    } fail:^(NSString *error) {
        
    }];


}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _isTop?2:1;
    }
    if (section == 1) {
        return _quyuArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PayHeaderViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayHeaderViewCell"];
            cell.severContentLab.text = _requestParams[@"title"];
            cell.severTimeLab.text =[NSString stringWithFormat:@"%@-%@",[Utool timeStamp2TimeFormatter:_requestParams[@"service_stime"]],[Utool timeStamp2TimeFormatter:_requestParams[@"service_etime"]]];
            cell.severAdressLab.text =_requestParams[@"service_address"];
            cell.severPriceLab.text = [NSString stringWithFormat:@"¥%@",_requestParams[@"service_price"]];
            cell.zhidingPriceLab.text = [NSString stringWithFormat:@"¥%@",@(_top_price)];
            
            return cell;

        }else{
             SendOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SendOrderCell"];
            cell.titleLab.text = @"置顶费用";
            cell.descLab.text = [NSString stringWithFormat:@"¥%@",@([_requestParams[@"top_day"] integerValue] * _showaddbillModel.top_price)];
            cell.descLab.textAlignment = NSTextAlignmentLeft;
            cell.accessoryType = UITableViewCellAccessoryNone;
             return cell;
         }
     }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            PayPriceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayPriceViewCell"];
            cell.switchView.on = NO;
            cell.switchView.hidden = NO;
            cell.priceTextField.text = [NSString stringWithFormat:@"  (可用余额:¥%@)", @(_showaddbillModel.available_predeposit)];
            cell.priceTextField.userInteractionEnabled = NO;
            cell.switchViewBlock =^(BOOL on,UISwitch * sw){
                
                if(_showaddbillModel.available_predeposit < _price){
                    
                    [self showErrorText:@"余额不足"];
                    sw.on = NO;
                    _useWallet = NO;
                    
                }else{
                    _useWallet = on;
                    
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
                    _netPaypPrice = 0;
                    [payCell changeBtnState:_netPaypPrice];
                    
                    if (_netPaypPrice == 0) {
                        _payType = 0;
                    }

                }
                
                
//                if (on) {
//                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:1];
//                    
//                    [indexPaths addObject: indexPath];
//                    [_quyuArray addObject:@"1"];
//                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                    [self.tableView beginUpdates];
//                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                    [self.tableView endUpdates];
//                    
//                }else{
//                    
//                    [_quyuArray removeObject:@"1"];
//                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
//                     //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                    [self.tableView beginUpdates];
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                    [self.tableView endUpdates];
//                 }
                
            };
            return cell;
        }else{
        
            __weak PayPriceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayPriceViewCell"];
            cell.switchView.hidden = YES;
            cell.priceTextField.placeholder = @"请输入价钱";
            cell.priceTextField.userInteractionEnabled = YES;
            cell.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.priceTextField.textAlignment = NSTextAlignmentCenter;
            cell.priceTextFieldBlock =^(NSString * text){
                
                if ([text floatValue] > _showaddbillModel.available_predeposit) {
                    [self showErrorText:@"您的余额不足"];
                    cell.priceTextField.text = @"";
                }
//                else  if ([text floatValue] > [_requestParams[@"service_price"] floatValue]){
//                
//                    [self showErrorText:@"用不了那么多"];
//                    cell.priceTextField.text = @"";
//
//                }
                else{
                     _requestParams[@"wallet_price"] = text;//使用钱包的金额
                    
                    _wallet_price = [text floatValue];
                    
                    _netPaypPrice = _price - _wallet_price;
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
                    [payCell changeBtnState:_netPaypPrice];
                    
                    if (_netPaypPrice == 0) {
                        _payType = 0;
                    }
                    

                }
                
            };
            return cell;
        
        }
    }
    if (indexPath.section == 2) {
       __weak PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell"];
        
        cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_price];
        cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];

        cell.payTypeCellBlobk = ^(NSInteger payType){
        
            
            if (payType == 1) {
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_price];
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];

                _payType = 2;
                
            }else{
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付(支付¥%.2f)",_price];
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝"];

                _payType = 6;

            }
            
            
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            PayPriceViewCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
            payCell.switchView.on = NO;
            
            _useWallet = NO;


        };
        
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return  110;
         }
        return  44;
     }
    if (indexPath.section == 2) {
        return  152;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0.001f;
     }
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (IBAction)payBtnAction:(UIButton *)sender {
    
    
    if (_useWallet) {
        
        // 使用钱包   ---去输入平台支付密码
        if (_payPassState == 0 ) {
            // 【0 未设置】  去设置 钱包支付密码
            
            SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
            vc.isSetNewPassWord = NO;
            vc.navigationItem.title = @"设置支付密码";
            
            vc.settingPayPassWordSuccBlock=^(){
                
                [self checkPayPwdRequest];

                
                [self inputPayPass];
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (_payPassState == 1 ){
            //【1 已设置】
            
            [self inputPayPass];
            
        }

    }else{
        // 不使用钱包  直接使用网络支付
    
        [self submintRequestWithPayPass:nil];

    
    }
    
    
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
                [weekPayPassword hidenKeyboard:^(BOOL finished) {
                    [self submintRequestWithPayPass:pwd];
                }];
                
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

    
    [self showText:@"正在生成订单"];

    
    _requestParams[@"userid"] = kUserId;
    
    if (_useWallet) {
        _requestParams[@"member_paypwd"] = [payPass MD5];
    }
    _requestParams[@"payment_id"] = @(_payType);
    
    
    if (_payType == 0) {
        
        NSString * wallet_price = [NSString stringWithFormat:@"%f",_price];
        _requestParams[@"wallet_price"] = wallet_price;//使用钱包的金额

    }
    
 
    [MCNetTool postWithUrl:HttpMainAddbill params:_requestParams success:^(NSDictionary *requestDic, NSString *msg) {
       
        [self dismissLoading];
        
        [self showSuccessText:msg];

        ShopPayModel * shopPayModel = [ShopPayModel mj_objectWithKeyValues:requestDic];
        
        _orderId = shopPayModel.bill_id;
        
        if(shopPayModel.is_pay ==1){
        
            if (_payType == 2) {
                // 支付宝支付
                [[AliPayManager sharedAliPayManager] pay:shopPayModel];
            }
            else if (_payType == 6) {
                // 微信支付
                [[WeiXinPayManager sharedManager] weiXinPay:shopPayModel];
            }
        
        }else{

            [self sendOrderSuccWithOrderId:shopPayModel.bill_id];
            
        }
    

        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
 
    }];
    
}
#pragma mark -  发单成功 去匹配工程师
// 发单成功 去匹配工程师
- (void)sendOrderSuccWithOrderId:(NSString *)orderId{
    
    if (_isBuDan) {
        
        [self showSuccessText:@"补单成功"];
        
        [Utool performBlock:^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } afterDelay:1.0f];

    }
    else{
    
        [self showSuccessText:@"发单成功"];
        _requestParams = nil;
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"发单成功" message:[NSString stringWithFormat:@""] cancelButtonTitle:@"返回首页" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                MatchingEngineerListVC * vc= [[MatchingEngineerListVC alloc]initWithNibName:@"MatchingEngineerListVC" bundle:nil];
                vc.orderId = orderId;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (buttonIndex == 0){
                [self.view endEditing:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } otherButtonTitles:@"匹配工程师"];
        [alert show];
        
        
    
    }
    

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
        
        [self sendOrderSuccWithOrderId:_orderId];

    }else{
        //在这里写支付失败之后的回调操作
        DeLog(@"支付宝支付失败");
        
//        kTipAlert(@"支付宝支付失败");
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
}
-(void)dealWXpayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"1"]){
        //在这里写支付成功之后的回调操作
        DeLog(@"微信支付成功");
        
        [self sendOrderSuccWithOrderId:_orderId];

        
    }else{
        //在这里写支付失败之后的回调操作
        DeLog(@"微信支付失败");
        
        kTipAlert(@"微信支付失败");
        
        [self.navigationController popViewControllerAnimated:YES];

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
