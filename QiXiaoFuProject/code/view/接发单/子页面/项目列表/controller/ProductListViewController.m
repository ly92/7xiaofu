//
//  ProductListViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductCell.h"
#import "ProductCell2.h"
#import "ProductDetaileViewController.h"
#import "FilterView.h"
#import "ProductModel.h"
//#import "TPKeyboardAvoidingTableView.h"
#import "SearchViewControler.h"
#import "BaseNavigationController.h"
#import "NSDate+Utils.h"

@interface ProductListViewController ()<FilterViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FilterView * filterView;

@property (nonatomic, strong) NSArray *classifys;

@property (nonatomic, strong) NSArray *serviceTime;

@property (nonatomic, strong) NSArray *servicePrice;

@property (nonatomic, strong) UIButton *filtButton;

@property(nonatomic, assign) NSInteger page;//页数
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic, copy) NSString * keywords;//	发单名称 【模糊搜索】
@property(nonatomic, copy) NSString * service_sprice;//起始价格
@property(nonatomic, copy) NSString * service_eprice;//结束价格
@property(nonatomic, copy) NSString * service_stime;//起始预约时间【时间戳
@property(nonatomic, copy) NSString * service_etime;//结束预约时间【时间戳】


@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _dataArray = [NSMutableArray new];
    _page = 1;
    
    UIBarButtonItem * secrchItem = [UIBarButtonItem itemWithImage:@"icon_search" highImage:@"icon_search" target:self action:@selector(secrchItemAction:)];
    
    UIButton *filtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filtButton setBackgroundImage:[UIImage imageNamed:@"icon_select_n"] forState:UIControlStateNormal];
    [filtButton setBackgroundImage:[UIImage imageNamed:@"icon_select_s"] forState:UIControlStateHighlighted];
    [filtButton setBackgroundImage:[UIImage imageNamed:@"icon_select_s"] forState:UIControlStateSelected];
    filtButton.size = filtButton.currentBackgroundImage.size;
    [filtButton addTarget:self action:@selector(filtItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _filtButton = filtButton;
    
    UIBarButtonItem * filtItem = [[UIBarButtonItem alloc]initWithCustomView:filtButton];
    UIBarButtonItem * item =    [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:nil];
    self.navigationItem.rightBarButtonItems= @[filtItem,item,secrchItem];
    
    
    _classifys = @[@"服务时间",@"服务金额"];
    _serviceTime = @[@"服务时间",@"默认",@"由远到近",@"由近到远"];
    _servicePrice = @[@"服务金额",@"默认",@"由多到少",@"由少到多"];
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 155;  //  随便设个不那么离谱的值
    
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductCell2" bundle:nil] forCellReuseIdentifier:@"ProductCell2"];

    _tableView.tableFooterView = [UIView new];
    
    
    [self loadProductModelDataWithPage:1 hud:YES];
    
    
    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}


- (void)loadProductModelDataWithPage:(NSInteger)page hud:(BOOL)hud{
    
    
    hud?[self showLoading]:nil;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"curpage"] = @(page);//页数
    params[@"gc_id"] = _gc_id;//	分类ID
    if (_keywords) {
        params[@"keywords"] = _keywords;//发单名称 【模糊搜索】
    }
    if (_service_sprice) {
        params[@"service_sprice"] = _service_sprice;//起始价格
    }
    if (_service_eprice) {
        params[@"service_eprice"] = _service_eprice;//结束价格
    }
    if (_service_stime) {
        params[@"service_stime"] = _service_stime;//起始预约时间【时间戳】
    }
    if (_service_etime) {
        params[@"service_etime"] = _service_etime;//结束预约时间【时间戳】
    }
    
    
    [MCNetTool postWithCacheUrl:HttpMainProductList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:nil;
        
        NSArray * array = [ProductModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];;
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    }];
    
}

- (void)addRefreshView{
    [_tableView headerAddMJRefresh:^{
        [self loadProductModelDataWithPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadProductModelDataWithPage:_page hud:NO];
    }];
}



-(void)secrchItemAction:(UIBarButtonItem *)item{
    
    SearchViewControler * vc = [[SearchViewControler alloc]init];
    vc.type = 1;
    BaseNavigationController * nvc = [[BaseNavigationController alloc]initWithRootViewController:vc];
    
    vc.searchViewBlock = ^(NSString * searchKey){
        
        _keywords = searchKey;
        
        [self loadProductModelDataWithPage:1 hud:YES];
        
    };
    [self presentViewController:nvc animated:YES completion:^{
        
    }];
    
}


- (void)filtItemAction:(UIButton *)item{
    
    item.selected =!item.selected;
    if (!_filterView) {
        
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.frame.size.height)];
        _filterView.delegate = self;
        [self.view addSubview:_filterView];
        [UIView animateWithDuration:0.25 animations:^{
            _filterView.frame = CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
        } completion:^(BOOL finished) {
        }];
        
        WEAKSELF
        _filterView.filterViewScrollBlock =^(){
            [weakSelf.view endEditing:YES];
        };
        
    }else{
        [self dismisFilterView];
        
    }
}



#pragma mark - FilterViewDelegate
- (void)pickerViewControllerdismis:(NSDictionary *)dict{
    
    LxDBAnyVar(dict);
    
    
    checkNULL(dict[@"0"]);
    
    //    NSArray * yuyueArray = @[@"全部",@"7天以内",@"15天以内",@"15天以上"];
    NSString * index0 = checkNULL(dict[@"0"]);
    
    if (index0.length != 0) {
        
        NSInteger times = [[[NSDate date] timestamp] integerValue];
        if ([index0 integerValue] ==0){
            _service_stime = [NSString stringWithFormat:@"%@",@(times)];
            _service_etime =[NSString stringWithFormat:@"%@",@(times + 10*365*24*60*60)];
            
        }else if ([index0 integerValue] ==1){
            _service_stime = [NSString stringWithFormat:@"%@",@(times)];
            _service_etime =[NSString stringWithFormat:@"%@",@(times + 7*24*60*60)];
        }else if ([index0 integerValue] ==2){
            _service_stime = [NSString stringWithFormat:@"%@",@(times)];
            _service_etime =[NSString stringWithFormat:@"%@",@(times + 15*24*60*60)];
        }else if ([index0 integerValue] ==3){
            _service_stime = [NSString stringWithFormat:@"%@",@(times)];
            _service_etime =[NSString stringWithFormat:@"%@",@(times + 10*365*24*60*60)];
        }
        
    }
    
    
    
    //    NSArray * priceArray = @[@"全部",@"4000",@"2000-5000",@"5000以上"];
    NSString * index2 = checkNULL(dict[@"2"]);
    
    if (index2.length != 0) {
        
        if ([index2 integerValue] ==0){
            
            _service_sprice = [NSString stringWithFormat:@"%@",@(0)];
            _service_eprice = [NSString stringWithFormat:@"%@",@(99999999999)];
            
        }else if ([index2 integerValue] ==1){
            
            _service_sprice = [NSString stringWithFormat:@"%@",@(0)];
            _service_eprice = [NSString stringWithFormat:@"%@",@(4000)];
        }else if ([index2 integerValue] ==2){
            
            _service_sprice = [NSString stringWithFormat:@"%@",@(2000)];
            _service_eprice = [NSString stringWithFormat:@"%@",@(4000)];
            
        }else if ([index2 integerValue] ==3){
            
            _service_sprice = [NSString stringWithFormat:@"%@",@(5000)];
            _service_eprice = [NSString stringWithFormat:@"%@",@(99999999999)];
        }
    }
    
    
    NSString *  service_sprice = dict[@"211"];// 起始价格
    NSString *  service_eprice = dict[@"212"];// 起始价格
    
    if(service_eprice.length != 0){
        _service_sprice =service_sprice;// 起始价格
        _service_eprice =service_eprice;// 结束价格
    }
    
    
    NSString *  service_stime = dict[@"111"];// 开始时间
    //NSString *  service_etime = dict[@"112"];// 结束时间
    
    if (service_stime.length != 0) {
        // 开始时间
        _service_stime = [Utool timestampForDateFromString:dict[@"111"] withFormat:@"yyyy.MM.dd HH:mm"]          ;
        // 结束时间
        _service_etime = [Utool timestampForDateFromString:dict[@"112"] withFormat:@"yyyy.MM.dd HH:mm"];
        
    }
    
    [self loadProductModelDataWithPage:1 hud:YES];
    
    
    [self dismisFilterView];
    
}

- (void)contactsPickerViewControllerdismis:(FilterView *)controller{
    
    
    
    
    [self dismisFilterView];
}
- (void)dismisFilterView{
    
    [UIView animateWithDuration:0.25 animations:^{
        _filterView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [_filterView removeFromSuperview];
        _filterView = nil;
        _filtButton.selected = NO;
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
    
    ProductModel * productModel = _dataArray[indexPath.section];
    
    if ([productModel.bill_statu intValue] == 1) {
        ProductCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
        cell.productModel = productModel;
        return cell;
    }else{
        ProductCell2 *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductCell2"];
        cell.productModel = productModel;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  180;
    
    //    return UITableViewAutomaticDimension;
    
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



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
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
