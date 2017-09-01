//
//  MyStockViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MyStockViewController.h"
#import "MyStockCell.h"
#import "BlockUIAlertView.h"
#import "MyStockModel.h"
#import "ChooseAreViewController.h"
#import "ChooseArea3ViewController.h"
#import "MyStockChangeZreaViewController.h"
#import "SearchEngGoodsViewController.h"

@interface MyStockViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger page;

@end

@implementation MyStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的小库存";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_search" highImage:@"icon_search" target:self action:@selector(searchEndGoods)];
    _dataArray = [NSMutableArray new];
    _page = 1;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyStockCell" bundle:nil] forCellReuseIdentifier:@"MyStockCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    [self loadMyStockDataWithPage:1 hud:YES];
    
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}

//搜索
- (void)searchEndGoods{
    SearchEngGoodsViewController *searchGoodsVC = [[SearchEngGoodsViewController alloc] init];
    [self.navigationController pushViewController:searchGoodsVC animated:YES];
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
    params[@"search_type"] = @"1";
    params[@"search_key"] = @"";
    
    
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

    
    
    
//    NSMutableDictionary * params = [NSMutableDictionary new];
//    params[@"userid"] = kUserId;
//    params[@"curpage"] = @(page);
// 
//    [MCNetTool postWithCacheUrl:HttpMeGetEngGoodsSn params:params success:^(NSDictionary *requestDic, NSString *msg) {
//        
//        _page = page;
//        _page ++;
//        
//        NSArray * array = [MyStockModel mj_objectArrayWithKeyValuesArray:requestDic];
//        
//        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
//        
//        [_tableView reloadData];
//        
//        if (array.count < 10) {
//            [_tableView hidenFooter];
//        }
//        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
//        
//        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
//
//        
//    } fail:^(NSString *error) {
//        [self showErrorText:error];
//        
//        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
//        
//        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
//
//
//    }];

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
 
  /*
//        ChooseAreViewController * vc = [[ChooseAreViewController alloc]initWithNibName:@"ChooseAreViewController" bundle:nil];
//
//        vc.chooseAreBlock = ^(NSString * area_name,NSString * area_id){
//            
//            
//            
//            NSIndexPath * cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
//            
//            MyStockCell * cell = [tableView cellForRowAtIndexPath:cellIndexPath];
// 
//            [cell.adressBtn setTitle:[NSString stringWithFormat:@" %@",area_name] forState:UIControlStateNormal];
//
//        
//            MyStockModel * stockModel = _dataArray [btn.tag];
//
//            NSMutableDictionary * params = [NSMutableDictionary new];
//            params[@"userid"] = kUserId;
//            params[@"id"] = stockModel.id;
//            params[@"area_id"] = area_id;
//            params[@"address_name"] = area_name;
//
//            [MCNetTool postWithUrl:HttpMeSaveEngGoodsSnArea params:params success:^(NSDictionary *requestDic, NSString *msg) {
//                [self showSuccessText:msg];
//            } fail:^(NSString *error) {
//                [self showErrorText:error];
//            }];
//
//        };
//        [self.navigationController pushViewController:vc animated:YES];

        
        
//        ChooseArea3ViewController * vc = [[ChooseArea3ViewController alloc]initWithNibName:@"ChooseArea3ViewController" bundle:nil];
//        
//        vc.chooseArea3ViewBlock =^(AreasModel * areasModelProvince,AreasModel * areasModelCity,AreasModel * areasModelDis){
//            
//
//            NSIndexPath * cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
//            MyStockCell * cell = [tableView cellForRowAtIndexPath:cellIndexPath];
//            
//            NSString * address_name = [NSString stringWithFormat:@"%@%@%@",areasModelProvince.area_name,areasModelCity.area_name,areasModelDis.area_name];
//            
//            
//            [cell.adressBtn setTitle:[NSString stringWithFormat:@" %@",address_name] forState:UIControlStateNormal];
//            
//            MyStockModel * stockModel = _dataArray [btn.tag];
//            
//            NSMutableDictionary * params = [NSMutableDictionary new];
//            params[@"userid"] = kUserId;
//            params[@"id"] = stockModel.id;
//            params[@"prov_id"] = areasModelDis.area_id;
//            params[@"city_id"] = areasModelCity.area_id;
//            params[@"area_id"] = areasModelProvince.area_id;
//            params[@"address_name"] = address_name;
//            
//            
//            NSDictionary * pra = @{@"1":@"2"};
//            
//            [MCNetTool postWithUrl:HttpMeSaveEngGoodsSnArea params:params success:^(NSDictionary *requestDic, NSString *msg) {
//                [self showSuccessText:msg];
//            } fail:^(NSString *error) {
//                [self showErrorText:error];
//            }];
//
//        };
//         [self.navigationController pushViewController:vc animated:YES];
//        
//        
        */
        MyStockChangeZreaViewController * vc = [[MyStockChangeZreaViewController alloc]initWithNibName:@"MyStockChangeZreaViewController" bundle:nil];
        
        vc.myStockChangeZreaVCBlock =^(MAreasModel * areasModelProvince,MAreasModel * areasModelCity,MAreasModel * areasModelDis){
            
            
//            NSIndexPath * cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:tag];
//            MyStockCell * cell = [tableView cellForRowAtIndexPath:cellIndexPath];
            
            NSString * address_name = [NSString stringWithFormat:@"%@%@%@",areasModelProvince.area_name,areasModelCity.area_name,checkNULL(areasModelDis.area_name)];
            
            
//            [cell.adressBtn setTitle:[NSString stringWithFormat:@" %@",address_name] forState:UIControlStateNormal];
            
            MyStockModel * stockModel = _dataArray [indexPath.section];
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
