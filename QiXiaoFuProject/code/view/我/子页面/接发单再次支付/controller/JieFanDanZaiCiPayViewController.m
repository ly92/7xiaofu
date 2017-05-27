//
//  JieFanDanZaiCiPayViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "JieFanDanZaiCiPayViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PayPriceViewCell.h"
#import "PayTypeCell.h"
#import "SettingPayPassWordViewController.h"
#import "GalenPayPasswordView.h"
#import "NSString+Utils.h"
#import "ShopPaySuccViewController.h"
#import "ShopPayModel.h"
#import "AliPayManager.h"
#import "WeiXinPayManager.h"
#import "JieFanDanZaiCiPayHeaderView.h"
#import "NSArray+Utils.h"
#import "ForgetPayPassViewController.h"

@interface JieFanDanZaiCiPayViewController (){
    
    
    NSInteger _payPassState;// 使用个人钱包的  支付密码  的状态  【0 未设置】【1 已设置】【2 支付密码正确】
    
    BOOL _useWallet;// 是否使用钱包
    NSInteger _payType;// 支付方式ID 【0 使用钱包全额支付 2 支付宝支付 6微信支付】
    
    CGFloat _wallet;// 钱包的余额
    CGFloat _wallet_price;//使用钱包的金额
//    CGFloat _netPaypPrice;//网络支付的金额
    
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong) NSMutableArray *quyuArray;
@property (nonatomic, strong) NSMutableDictionary * requestParams;// 订单再次请求参数

@property (nonatomic, strong) JieFanDanZaiCiPayHeaderView * headerView;// 调价头部视图

@end

@implementation JieFanDanZaiCiPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"支付";
    
    _quyuArray = [NSMutableArray new];
    [_quyuArray addObject:@"0"];
    
    _useWallet =  NO;
    _payType = 2;
    
    _requestParams = [NSMutableDictionary new];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"PayPriceViewCell" bundle:nil] forCellReuseIdentifier:@"PayPriceViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PayTypeCell" bundle:nil] forCellReuseIdentifier:@"PayTypeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SendOrderCell" bundle:nil] forCellReuseIdentifier:@"SendOrderCell"];
    
    _tableView.tableFooterView = [UIView new];
    
    
    if (_type == 2) {
        
        UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _headerView = [JieFanDanZaiCiPayHeaderView jieFanDanZaiCiPayHeaderView];
        _headerView.frame =CGRectMake(0, 0, kScreenWidth, 50);
        _headerView.priceLab.text = [NSString stringWithFormat:@"%.2f",_order_price];
        [header addSubview:_headerView];
        _tableView.tableHeaderView = header;
    }
    
    
    [_payBtn addTarget:self action:@selector(payBtnWithOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self updatPayPrice];
    
    [self checkPayOrderPwdRequest];
    
    [self regsigNetPayNoti];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 检测是否设置支付密码

- (void)checkPayOrderPwdRequest{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    
    [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _payPassState = [requestDic[@"statu"] integerValue];
        _wallet = [requestDic[@"available_predeposit"] floatValue];
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
    
    
}

#pragma mark - 计算支付的价钱
- (void)updatPayPrice{
    
     _priceLab.text = [NSString stringWithFormat:@"共支付:¥%.2f",_order_price];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _quyuArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            PayPriceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayPriceViewCell"];
            cell.switchView.on = NO;
            cell.switchView.hidden = NO;
            cell.priceTextField.text = [NSString stringWithFormat:@"  (可用余额:¥%.2f)", _wallet];
            cell.priceTextField.userInteractionEnabled = NO;
            cell.switchViewBlock =^(BOOL on,UISwitch * sw){
                
                if(_wallet < _order_price){
                    
                    [self showErrorText:@"余额不足"];
                    sw.on = NO;
                    _useWallet = NO;
                    
                }else{
                    _useWallet = on;
                    
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
                    [payCell changeBtnState:0];
                    
                         _payType = 0;
 
                    
                }
//                if (on) {
//                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:0];
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
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                    [self.tableView beginUpdates];
//                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                    [self.tableView endUpdates];
//                }
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
                
                if ([text floatValue] > _wallet) {
                    [self showErrorText:@"您的余额不足"];
                    cell.priceTextField.text = @"";
                }else{
                    
                    _requestParams[@"wallet_price"] = text;//使用钱包的金额
                    _requestParams[@"is_wallet"] = @"1";//是否使用钱包的金额

                    _wallet_price = [text floatValue];
                    
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];

                    [payCell changeBtnState:0];
                    
                        _payType = 0;
                 }
                
            };
            return cell;
            
        }
    }
    if (indexPath.section == 1) {
        __weak PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell"];
        
        cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_order_price];
        cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
        
        cell.payTypeCellBlobk = ^(NSInteger payType){
            
            
            if (payType == 1) {
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_order_price];
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
                
                _payType = 2;
                
            }else{
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付(支付¥%.2f)",_order_price];
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝"];
                _payType = 6;
                
            }
            
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            PayPriceViewCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
            payCell.switchView.on = NO;
            
            _useWallet = NO;

            
        };
        
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return  152;
    }
    return  44;
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


- (void)payBtnWithOrderAction:(UIButton *)btn {
    
    
    if (_useWallet) {
        
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
                
                
                if (_type == 1) {
                    [self submintRequestWithPayPass:pwd];

                }else{
                    [self tiaojiaRequest:pwd];
                }
                
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

        kTipAlert(@"忘记密码？") ;
    }];
    
}
#pragma mark - 提交发单请求
- (void)submintRequestWithPayPass:(NSString *)payPass{
    
    
    [self showText:@"正在生成订单"];
    
    _requestParams[@"userid"] = kUserId;
    
    if (_useWallet) {
        _requestParams[@"member_paypwd"] = [payPass MD5];
        _requestParams[@"is_wallet"] = @"1";
    }else{
        _requestParams[@"is_wallet"] = @"0";
    }
    _requestParams[@"payment_id"] = @(_payType);
    _requestParams[@"id"] = _f_id;

    
    if (_payType == 0) {//  选择的是使用钱包付款，那么钱包付全款
        _requestParams[@"wallet_price"] = @(_order_price);//使用钱包的金额
     }

    
    
    [MCNetTool postWithUrl:HttpMeRePayBill params:_requestParams success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
        
        [self showSuccessText:msg];
        
        
            ShopPayModel * shopPayModel = [ShopPayModel mj_objectWithKeyValues:requestDic];
    
    
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
    
                [self showSuccessText:@"支付成功"];
                
                [Utool performBlock:^{
                    
                    if (_jieFanDanZaiCiPayViewBlock) {
                        _jieFanDanZaiCiPayViewBlock();
                    }
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } afterDelay:1.0f];    
            }
        
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        
    }];
    
}

#pragma mark - 订单调价使用的请求

- (void)tiaojiaRequest:(NSString *)payPass{


    [self showText:@"正在生成订单"];
    
    _requestParams[@"userid"] = kUserId;
    
    if (_useWallet) {
        _requestParams[@"member_paypwd"] = [payPass MD5];
        _requestParams[@"is_wallet"] = @"1";
    }else{
        _requestParams[@"is_wallet"] = @"0";
    }
    _requestParams[@"payment_id"] = @(_payType);
    
    if (_payType == 0) {//  选择的是使用钱包付款，那么钱包付全款
        _requestParams[@"wallet_price"] = @(_order_price);//使用钱包的金额
     }

    
    
    
    if (_tiaojiaImageUrlArray.count != 0) {
        _requestParams[@"up_images"] = [_tiaojiaImageUrlArray componentsJoinedByString:@","];
    }
    
    
    NSString * sad =[_tiaojiaImageUrlArray componentsJoinedByString:@","];
    
    
    LxDBAnyVar(sad);
    
    
    _requestParams[@"service_up_price"] = @(_tioajia_order_price);
    
    _requestParams[@"id"] = _f_id;


    
//    http://139.129.213.138/tp.php/Home/My/upBillPriceGuestPay?
//    member_paypwd=e10adc3949ba59abbe56e057f20f883e
//    &is_wallet=1&
//    userid=4b6a6e1dc29d2862084a49ab08edfeba&
//    payment_id=0&
//    service_up_price=180&
//    wallet_price=180
    
    
    
    [MCNetTool postWithUrl:HttpMeUpBillPriceGuestPay params:_requestParams success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
        
        [self showSuccessText:msg];
        
        
        ShopPayModel * shopPayModel = [ShopPayModel mj_objectWithKeyValues:requestDic];
        
        
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
            
            [self showSuccessText:@"支付成功"];
            
            
            [Utool performBlock:^{
                
                if (_jieFanDanZaiCiPayViewBlock) {
                    _jieFanDanZaiCiPayViewBlock();
                }
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
            } afterDelay:1.0f];
            
            
            

        }
        
        
        
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
 
        [self showSuccessText:@"支付成功"];
        
        
        [Utool performBlock:^{
            
            if (_jieFanDanZaiCiPayViewBlock) {
                _jieFanDanZaiCiPayViewBlock();
            }
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.0f];

        
        
        
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
        
        [self showSuccessText:@"支付成功"];
        
        
        [Utool performBlock:^{
            
            if (_jieFanDanZaiCiPayViewBlock) {
                _jieFanDanZaiCiPayViewBlock();
            }
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        } afterDelay:1.0f];

        
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
