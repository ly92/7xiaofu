//
//  ShopPayViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopPayViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ShopPayAdressCell.h"
#import "ShopPayInfoCell.h"
#import "PayPriceViewCell.h"
#import "PayTypeCell.h"
#import "ShopPaySuccViewController.h"
#import "AdressListController.h"
#import "EditAdressController.h"
#import "BlockUIAlertView.h"
#import "ShopCarClearingModel.h"
#import "ShopPayModel.h"
#import "AliPayManager.h"
#import "WeiXinPayManager.h"
#import "SettingPayPassWordViewController.h"
#import "GalenPayPasswordView.h"
#import "NSString+Utils.h"
#import "ForgetPayPassViewController.h"
#import "LocalData.h"


@interface ShopPayViewController ()<UIScrollViewDelegate>{

    NSInteger _payPassState;// 使用个人钱包的  支付密码  的状态  【0 未设置】【1 已设置】【2 支付密码正确】
    
    BOOL _useWallet;// 是否使用钱包
    NSInteger _payType;// 支付方式ID 【0 使用钱包全额支付 2 支付宝支付 6微信支付】
    
    CGFloat _wallet;// 钱包的余额
    
    CGFloat _wallet_price;//使用钱包的金额
//    CGFloat _netPaypPrice;//网络支付的金额
    CGFloat _order_Price;//网络支付的金额


}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic, strong) ShopCarClearingModel * shopCarClearingModel;



@property (nonatomic, copy) NSString  *vat_hash;//需要传的参数1
@property (nonatomic, copy) NSString  *offpay_hash;//需要传的参数2
@property (nonatomic, copy) NSString  *offpay_hash_batch;//需要传的参数3
@property (nonatomic, copy) NSString  *address_id;//收货地址ID

@property (nonatomic, copy) NSString  *order_id;//订单id



@property (nonatomic, strong) NSMutableArray *quyuArray;
@property (nonatomic, strong) NSMutableDictionary * params;// 订单再次请求参数


@end

@implementation ShopPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"支付";
    
    
    _payType = 2;// 默认支付宝支付
    _quyuArray = [NSMutableArray new];
    [_quyuArray addObject:@"0"];
    _useWallet =  NO;
    _params = [NSMutableDictionary new];
    _params[@"userid"] = kUserId;


    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn_back" highImage:@"btn_back" target:self action:@selector(backItemAction:)];
    

    [_tabelView registerNib:[UINib nibWithNibName:@"ShopPayAdressCell" bundle:nil] forCellReuseIdentifier:@"ShopPayAdressCell"];
    [_tabelView registerNib:[UINib nibWithNibName:@"ShopPayInfoCell" bundle:nil] forCellReuseIdentifier:@"ShopPayInfoCell"];
    [_tabelView registerNib:[UINib nibWithNibName:@"PayPriceViewCell" bundle:nil] forCellReuseIdentifier:@"PayPriceViewCell"];
    [_tabelView registerNib:[UINib nibWithNibName:@"PayTypeCell" bundle:nil] forCellReuseIdentifier:@"PayTypeCell"];
    
    
    _tabelView.tableFooterView = [UIView new];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    
    [self checkPayShopPwdRequest];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"cart_id"] = _cart_id;
    params[@"ifcart"] = @(_ifcart);//  结算方式 【1，购物车】 【0，立即购买】
    if (_ifcart == 0) {
        params[@"is_appPay"] = @"1";
    }
    
    [MCNetTool postWithUrl:HttpShopCarClearing params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _shopCarClearingModel = [ShopCarClearingModel mj_objectWithKeyValues:requestDic];
        
        
        _offpay_hash = _shopCarClearingModel.offpay_hash;
        _offpay_hash_batch = _shopCarClearingModel.offpay_hash_batch;
        _address_id =_shopCarClearingModel.address_info.address_id;

        [self updatPayPrice];
        
        [_tabelView reloadData];
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        
        
    }];

    
    //注册监听-支付宝
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealAlipayResult:) name:@"alipayResult" object:nil];
    //注册监听-微信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWXpayResult:) name:@"WXpayresult" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (_params.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}





#pragma mark - 计算支付的价钱
- (void)updatPayPrice{
    
     _order_Price = [_shopCarClearingModel.goods_total floatValue];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共支付:¥%.2f",_order_Price]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,4)];
    self.priceLab.attributedText = str;

}

#pragma mark - 检测是否设置支付密码

- (void)checkPayShopPwdRequest{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    
    [MCNetTool postWithUrl:HttpMeCheckPayPwd params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _payPassState = [requestDic[@"statu"] integerValue];
        _wallet = [requestDic[@"available_predeposit"] floatValue];
        
        [_tabelView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
    
    
}


- (void)backItemAction:(UIBarButtonItem *)item{

    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"\n你确定要离我而去吗\n" cancelButtonTitle:@"再逛逛" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 0){
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } otherButtonTitles:@"留下来"];
    [alert show];

    


}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section == 0) {
        return 1;
     }
    if (section == 1) {
        return _cartGoodsArray.count;
     }
    if (section == 2) {
        return _quyuArray.count;
     }
    if (section == 3) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ShopPayAdressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopPayAdressCell"];
        cell.shopCarClearingModel = _shopCarClearingModel;
        return cell;
    }
    if (indexPath.section == 1) {
        ShopPayInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopPayInfoCell"];
        cell.cart_List = _cartGoodsArray[indexPath.row];
        return cell;
    }
    
    if (indexPath.section == 2) {
        
        
        if (indexPath.row == 0) {
            
            PayPriceViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayPriceViewCell"];
            cell.switchView.on = NO;
            cell.switchView.hidden = NO;
            cell.priceTextField.text = [NSString stringWithFormat:@"  (可用余额:¥%.2f)", _wallet];
            cell.priceTextField.userInteractionEnabled = NO;
            cell.switchViewBlock =^(BOOL on,UISwitch * sw){
                
                if(_wallet < _order_Price){
                    
                    [self showErrorText:@"余额不足"];
                    sw.on = NO;
                    _useWallet = NO;
                    
                }else{
                    _useWallet = on;
                    
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
//                    _netPaypPrice = 0;
                    [payCell changeBtnState:0];
                    
//                    if (_netPaypPrice == 0) {
                        _payType = 0;
//                    }
                    
                }
                
//                if (on) {
//                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_quyuArray.count inSection:2];
//                    
//                    [indexPaths addObject: indexPath];
//                    [_quyuArray addObject:@"1"];
//                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                    [self.tabelView beginUpdates];
//                    [self.tabelView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                    [self.tabelView endUpdates];
//                    
//                }else{
//                    
//                    [_quyuArray removeObject:@"1"];
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
//                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
//                    [self.tabelView beginUpdates];
//                    [self.tabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
//                    [self.tabelView endUpdates];
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
                }else if ([text floatValue] > _order_Price){
                
                    [self showErrorText:@"用不了那么多"];
                    cell.priceTextField.text = @"";
                
                }else{
                    
                    _params[@"wallet_price"] = text;//使用钱包的金额
                    
                    _wallet_price = [text floatValue];
                    
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                    PayTypeCell* payCell = [tableView cellForRowAtIndexPath:cellIndexPath];
                    [payCell changeBtnState:_order_Price];
                    
                }
                
            };
            return cell;
            
        }


    }
    if (indexPath.section == 3) {
        __weak PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell"];
        
        cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_order_Price];
        cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
        
        cell.payTypeCellBlobk = ^(NSInteger payType){
            
            
            if (payType == 1) {
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝(支付¥%.2f)",_order_Price];
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付"];
                
                _payType = 2;
                
            }else{
                cell.wechatPayTitleLab.text = [NSString stringWithFormat:@"微信支付(支付¥%.2f)",_order_Price];
                cell.aliPayTitle.text = [NSString stringWithFormat:@"支付宝"];
                _payType = 6;
                
            }
            
            
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
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
        return  92;
    }
    if (indexPath.section == 1) {
        return  71;
    }
     if (indexPath.section == 2) {
        return 44;
    }
    if (indexPath.section == 3) {
        return 152;
    }
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        BOOL haveAdress = YES;
        if (haveAdress) {
             // 收货地址列表
            AdressListController * vc = [[AdressListController alloc]initWithNibName:@"AdressListController" bundle:nil];
            vc.type = 2;
            vc.adressListVCBlock = ^(AdressModel * adressModel){
            
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"store_id"] = @"1";
                params[@"freight_hash"] = _shopCarClearingModel.freight_hash;
                params[@"area_id"] = adressModel.area_id;
                params[@"city_id"] = adressModel.city_id;
                
                [MCNetTool postWithUrl:HttpShopCarEditAdressLoadHash params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self showSuccessText:msg];
                    
                    _offpay_hash = requestDic[@"offpay_hash"];
                    _offpay_hash_batch = requestDic[@"offpay_hash_batch"];
                    _address_id = adressModel.address_id;
                    

                    ShopPayAdressCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                    cell.adressModel = adressModel;
                    
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            };
            
            
            [self.navigationController pushViewController:vc animated:YES];
         }else{
             // 没有收货地址  去添加
            EditAdressController * vc = [[EditAdressController alloc]initWithNibName:@"EditAdressController" bundle:nil];
            vc.isEdit = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (IBAction)payBtnAction:(UIButton *)sender {
    self.payBtn.enabled = NO;
    self.payBtn.backgroundColor = [UIColor lightGrayColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.payBtn.enabled = YES;
        self.payBtn.backgroundColor = kThemeColor;
    });
    if (_useWallet) {
        
        // 使用钱包   ---去输入平台支付密码
        if (_payPassState == 0 ) {
            // 【0 未设置】  去设置 钱包支付密码
            
            SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
            vc.isSetNewPassWord = NO;
            vc.navigationItem.title = @"设置支付密码";
            
            vc.settingPayPassWordSuccBlock=^(){
                
                [self checkPayShopPwdRequest];
                
                [self inputPayPass];

                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (_payPassState == 1 ){
            //【1 已设置】
            
            [self inputPayPass];
            
        }
        
    }else{
        // 不使用钱包  直接使用网络支付
        
        [self submintRequestShopWithPayPass:nil];
        
        
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
                
                [self submintRequestShopWithPayPass:pwd];
                
                
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


#pragma mark - 网络支付

- (void)submintRequestShopWithPayPass:(NSString *)payPass{


    [self showText:@"正在生成订单"];
    
    
    _params[@"userid"] = kUserId;
    _params[@"ifcart"] = @(_ifcart); // 1 购物车结算  0，立即购买
    _params[@"store_id"] = @"1";//店铺ID
    _params[@"cart_id"] = _cart_id;//单个商品【购物车ID丨数量】 多个商品【购物车ID丨数量，购物车ID丨数量】
    _params[@"address_id"] = _address_id; //收货地址ID
    _params[@"vat_hash"] = _shopCarClearingModel.vat_hash;//需要传的参数1
    _params[@"offpay_hash"] = _offpay_hash;//需要传的参数2
    _params[@"offpay_hash_batch"] = _offpay_hash_batch;//需要传的参数3
    _params[@"payment_id"] = @(_payType); //  支付方式ID 1：货到付款 2：支付宝 6：微信
    _params[@"pay_name"] = @"online";// 【online 在线付款】【offline 货到付款 】
    
    _params[@"order_note"] = @"";//订单备注
    _params[@"invoice_id"] = @"";  // 	发票ID
    _params[@"distr_type"] = @"";//配送方式【暂无】
    _params[@"voucher"] = @"";// 优惠券【优惠券ID丨固定1丨优惠券金额】
    _params[@"postion"] = @"";//是否使用积分 1，使用 0，不使用
    _params[@"distribution_id"] = @"";//配送方式ID

    if (_payType == 0) {//  选择的是使用钱包付款，那么钱包付全款
        _params[@"wallet_price"] = @(_order_Price);//使用钱包的金额
    }
    
    if (_useWallet) {
        _params[@"member_paypwd"] = [payPass MD5]; //平台支付密码
    }
    
    [MCNetTool postWithUrl:HttpShopCarJieSuan params:_params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
        
        [self showSuccessText:msg];
        
        ShopPayModel * shopPayModel = [ShopPayModel mj_objectWithKeyValues:requestDic];
        
        
        [_params removeAllObjects];
        
        _order_id = shopPayModel.order_id;
        
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
            
            ShopPaySuccViewController * vc  =[[ShopPaySuccViewController alloc]initWithNibName:@"ShopPaySuccViewController" bundle:nil];
            vc.order_id =_order_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}

-(void)dealAlipayResult:(NSNotification*)notification{
    NSString*result=notification.object;
    if([result isEqualToString:@"9000"]){
        //在这里写支付成功之后的回调操作
        DeLog(@"支付宝支付成功");
        ShopPaySuccViewController * vc  =[[ShopPaySuccViewController alloc]initWithNibName:@"ShopPaySuccViewController" bundle:nil];
        vc.order_id =_order_id;

        [self.navigationController pushViewController:vc animated:YES];
        
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
        
        ShopPaySuccViewController * vc  =[[ShopPaySuccViewController alloc]initWithNibName:@"ShopPaySuccViewController" bundle:nil];
        vc.order_id =_order_id;
        [self.navigationController pushViewController:vc animated:YES];
       
    }else{
        //在这里写支付失败之后的回调操作
        DeLog(@"微信支付失败");
        
        kTipAlert(@"微信支付失败");
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
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
