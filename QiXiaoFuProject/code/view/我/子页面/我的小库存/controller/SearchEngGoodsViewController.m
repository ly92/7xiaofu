//
//  SearchEngGoodsViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/26.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SearchEngGoodsViewController.h"
#import "MyStockCell.h"
#import "BlockUIAlertView.h"
#import "MyStockModel.h"
#import "ChooseAreViewController.h"
#import "ChooseArea3ViewController.h"
#import "MyStockChangeZreaViewController.h"

@interface SearchEngGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, copy) NSString *search_type;//搜索类型
@property (nonatomic, copy) NSString *search_key;//搜索关键字
@end

@implementation SearchEngGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.search_key = @"";
    self.search_type = @"0";
    [self setupNavView];
    
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyStockCell" bundle:nil] forCellReuseIdentifier:@"MyStockCell"];
    _tableView.tableFooterView = [UIView new];
    
    [self addRefreshView];
}

//设置导航栏view
- (void)setupNavView{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth - 60, 30)];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [searchBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [searchBtn setTitleColor:rgb(33, 33, 33) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(filtAction) forControlEvents:UIControlEventTouchUpInside];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 0, kScreenWidth - 130, 30)];
    searchBar.delegate = self;
    [searchBar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"btn_btnbox_gray"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    searchBar.placeholder = @"请输入备件的SN码";
    self.searchBar = searchBar;
    [self.searchBar becomeFirstResponder];
    
    [navView addSubview:searchBtn];
    [navView addSubview:searchBar];
    
    self.navigationItem.titleView = navView;
    
}
//显示筛选条件
- (void)filtAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按照SN码",@"按照订单号",@"按照配件名称", nil];
    [sheet showInView:[UIApplication sharedApplication].windows[0]];
}

- (void)addRefreshView{
    [_tableView headerAddMJRefresh:^{
        
        [self loadMyStockDataWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadMyStockDataWithPage:_page hud:NO];
        
    }];
    
}

- (void)loadMyStockDataWithPage:(NSInteger )page hud:(BOOL)hud{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    params[@"search_type"] = self.search_type;
    params[@"search_key"] = self.search_key;
    
    
    [MCNetTool postWithCacheUrl:HttpMeSearchEngGoodsSn params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        NSArray * array = [MyStockModel mj_objectArrayWithKeyValuesArray:requestDic];
        
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
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyStockCell *  cell =[tableView dequeueReusableCellWithIdentifier:@"MyStockCell"];
//    cell.indexPath = indexPath;
    
    cell.myStockModel = _dataArray[indexPath.section];
    
    
    [cell.cancelBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        
        //        NSInteger  tag = btn.tag;
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要销毁这个小库存吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                
                MyStockModel * stockModel = _dataArray [indexPath.section];
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = stockModel.id;
                
                [MCNetTool postWithUrl:HttpMeClearEngGoodsSn params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
//                    [_dataArray removeObjectAtIndex:btn.tag];//移除数据源的数据
//                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:btn.tag];
//                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];//移除tableView中的section
                    [self loadMyStockDataWithPage:1 hud:NO];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
                
            }
            
        } otherButtonTitles:@"确认"];
        [alert show];
        
    }];
    
    [cell.changeAdressBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
//        NSInteger  tag = btn.tag;
        
        MyStockChangeZreaViewController * vc = [[MyStockChangeZreaViewController alloc]initWithNibName:@"MyStockChangeZreaViewController" bundle:nil];
        
        vc.myStockChangeZreaVCBlock =^(MAreasModel * areasModelProvince,MAreasModel * areasModelCity,MAreasModel * areasModelDis){
            
            
//            NSIndexPath * cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
//            MyStockCell * cell = [tableView cellForRowAtIndexPath:cellIndexPath];
            
            NSString * address_name = [NSString stringWithFormat:@"%@%@%@",areasModelProvince.area_name,areasModelCity.area_name,checkNULL(areasModelDis.area_name)];
            
            
//            [cell.adressBtn setTitle:[NSString stringWithFormat:@" %@",address_name] forState:UIControlStateNormal];
            
            MyStockModel * stockModel = _dataArray [btn.tag];
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"id"] = stockModel.id;
            params[@"prov_id"] = areasModelDis.area_id;
            params[@"city_id"] = areasModelCity.area_id;
            
            params[@"area_id"] = areasModelProvince.area_id;
            params[@"address_name"] = address_name;
            
            [MCNetTool postWithUrl:HttpMeSaveEngGoodsSnArea params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self loadMyStockDataWithPage:1 hud:NO];
                [self showSuccessText:msg];
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
            
        };
        [self.navigationController pushViewController:vc animated:YES];

    }];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  132;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.search_type = @"1";
        self.searchBar.placeholder = @"请输入备件的SN码";
    }
    else if(buttonIndex==1){
        self.search_type = @"2";
        self.searchBar.placeholder = @"请输入备件的订单号";
    }else if(buttonIndex==2){
        self.search_type = @"3";
        self.searchBar.placeholder = @"请输入备件的名称";
    }else if(buttonIndex==3){
        //取消
        self.search_type = @"0";
    }
    [self loadMyStockDataWithPage:1 hud:NO];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.search_key = searchBar.text;
    [searchBar resignFirstResponder];
    [self loadMyStockDataWithPage:1 hud:NO];
}


@end
