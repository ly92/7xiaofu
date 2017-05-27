//
//  EngineerListViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerListViewController.h"
#import "EngineerListCell.h"
#import "EngineerDetaileViewController.h"
#import "EngineerModel.h"

@interface EngineerListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;//页数
@end

@implementation EngineerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerListCell" bundle:nil] forCellReuseIdentifier:@"EngineerListCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 155;  //  随便设个不那么离谱的值

    [self loadRecommendEngineerModelDataWithPage:1 hud:YES];
    
    
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}


- (void)chooseItemAction:(UIBarButtonItem *)item{
    
    kTipAlert(@"筛选");
    
}

- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:_page hud:NO];
        
    }];
    
}




- (void)loadRecommendEngineerModelDataWithPage:(NSInteger)page hud:(BOOL)hud{
    
    
    hud?[self showLoading]:nil;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"curpage"] = @(page);
    
    
    NSString * url;
    
    if (_type ==1) {// 小七推荐工程师
        url =HttpMainXiaoQiFaDan;
    }else{
        // 工程师列表
        url = HttpMainEngList;
        params[@"gc_id"] = _gc_id;
    }
    
    [MCNetTool postWithCacheUrl:url params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:nil;
        
        NSArray * array = [EngineerModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];

        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];

    }];
    
}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EngineerListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerListCell"];
    EngineerModel * engineerModel= _dataArray[indexPath.section];
    cell.engineerModel =engineerModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return  147;
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 工程师详情
    EngineerModel * engineerModel= _dataArray[indexPath.section];
    EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
    vc.member_id = engineerModel.member_id;
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

@end
