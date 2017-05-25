//
//  SpaceTimeViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/25.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SpaceTimeViewController.h"
#import "SpaceTimeModel.h"
#import "SpaceTimeCell.h"
#import "ReceivingOrderViewController.h"


@interface SpaceTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SpaceTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"空闲时间";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"新增" target:self action:@selector(addSpaceTime)];
    
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"SpaceTimeCell" bundle:nil] forCellReuseIdentifier:@"SpaceTimeCell"];
    _tableView.tableFooterView = [UIView new];
    
    [self addRefreshView];
}

//新增空闲时间
- (void)addSpaceTime{
    ReceivingOrderViewController * vc  = [[ReceivingOrderViewController alloc]initWithNibName:@"ReceivingOrderViewController" bundle:nil];
    vc.titleStr = @"新增空闲时间";
    [self.navigationController pushViewController:vc animated:YES];
    //           kTipAlert(@"我要接单");

}

- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        [self loadShopSpaceTimeListWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadShopSpaceTimeListWithPage:_page hud:NO];
        
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadShopSpaceTimeListWithPage:1 hud:YES];
}

- (void)loadShopSpaceTimeListWithPage:(NSInteger )page hud:(BOOL)hud{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    
    hud?[self showLoading]:@"";
    
    [MCNetTool postWithUrl:HttpMainSpaceTimeShow params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page ++;
        
        hud?[self dismissLoading]:@"";
        
        NSArray * array = [SpaceTimeModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        //如果是默认数据则不给予显示
        if (array.count == 1){
            SpaceTimeModel *model = array[0];
            if (model.tack_arrays.count == 0){
                [self.dataArray removeAllObjects];
            }
        }
        
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
        
        [YWNoNetworkView showNoNetworkInView:self.view reloadBlock:^{
            [self loadShopSpaceTimeListWithPage:_page hud: _page > 1 ? NO :YES ];
        }];
        
    }];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0){
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpaceTimeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"SpaceTimeCell"];
    if (self.dataArray.count > indexPath.row){
        SpaceTimeModel * spaceTimeModel =_dataArray[indexPath.section];
        cell.beginTimeLbl.text = [Utool comment_timeStamp2TimeFormatter:spaceTimeModel.service_stime];
        cell.endTimeLbl.text = [Utool comment_timeStamp2TimeFormatter:spaceTimeModel.service_etime];
        
        NSMutableArray *tackAreaArr = [NSMutableArray array];
        for (TackModel *tackModel in spaceTimeModel.tack_arrays) {
            [tackAreaArr addObject:tackModel.address];
        }
        cell.eareLbl.text = [tackAreaArr componentsJoinedByString:@","];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count > indexPath.row){
        SpaceTimeModel * spaceTimeModel =_dataArray[indexPath.section];
        
        ReceivingOrderViewController * vc  = [[ReceivingOrderViewController alloc]initWithNibName:@"ReceivingOrderViewController" bundle:nil];
        vc.spaceTimeModel = spaceTimeModel;
        vc.titleStr = @"修改空闲时间";
        [self.navigationController pushViewController:vc animated:YES];
        //           kTipAlert(@"我要接单");

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
