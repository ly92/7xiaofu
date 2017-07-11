//
//  MatchingEngineerListVC.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MatchingEngineerListVC.h"
#import "EngineerEditListCell.h"
#import "EngineerDetaileViewController.h"
#import "RecommendEngineerAllChooseHeaderView.h"
#import "RecommendEngineerAllChooseFooterView.h"
#import "EngineerModel.h"
#import "NSArray+Utils.h"
#import "MatchingEngineerListMapVC.h"

@interface MatchingEngineerListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic, strong) RecommendEngineerAllChooseHeaderView * headerView;
@property(nonatomic, strong) RecommendEngineerAllChooseFooterView * footerView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;//页数


@property(nonatomic, strong) NSMutableArray *chooseArr;//选中数据的数组
@property(nonatomic, strong) NSMutableArray *markArr;//标记数据的数组
@property(nonatomic, strong) UIButton *deleteBtn;//删除
@property(nonatomic, strong) UIButton *selectedBtn;//选择按钮

@end

@implementation MatchingEngineerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.chooseArr = [NSMutableArray array];
    self.markArr = [NSMutableArray array];
    
    self.navigationItem.title = @"匹配工程师";
    
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    
    UIBarButtonItem * mapItem = [UIBarButtonItem itemCancleWithTitle:@"地图" target:self action:@selector(mapItemAction:)];
    
    UIBarButtonItem * chooseItem = [UIBarButtonItem itemWithTitle:@"选择" target:self action:@selector(chooseItemAction:)];
    
    self.navigationItem.rightBarButtonItems = @[chooseItem,mapItem];
    
    //选择按钮
    _selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    _selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    [_selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    [_selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
    [_selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_selectedBtn setTitleColor:RGB(248, 182, 182) forState:UIControlStateHighlighted];
    [_selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_selectedBtn sizeToFit];
    [_selectedBtn addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:_selectedBtn];
    self.navigationItem.rightBarButtonItem =selectItem;
    
    
    [_tableview registerNib:[UINib nibWithNibName:@"EngineerEditListCell" bundle:nil] forCellReuseIdentifier:@"EngineerEditListCell"];
    _tableview.tableFooterView = [UIView new];
    self.tableview.editing = NO;
    
    
    [self loadRecommendEngineerModelDataWithPage:1 hud:YES];
    
    
    [self addRefreshView];

    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)mapItemAction:(UIBarButtonItem *)item{
    
    
    MatchingEngineerListMapVC * vc= [[MatchingEngineerListMapVC alloc] initWithNibName:@"MatchingEngineerListMapVC" bundle:nil];
    vc.mapItemArray = _dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)loadRecommendEngineerModelDataWithPage:(NSInteger)page hud:(BOOL)hud{
    
    
    hud?[self showLoading]:nil;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"curpage"] = @(page);
    params[@"id"] = _orderId;
    params[@"userid"] = kUserId;

    
    [MCNetTool postWithCacheUrl:HttpMainBillMatchEngList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:nil;
        
        NSArray * array = [EngineerModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableview reloadData];
        
        if (array.count < 10) {
            [_tableview hidenFooter];
        }
        page==1?[_tableview headerEndRefresh]:[_tableview footerEndRefresh];;
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableview];

        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        page==1?[_tableview headerEndRefresh]:[_tableview footerEndRefresh];;
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableview];
    }];
}


- (void)chooseItemAction:(UIButton *)item{
    
    item.selected =!item.selected;
    
    if (item.selected) {
        [self addFooterView];
        
        [_tableview hidenFooter];
        [_tableview hidenHeader];
        
    }else{
        [self hidenFooterView];
        [_tableview showHeader];
        [_tableview showFooter];
    }
    
    
    
    _deleteBtn.enabled = YES;
    //支持同时选中多行
    self.tableview.allowsMultipleSelectionDuringEditing = YES;
    self.tableview.editing = !self.tableview.editing;
    if (self.tableview.editing) {
        
        _headerView = [RecommendEngineerAllChooseHeaderView recommendEngineerAllChooseHeaderView];
        self.tableview.tableHeaderView = _headerView;
        [_headerView.allChooseBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            btn.selected =!btn.selected;
            [self selectAllBtnClick:btn.selected];
        }];
    }else{
        self.tableview.tableHeaderView = nil;
    }
    
    
}

- (void)addFooterView{
    
    _footerView = [RecommendEngineerAllChooseFooterView recommendEngineerAllChooseFooterView];
    _footerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    [self.view addSubview:_footerView];
    
    [UIView animateWithDuration:0.15 animations:^{
        _footerView.frame = CGRectMake(0, kScreenHeight - 40 - 64, kScreenWidth, 40);
        self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    }];
    
    [_footerView.remindToOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        NSMutableArray * ids = [NSMutableArray new];
        [self.chooseArr enumerateObjectsUsingBlock:^(EngineerModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [ids addObject:obj.member_id];
            
        }];
        
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"id"] = _orderId;
        params[@"member_ids"] = [ids string];
        params[@"userid"] = kUserId;

        [MCNetTool postWithUrl:HttpMainBillMatchEngRemind params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            
            
            [self showSuccessText:@"已提醒工程师接单"];
            
            self.tableview.editing =NO;
            self.tableview.editing =YES;
            
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        

        
    }];
    
    
    
}


- (void)hidenFooterView{
    [UIView animateWithDuration:0.25 animations:^{
        _footerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
        self.tableview.tableFooterView = nil;
    }];
}


//全选
- (void)selectAllBtnClick:(BOOL )isAll{
    
    if (isAll) {
        for (int i = 0; i < self.dataArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            [self.tableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        [self.chooseArr addObjectsFromArray:self.dataArray];

    }else{
        self.tableview.editing =NO;
        self.tableview.editing =YES;   
    }
    
    NSLog(@"self.deleteArr:%@", self.chooseArr);
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EngineerEditListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerEditListCell"];
    
    EngineerModel * engineerModel = _dataArray[indexPath.section];
    cell.engineerModel =engineerModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  147;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.tableview.editing) {
        
        [self.chooseArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
        
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EngineerModel * engineerModel = _dataArray[indexPath.section];
        EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
        vc.member_id = engineerModel.member_id;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.chooseArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)addRefreshView{
    
    [_tableview headerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:1 hud:NO];
    }];
    [_tableview footerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:_page hud:NO];
        
    }];
    
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
