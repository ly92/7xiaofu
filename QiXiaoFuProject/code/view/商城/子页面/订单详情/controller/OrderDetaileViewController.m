
//
//  OrderDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileViewController.h"
#import "ShopPayAdressCell.h"
#import "ShopOrderCell.h"
#import "OrderDetaileCell.h"
#import "OrderDetaileModel.h"
#import "ShopDetaileViewController.h"
#import "PurchaseShopViewController.h"
#import "BlockUIAlertView.h"
#import "OrderPayViewController.h"
#import "ShopOrderFooterView.h"
#import "ShopOrderHeaderView.h"
#import "OrderDetailLogisticsCell.h"
#import "XieYiViewController.h"
#import "OrderDetailMarkCell.h"
#import "OrderDetailSnCell.h"
#import "PurchaseShopStype2ViewController.h"


@interface OrderDetaileViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderDetaileModel * orderDetaileModel;

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIView *pickweView;

@end

@implementation OrderDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShopPayAdressCell" bundle:nil] forCellReuseIdentifier:@"ShopPayAdressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ShopOrderCell" bundle:nil] forCellReuseIdentifier:@"ShopOrderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetaileCell" bundle:nil] forCellReuseIdentifier:@"OrderDetaileCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailLogisticsCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailLogisticsCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailMarkCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailMarkCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailSnCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailSnCell"];

    
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;  //  随便设个不那么离谱的值
    
    
    _tableView.tableFooterView = [UIView new];

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self loadOrderData];

}


- (void)loadOrderData{

    [self showLoading];
    
    
        NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"order_id"] = _order_id;
    

    [MCNetTool postWithUrl:HttpShopOrderDeatile params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
        
        _orderDetaileModel = [OrderDetaileModel mj_objectWithKeyValues:requestDic];
        
        [_tableView reloadData];
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        
    }];
    


}





#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _orderDetaileModel.goods_list.count;
    }
    if (section == 5) {
        return _orderDetaileModel.goods_sn_type.count;

    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ShopPayAdressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopPayAdressCell"];
        cell.orderDetaileModel = _orderDetaileModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    if (indexPath.section == 1) {
        ShopOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:@"ShopOrderCell"];
        cell.indexPath = indexPath;
        cell.orderDetaileModel = _orderDetaileModel;
        return cell;
    }
    if (indexPath.section == 2) {
        OrderDetaileCell * cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetaileCell"];
        cell.orderDetaileModel = _orderDetaileModel;
        return cell;
    }
    if (indexPath.section == 3) {
        OrderDetailLogisticsCell * cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailLogisticsCell"];
         return cell;
    }
    
    if (indexPath.section == 4) {
        OrderDetailMarkCell * cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailMarkCell"];
        cell.markLab.text = _orderDetaileModel.order_beizhu;
        return cell;
    }
    if (indexPath.section == 5) {
        
        Goods_Sn_Type * type = _orderDetaileModel.goods_sn_type[indexPath.row];
        OrderDetailSnCell * cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailSnCell"];
        cell.titleLab.text = [NSString stringWithFormat:@"sn码: %@",type.goods_sn];
        if(type.goods_type_name.length != 0){
            cell.descLab.text = type.goods_type_name;
        }else{
            cell.descLab.text = @"";
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  92;
    }
    if (indexPath.section == 1) {
        return  81;
    }
    if (indexPath.section == 3) {
        return  44;
    }
    if (indexPath.section == 4) {
        return UITableViewAutomaticDimension;
    }
    if (indexPath.section == 5) {
        return 35;
    }
    return 84;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        Goodss_List * goodList = _orderDetaileModel.goods_list[indexPath.row];
        ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
        vc.goods_id =goodList.goods_id;
        vc.goods_image = goodList.goods_img;

        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3) {
        XieYiViewController * vc =[[XieYiViewController alloc]init];
        vc.title =@"查看物流";
        vc.type = 4;
        vc.orderId = _order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.5)];
        ShopOrderFooterView * shopOrderFooterView = [ShopOrderFooterView shopOrderFooterView];
        shopOrderFooterView.frame = CGRectMake(0, 0, kScreenWidth, 40.4);
        [footerView addSubview:shopOrderFooterView];
//        footerView.backgroundColor = [UIColor redColor];
         shopOrderFooterView.orderDetaileModel = _orderDetaileModel;
        shopOrderFooterView.order_id = _order_id;

        // 取消订单
        shopOrderFooterView.shopOrderCellCancleBlock = ^(NSString * order_id,NSIndexPath * cellIndexPath){
            
            
            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要取消此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                
                if(buttonIndex == 1){
                    
                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"store_id"] = @"1";
                    params[@"order_id"] = order_id;
                    params[@"state_info"] = @"这就是取消订单的原因";
                    [MCNetTool postWithUrl:HttpShopOrderCancel params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        [self showSuccessText:msg];
                        
                        [self .navigationController popViewControllerAnimated:YES];

                        
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                }
            } otherButtonTitles:@"确认"];
            [alert show];
            
            
        };
        // 支付
        shopOrderFooterView.shopOrderCellPayBlock = ^(NSString * order_id,NSString * pay_sn,NSString * order_price,NSIndexPath * cellIndexPath){
            
            OrderPayViewController * vc = [[OrderPayViewController alloc]initWithNibName:@"OrderPayViewController" bundle:nil];
            vc.pay_sn = pay_sn;
            vc.order_price = [order_price floatValue];
            vc.order_id = _order_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        // 删除订单
        shopOrderFooterView.shopOrderCellDeleateBlock = ^(NSString * order_id,NSIndexPath * cellIndexPath){
            
            if (_orderDetaileModel.state_type == 2){
                UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
                view.backgroundColor = [UIColor clearColor];
                UIButton *bg_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                bg_btn.frame = view.bounds;
                [bg_btn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
                bg_btn.backgroundColor = [UIColor blackColor];
                bg_btn.alpha = 0.5;
                [view addSubview:bg_btn];
                self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,view.height - 200, kScreenWidth, 200)];
                self.order_id = order_id;
                self.picker.delegate = self;
                self.picker.dataSource = self;
                self.picker.backgroundColor = [UIColor whiteColor];
                [view addSubview:self.picker];
                
                UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
                cancleBtn.frame = CGRectMake(0,view.height - 200 - 45, kScreenWidth/2.0, 44);
                [cancleBtn setBackgroundColor:[UIColor whiteColor]];
                UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [sureBtn setTitleColor:rgb(33, 33, 33) forState:UIControlStateNormal];
                [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
                sureBtn.frame = CGRectMake(kScreenWidth/2.0+1,view.height - 200 - 45, kScreenWidth/2.0-1, 44);
                [sureBtn setBackgroundColor:[UIColor whiteColor]];
                [view addSubview:cancleBtn];
                [view addSubview:sureBtn];
                [self.view addSubview:view];
                
                self.pickweView = view;
                
                return ;
            }

            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要取消此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                if(buttonIndex == 1){
                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"store_id"] = @"1";
                    params[@"order_id"] = _order_id;
                    
                        [MCNetTool postWithUrl:HttpShopOrderDel params:params success:^(NSDictionary *requestDic, NSString *msg) {
                            [self showSuccessText:msg];
                            
                            [self .navigationController popViewControllerAnimated:YES];
                        } fail:^(NSString *error) {
                            [self showErrorText:error];
                        }];
                }
            } otherButtonTitles:@"确认"];
            [alert show];
            
            
        };
        // 退换货
        shopOrderFooterView.shopOrderCellTuiHuanHuoBlock = ^(NSString * order_id,NSIndexPath * cellIndexPath){
            PurchaseShopViewController * vc = [[PurchaseShopViewController alloc]initWithNibName:@"PurchaseShopViewController" bundle:nil];
            vc.order_id = _order_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
        // 退换货2-物流
        shopOrderFooterView.shopOrderCellTuiHuanHuostpe2Block = ^(NSString * order_id, NSString * refund_type){
            PurchaseShopStype2ViewController* vc = [[PurchaseShopStype2ViewController alloc]initWithNibName:@"PurchaseShopStype2ViewController" bundle:nil];
            vc.order_id = order_id;
            vc.refund_type = refund_type;
            [self.navigationController pushViewController:vc animated:YES];
        };
        // 退换货3-确认完成
        shopOrderFooterView.shopOrderCellTuiHuanHuostpe3Block = ^(NSString * order_id,NSString * refund_type){
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"return_step_state"] = @"5";
            params[@"refund_id"] = _orderDetaileModel.refund_id;
            params[@"type"] = refund_type;
            
            [MCNetTool postWithUrl:HttpShopAdd_refund_all3 params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self dismissLoading];
                [self showSuccessText:msg];
            } fail:^(NSString *error) {
                [self dismissLoading];
                [self showErrorText:error];
            }];
        };
        
        
        // 提醒发货
        shopOrderFooterView.shopOrderCellTiXingFaHuoBlock = ^(NSString * order_sn,NSIndexPath * cellIndexPath){
            
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"order_sn"] = order_sn;
            
            
            [MCNetTool postWithUrl:HttpShopAddStoreMsg params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"已经提醒成功"];
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];

        };
        // 确认收货
        shopOrderFooterView.shopOrderCellQueRenShouHuoBlock = ^(NSString * order_id,NSIndexPath * cellIndexPath){
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"order_id"] = _order_id;
            
            [MCNetTool postWithUrl:HttpShopOrderFinish params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                
                [self loadOrderData];
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        };
        return footerView;

    }
    
    
//act=member_order&op=order_receive&userid=ec97332d1a8ad01ff7689de61fe63db3&store_id=1
//act=member_order&op=order_receive&userid=ec97332d1a8ad01ff7689de61fe63db3&store_id=1&order_id=341
//    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        ShopOrderHeaderView * shopOrderHeaderView =[[ShopOrderHeaderView alloc]init];
        shopOrderHeaderView.frame = CGRectMake(0, 10, kScreenWidth, 30);
        [headerView addSubview:shopOrderHeaderView];
        shopOrderHeaderView.orderDetaileModel = _orderDetaileModel;
        return headerView;

    }
    return nil;
   }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return 40.0f;
     }
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==1) {
        return 80;
    }
    return 0.00001f;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pickweView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 6;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *array = @[@"我不想买了",@"地址等信息填写错误，重买",@"商品价格较贵",@"商品重复下单",@"未按约定时间配送",@"其他原因"];
    if (array.count > row){
        return array[row];
    }
    return @"";
}

- (void)cancleAction{
    if ([self.view.subviews containsObject:self.pickweView]){
        [self.pickweView removeFromSuperview];
    }
}

- (void)sureAction{
    NSArray *array = @[@"我不想买了",@"地址等信息填写错误，重买",@"商品价格较贵",@"商品重复下单",@"未按约定时间配送",@"其他原因"];
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"type"] = @"1";
            params[@"order_id"] = _order_id;
            NSInteger row = [self.picker selectedRowInComponent:0];
            if (array.count > row){
                params[@"message"] = array[row];
            }else{
                params[@"message"] = @"其他原因";
            }
            [MCNetTool postWithUrl:HttpShopOrderCancleBeforDeliver params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                [self .navigationController popViewControllerAnimated:YES];
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"确认"];
    [alert show];
}


@end
