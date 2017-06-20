//
//  ChooseSNNumViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseSNNumViewController.h"
#import "ChooseSNNumCell.h"
#import "MyStockModel.h"
#import "NSArray+Utils.h"

@interface ChooseSNNumViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong)NSIndexPath *indexPath;//用来记录tableviewcell选中位置

@property(nonatomic, strong) NSMutableArray *chooseArr;//选中数据的数组

@property(nonatomic, strong) NSMutableDictionary * selectValueDictionary;//选中数据的数组


@end

@implementation ChooseSNNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.tableView.editing = YES;
//    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    [_tableView registerNib:[UINib nibWithNibName:@"ChooseSNNumCell" bundle:nil] forCellReuseIdentifier:@"ChooseSNNumCell"];

    _tableView .tableFooterView = [UIView new];

    if (self.isUsedGoods){
        self.navigationItem.title = @"所用备件";
        if (self.orderDetaileProModel.goods.count > 0){
            [self.tableView reloadData];
        }
        
    }else{
        self.navigationItem.title = @"选择SN码";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(tureItemAction:)];
        _chooseArr = [NSMutableArray array];
        _dataArray = [NSMutableArray new];
        _page = 1;
        
        _selectValueDictionary = [NSMutableDictionary new];
        
        if (_selectDict.count != 0) {
            _selectValueDictionary = [NSMutableDictionary dictionaryWithDictionary:_selectDict];
        }

        [self loadMyStockDataWithPage:1 hud:YES];
        [self addRefreshView];
    }


    // Do any additional setup after loading the view from its nib.
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
    
    
    NSString *url;
    
    if(_order_id.length != 0 ){
         params[@"order_id"] = _order_id;
        url = HttpMeGetReturnGoodsSn;
    }else{
        url = HttpMeGetEngGoodsSn;
    }
    
    
    [MCNetTool postWithCacheUrl:url params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
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

- (void)tureItemAction:(UIBarButtonItem *)item{
    
    if(_selectValueDictionary.count == 0){
        [self showErrorText:@"请选择备件sn码"];
        return;
    }
    
    if (_chooseSNNumBlock) {
        _chooseSNNumBlock(_selectValueDictionary);
      }
    [self.navigationController popViewControllerAnimated:YES];
    
    LxDBAnyVar(_selectValueDictionary.allKeys);

}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isUsedGoods){
        return self.orderDetaileProModel.goods.count;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseSNNumCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ChooseSNNumCell"];
    
    if (self.isUsedGoods){
        if (self.orderDetaileProModel.goods.count > indexPath.row){
            GoodsModel *goodModel = self.orderDetaileProModel.goods[indexPath.row];
            cell.titleLab.text = goodModel.goods_name;
            cell.contentLab.text = goodModel.goods_sn;
            cell.tintColor = kThemeColor;
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
    }else{
        MyStockModel *  myStockModel  = _dataArray[indexPath.row];
        cell.titleLab.text = myStockModel.goods_name;
        cell.contentLab.text = myStockModel.goods_sn;
        cell.tintColor = kThemeColor;
        
        NSArray *value = [_selectValueDictionary allKeys];
        if ([value containsObject:myStockModel.id])
        {
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
        }else
        {
            cell.accessoryType =UITableViewCellAccessoryNone;
            
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
////    MyStockModel *  myStockModel  = _dataArray[indexPath.section];
////
////    [tableView deselectRowAtIndexPath:indexPath animated:NO];
////    ChooseSNNumCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
////    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
////    newCell.tintColor = kThemeColor;
////    if (self.indexPath && self.indexPath != indexPath) {
////        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.indexPath];
////        oldCell.accessoryType = UITableViewCellAccessoryNone;
////    }
////    self.indexPath = indexPath;
////    
////    if (_chooseSNNumBlock) {
////        _chooseSNNumBlock(myStockModel.goods_sn,myStockModel.id);
////    }
////    [self.navigationController popViewControllerAnimated:YES];
//    
//    
//    if (self.tableView.editing) {
//         [self.chooseArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
//     }
//    
//    
//}
//
//
////取消选中时 将存放在self.deleteArr中的数据移除
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
//    
//    if (self.tableView.editing) {
//         [self.chooseArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
//     }
//
//}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isUsedGoods){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        ChooseSNNumCell *cell = [self.tableView cellForRowAtIndexPath: indexPath ];
        
        MyStockModel *  myStockModel  = _dataArray[indexPath.row];
        
        if (cell.accessoryType ==UITableViewCellAccessoryNone){
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
            [_selectValueDictionary setObject:myStockModel.goods_sn forKey:myStockModel.id];
        }
        else{
            [_selectValueDictionary removeObjectForKey:myStockModel.id];
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}















- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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
