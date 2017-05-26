//
//  RecommendEngineerListVC.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "RecommendEngineerListVC.h"
#import "EngineerEditListCell.h"
#import "EngineerDetaileViewController.h"
#import "RecommendEngineerAllChooseHeaderView.h"
#import "RecommendEngineerAllChooseFooterView.h"
#import "RecommendEngineerModel.h"
#import "ProductModel.h"
#import "ProductCell.h"
#import "ProductDetaileViewController.h"
#import "NSArray+Utils.h"


@interface RecommendEngineerListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) RecommendEngineerAllChooseHeaderView * headerView;
@property(nonatomic, strong) RecommendEngineerAllChooseFooterView * footerView;

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger page;//页数


@property(nonatomic, strong) NSMutableArray *chooseArr;//选中数据的数组
@property(nonatomic, strong) NSMutableArray *markArr;//标记数据的数组
@property(nonatomic, strong) UIButton *deleteBtn;//删除
@property(nonatomic, strong) UIButton *selectedBtn;//选择按钮


@end

@implementation RecommendEngineerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chooseArr = [NSMutableArray array];
    self.markArr = [NSMutableArray array];
//    _dataArray = [NSMutableArray arrayWithArray:@[@"科比·布莱恩特",@"德里克·罗斯",@"勒布朗·詹姆斯",@"凯文·杜兰特",@"德怀恩·韦德",@"克里斯·保罗",@"德怀特·霍华德",@"德克·诺维斯基",@"德隆·威廉姆斯",@"斯蒂夫·纳什",@"保罗·加索尔",@"布兰顿·罗伊",@"奈特·阿奇博尔德",@"鲍勃·库西",@"埃尔文·约翰逊"]];

    self.navigationItem.title = @"小七推荐";
    
    _page = 1;
    _dataArray = [NSMutableArray new];    
    
    
    
    if(_por_id.length != 0){
    
        //选择按钮
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
        [_selectedBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_selectedBtn setTitleColor:RGB(248, 182, 182) forState:UIControlStateHighlighted];
        [_selectedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [_selectedBtn sizeToFit];
        [_selectedBtn addTarget:self action:@selector(chooseItemAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:_selectedBtn];
        self.navigationItem.rightBarButtonItem =selectItem;
    
    }
    
 
 
    [_tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];

    
    
    _tableView.tableFooterView = [UIView new];
    self.tableView.editing = NO;

    
    [self loadRecommendEngineerModelDataWithPage:1 hud:YES];
    
    
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadRecommendEngineerModelDataWithPage:(NSInteger)page hud:(BOOL)hud{


    hud?[self showLoading]:nil;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"curpage"] = @(page);
 

    [MCNetTool postWithCacheUrl:HttpMainXiaoQiJiedan params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page ++;
        
        hud?[self dismissLoading]:nil;

        NSArray * array = [ProductModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        
        
        
        if(_dataArray.count != 0){
        
            _selectedBtn.enabled = YES;
        }else{
            _selectedBtn.enabled = NO;

        }
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];

        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        page?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;

        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];

    }];

}




- (void)chooseItemAction:(UIButton *)item{
    
    item.selected =!item.selected;
    
    if (item.selected) {
        [self addFooterView];
        
        [_tableView hidenFooter];
        [_tableView hidenHeader];

    }else{
        [self hidenFooterView];
        [_tableView showHeader];
        [_tableView showFooter];
    }
    
    _deleteBtn.enabled = YES;
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {

        _headerView = [RecommendEngineerAllChooseHeaderView recommendEngineerAllChooseHeaderView];
        self.tableView.tableHeaderView = _headerView;
        [_headerView.allChooseBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            btn.selected =!btn.selected;
            [self selectAllBtnClick:btn.selected];
        }];
    }else{
         self.tableView.tableHeaderView = nil;
    }


}

- (void)addFooterView{

    _footerView = [RecommendEngineerAllChooseFooterView recommendEngineerAllChooseFooterView];
    _footerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
    [self.view addSubview:_footerView];

    [UIView animateWithDuration:0.15 animations:^{
        _footerView.frame = CGRectMake(0, kScreenHeight - 40 - 64, kScreenWidth, 40);
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    }];
    
    
    [_footerView.remindToOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        NSMutableArray * member_ids = [NSMutableArray new];
        
        [_chooseArr enumerateObjectsUsingBlock:^(ProductModel * productModel, NSUInteger idx, BOOL * _Nonnull stop) {
             [member_ids addObject:productModel.id];
         }];
        
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = _por_id;
        params[@"member_ids"] = [member_ids string];
        
        [MCNetTool postWithUrl:HttpMainBillMatchEngRemind params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            [self showSuccessText:@"已提醒工程师接单"];
            
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    }];

}


- (void)hidenFooterView{
     [UIView animateWithDuration:0.25 animations:^{
        _footerView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 40);
        self.tableView.tableFooterView = nil;
    }];
}

//
//全选
- (void)selectAllBtnClick:(BOOL )isAll{
    
    if (isAll) {
        for (int i = 0; i < self.dataArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
         }
        [self.chooseArr addObjectsFromArray:self.dataArray];

        DeLog(@"---chooseArr:\n%@", self.chooseArr);

    }else{
        self.tableView.editing =NO;
        self.tableView.editing =YES;
        [self.chooseArr removeAllObjects];

        DeLog(@"self.deleteArr:\n%@", self.chooseArr);

    }
    
}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
    ProductModel * productModel = _dataArray[indexPath.section];
    cell.productModel = productModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    if (self.tableView.editing) {
        
        [self.chooseArr addObject:[self.dataArray objectAtIndex:indexPath.section]];
        
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        ProductDetaileViewController * vc  = [[ProductDetaileViewController alloc]initWithNibName:@"ProductDetaileViewController" bundle:nil];
        ProductModel * productModel = _dataArray[indexPath.section];
        vc.p_id =productModel.id;
        [self.navigationController pushViewController:vc animated:YES];

        
        
//        EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    }

    
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.chooseArr removeObject:[self.dataArray objectAtIndex:indexPath.section]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadRecommendEngineerModelDataWithPage:_page hud:NO];

    }];
    
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
