//
//  ShopOrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderViewController.h"
#import "ShopOrderCell.h"
#import "OrderDetaileViewController.h"
#import "PurchaseShopViewController.h"
#import "ShopOrderModel.h"
#import "BlockUIAlertView.h"
#import "OrderPayViewController.h"
#import "ShopOrderFooterView.h"
#import "ShopOrderHeaderView.h"

@interface ShopOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, copy) NSString *order_id;
@end

@implementation ShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"商城订单";
    
    
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShopOrderCell" bundle:nil] forCellReuseIdentifier:@"ShopOrderCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    
    [self addRefreshView];
    

    // Do any additional setup after loading the view from its nib.
}
- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        
        [self loadShopOrderListWithPage:1 hud:NO];

    }];
    
    [_tableView footerAddMJRefresh:^{
        [self loadShopOrderListWithPage:_page hud:NO];

    }];
 
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self loadShopOrderListWithPage:1 hud:YES];


}


- (void)loadShopOrderListWithPage:(NSInteger )page hud:(BOOL)hud{

    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"state_type"] = [NSString stringWithFormat:@"%@",self.shoppingOrderStatus ==OrderStatusAll ? @"" :@(self.shoppingOrderStatus)];//订单状态 【空字符串 所有订单】【1，待付款】【3，待收货】【4，待评价】【5，已完成】
    params[@"curpage"] = @(page);
    
    
    hud?[self showLoading]:@"";

    [MCNetTool postWithUrl:HttpShopOrderList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:@"";
        
        NSArray * array = [ShopOrderModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];

        [_tableView reloadData];
        
        //如果已经到头了，就不要上拉刷新了
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        
    } fail:^(NSString *error) {
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        hud?[self dismissLoading]:@"";
        
//        [self showErrorText:error];
//
//        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        [YWNoNetworkView showNoNetworkInView:self.view reloadBlock:^{
            [self loadShopOrderListWithPage:_page hud: _page > 1 ? NO :YES ];
        }];

    }];

}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShopOrderModel * shopOrderModel =_dataArray[section];
    return shopOrderModel.order_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopOrderCell * cell =[tableView dequeueReusableCellWithIdentifier:@"ShopOrderCell"];
    cell.indexPath = indexPath;
    ShopOrderModel * shopOrderModel =_dataArray[indexPath.section];
    cell.shopOrderModel =shopOrderModel;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  81;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopOrderModel * shopOrderModel =_dataArray[indexPath.section];
    OrderDetaileViewController * vc  = [[OrderDetaileViewController alloc]initWithNibName:@"OrderDetaileViewController" bundle:nil];
    vc.order_id = shopOrderModel.order_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.5)];
    ShopOrderFooterView * shopOrderFooterView = [ShopOrderFooterView shopOrderFooterView];
    shopOrderFooterView.frame = CGRectMake(0, 0, kScreenWidth, 40.4);
    [footerView addSubview:shopOrderFooterView];
    footerView.backgroundColor = [UIColor redColor];
    ShopOrderModel * shopOrderModel =_dataArray[section];
    shopOrderFooterView.shopOrderModel =shopOrderModel;

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
                    
                    [_dataArray removeObjectAtIndex:cellIndexPath.section];
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:cellIndexPath.section];
                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];//移除tableView中的section
                    
                    [self loadShopOrderListWithPage:1 hud:YES];

                    
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
        vc.order_id = order_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    // 删除订单
    shopOrderFooterView.shopOrderCellDeleateBlock = ^(NSString * order_id,NSIndexPath * cellIndexPath){
        
        if (self.shoppingOrderStatus == OrderStatusReadyGo){
            self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.height - 200, kScreenWidth, 200)];
            self.order_id = order_id;
            self.picker.delegate = self;
            self.picker.dataSource = self;
            self.picker.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:self.picker];
            [self.picker reloadAllComponents];
            return ;
        }
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"store_id"] = @"1";
                params[@"order_id"] = order_id;
                
                [MCNetTool postWithUrl:HttpShopOrderDel params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:msg];
                    
                    // 或者
                    [_dataArray removeObjectAtIndex:cellIndexPath.section];
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:cellIndexPath.section];
                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];//移除tableView中的section
                    
                    [self loadShopOrderListWithPage:1 hud:YES];

                    
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
        vc.order_id = order_id;
        vc.purchaseShopViewBlock =^(){
             [self loadShopOrderListWithPage:1 hud:YES];
        };
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
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定收货" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"store_id"] = @"1";
                params[@"order_id"] = order_id;
                
                [MCNetTool postWithUrl:HttpShopOrderFinish params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:msg];
                    
                    [self loadShopOrderListWithPage:1 hud:YES];
                    
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            }
        } otherButtonTitles:@"确认"];
        [alert show];
        
    };
    return footerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    ShopOrderHeaderView * shopOrderHeaderView =[[ShopOrderHeaderView alloc]init];
    shopOrderHeaderView.frame = CGRectMake(0, 10, kScreenWidth, 30);
    [headerView addSubview:shopOrderHeaderView];
    ShopOrderModel * shopOrderModel =_dataArray[section];
    shopOrderHeaderView.shopOrderModel =shopOrderModel;

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
 }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40.5f;
}


-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.picker removeFromSuperview];
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *array = @[@"我不想买了",@"地址等信息填写错误，重买",@"商品价格较贵",@"商品重复下单",@"未按约定时间配送",@"其他原因"];
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要取消此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"type"] = @"1";
            params[@"order_id"] = self.order_id;
            if (array.count > row){
                params[@"message"] = array[row];
            }else{
                params[@"message"] = @"其他原因";
            }
            [MCNetTool postWithUrl:HttpShopOrderCancleBeforDeliver params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                [self loadShopOrderListWithPage:1 hud:YES];
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"确认"];
    [alert show];
    
}


@end
