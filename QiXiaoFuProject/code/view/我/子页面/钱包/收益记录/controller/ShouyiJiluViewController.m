//
//  ShouyiJiluViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/12/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShouyiJiluViewController.h"
#import "ShouyiCell.h"
#import "WalletDetaileModel.h"
#import "ShouyiModel.h"
#import "WalletDetaileCell.h"

@interface ShouyiJiluViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShouyiJiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收益明细";
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShouyiCell" bundle:nil] forCellReuseIdentifier:@"ShouyiCell"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"WalletDetaileCell" bundle:nil] forCellReuseIdentifier:@"WalletDetaileCell"];

    
    
    
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;  //  随便设个不那么离谱的值
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    
    [self loadShopOrderListWithPage:1 hud:YES];
    
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



- (void)loadShopOrderListWithPage:(NSInteger )page hud:(BOOL)hud{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    
    hud?[self showLoading]:@"";
    
    [MCNetTool postWithUrl:HttpMeShouyiJilu params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page ++;
        
        hud?[self dismissLoading]:@"";
        
        NSArray * array = [ShouyiModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    }];
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ShouyiCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShouyiCell"];
//    ShouyiModel * walletDetaileModel = _dataArray[indexPath.row];
//    cell.titleLab.text = walletDetaileModel.member_zs_name;
//    cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:walletDetaileModel.inputtime];
//    cell.descLab.text = walletDetaileModel.desc;
//    return cell;
    
    WalletDetaileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WalletDetaileCell"];
    ShouyiModel * walletDetaileModel = _dataArray[indexPath.row];
    cell.titleLab.text = walletDetaileModel.title;
    cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:walletDetaileModel.inputtime];
    cell.priceLab.text = [NSString stringWithFormat:@"%@",walletDetaileModel.shouyi];
    cell.contentLab.text = walletDetaileModel.desc;
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,10)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,10,0,10)];
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
