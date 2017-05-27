//
//  ReceivingOrderListViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ReceivingOrderListViewController.h"
#import "ReceivingOrderCell.h"
#import "ReceivingOrderViewController.h"
#import "ProductModel.h"
#import "ProductDetaileViewController.h"

@interface ReceivingOrderListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *ableOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *historyOrderBtn;

@property (nonatomic, copy) NSString *bill_type;//1:可接订单 2:历史订单

@end

@implementation ReceivingOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"接单";
    
    
    _dataArray = [NSMutableArray new];
    _page =1;
    
    [_tableView registerNib:[UINib nibWithNibName:@"ReceivingOrderCell" bundle:nil] forCellReuseIdentifier:@"ReceivingOrderCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    
    self.bill_type = @"1";
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}

- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        
        [self engMatchBillListWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        
        [self engMatchBillListWithPage:_page hud:NO];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self engMatchBillListWithPage:1 hud:YES];
    
    
}





- (void)engMatchBillListWithPage:(NSInteger )page hud:(BOOL )hud{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    params[@"bill_type"] = self.bill_type;
    
    
    hud?[self showLoading]:nil;
    
    [MCNetTool postWithCacheUrl:HttpMainEngMatchBillList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:nil;
        
        NSArray * array = [ProductModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray scrollView:_tableView receivingOrder:^{
            ReceivingOrderViewController * vc  = [[ReceivingOrderViewController alloc]initWithNibName:@"ReceivingOrderViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            //           kTipAlert(@"我要接单");
        } loadData:^{
            
        }];
        
        
        [_tableView reloadData];
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        
        
        [self receivingOrderItem];
        
        
        
        
    } fail:^(NSString *error) {
        
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        [self showErrorText:error];
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray scrollView:_tableView receivingOrder:^{
            ReceivingOrderViewController * vc  = [[ReceivingOrderViewController alloc]initWithNibName:@"ReceivingOrderViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            //           kTipAlert(@"我要接单");
        } loadData:^{
            
        }];
        
        
    }];
    
    
}

- (void)receivingOrderItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"设置空闲时间" target:self action:@selector(rightJieItemAction:)];
}


- (void)rightJieItemAction:(UIBarButtonItem *)item{
    
    
    ReceivingOrderViewController * vc  = [[ReceivingOrderViewController alloc]initWithNibName:@"ReceivingOrderViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    //           kTipAlert(@"我要接单");
    
    
}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceivingOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ReceivingOrderCell"];
    ProductModel * productModel = _dataArray[indexPath.section];
    cell.productModel = productModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductDetaileViewController * vc  = [[ProductDetaileViewController alloc]initWithNibName:@"ProductDetaileViewController" bundle:nil];
    ProductModel * productModel = _dataArray[indexPath.section];
    vc.p_id =productModel.id;
    [self.navigationController pushViewController:vc animated:YES];
    
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

#pragma mark -
- (IBAction)orderBtnAction:(UIButton *)btn {
    if (btn.selected){
        return;
    }
    
    if (btn == self.ableOrderBtn){
        self.ableOrderBtn.selected = YES;
        self.historyOrderBtn.selected = NO;
        
        self.bill_type = @"1";
    }else{
        self.ableOrderBtn.selected = NO;
        self.historyOrderBtn.selected = YES;
        
        self.bill_type = @"2";
    }
    [self engMatchBillListWithPage:1 hud:NO];
}



@end
