
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



@interface OrderDetaileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderDetaileModel * orderDetaileModel;

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
        return 60;
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
        footerView.backgroundColor = [UIColor redColor];
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
            
            
            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                
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
        return 40.5f;
    }
    return 0.00001f;

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
