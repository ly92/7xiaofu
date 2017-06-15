//
//  WalletDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "WalletDetaileViewController.h"
#import "WalletDetaileCell.h"
#import "WalletDetaileModel.h"
#import "ShouyiJiluViewController.h"
#import "STPickerDate.h"
#import "WalletDetailCollectionCell.h"


@interface WalletDetaileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *collecData;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSString *time;//时间区间
@property (nonatomic, strong) NSString *time_type;//时间区间类别
@property (nonatomic, strong) NSString *desc;//交易类别



@end

@implementation WalletDetaileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.collecData = @[@"全部",@"发单",@"完成订单",@"取消订单",@"撤消发单",@"购买备件",@"取消商城订单",@"退货",@"充值",@"提现",@"置顶",@"补单",@"调价"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WalletDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"WalletDetailCollectionCell"];
    
    self.navigationItem.title = @"账户余额明细";
    
//    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"收益明细" target:self action:@selector(shouyiItemAction:)];


      [_tableView registerNib:[UINib nibWithNibName:@"WalletDetaileCell" bundle:nil] forCellReuseIdentifier:@"WalletDetaileCell"];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    self.time = @"0";
    self.time_type = @"0";
    self.desc = @"0";
    [self loadShopOrderListWithPage:1 hud:YES];
    
    [self addRefreshView];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)shouyiItemAction:(UIBarButtonItem *)item{

    ShouyiJiluViewController * vc = [[ShouyiJiluViewController alloc] initWithNibName:@"ShouyiJiluViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    params[@"type"] = @"1";//  	【1，钱包余额明细】【2，众筹余额明细】【不传为显示所有】
     params[@"curpage"] = @(page);
    
    //时间区间
    params[@"time"] = self.time;
    //时间区间类别
    params[@"time_type"] = self.time_type;
    //交易类别
    params[@"desc"] = self.desc;
    
    
    hud?[self showLoading]:@"";
    
    [MCNetTool postWithUrl:HttpMeShowBalanceDetail params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        
        hud?[self dismissLoading]:@"";
        
        NSArray * array = [WalletDetaileModel mj_objectArrayWithKeyValuesArray:requestDic];
        
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
    WalletDetaileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WalletDetaileCell"];
    WalletDetaileModel * walletDetaileModel = _dataArray[indexPath.row];
    cell.titleLab.text = walletDetaileModel.title;
    cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:walletDetaileModel.time];
    cell.priceLab.text = walletDetaileModel.price;
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


#pragma mark - 筛选


- (IBAction)timeAction {
    if (!self.collectionView.hidden){
        self.collectionView.hidden = YES;
    }
    STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:3];
    pickerDate.pickerDateAndRowBlock = ^(NSInteger year,NSInteger month,NSInteger day,NSInteger row,NSString * time){
        
        NSString *yearStr =[NSString stringWithFormat:@"%ld",year];
        
        NSString *monthStr =[NSString stringWithFormat:@"%ld.%ld",year,month];
        
        NSString *dayStr =[NSString stringWithFormat:@"%ld.%ld.%ld",year,month,day];
        
        NSString *timeStr = @"";
        if (row == 1){
            timeStr = [Utool timestampForDateFromString:yearStr withFormat:@"yyyy"];
        }else if (row == 2){
            timeStr = [Utool timestampForDateFromString:monthStr withFormat:@"yyyy.MM"];
        }else if (row == 3){
            timeStr = [Utool timestampForDateFromString:dayStr withFormat:@"yyyy.MM.dd"];
        }
        
        self.time = timeStr;
        self.time_type = [NSString stringWithFormat:@"%ld",(long)row];
        
        [self loadShopOrderListWithPage:1 hud:NO];
    };
    [pickerDate showWithBtnArray:@[@"按照年",@"按照月",@"按照日"]];
}



- (IBAction)typeAction {
    if (!self.collectionView.hidden){
        //取消交易筛选条件
        self.desc = @"0";
        [self loadShopOrderListWithPage:1 hud:NO];
    }
    self.collectionView.hidden = !self.collectionView.hidden;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collecData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"WalletDetailCollectionCell";
    WalletDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.nameLbl.text = self.collecData[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat W = 0;
    if(kScreenWidth < 375){
        W = (kScreenWidth - 20)/3;
    }else if (kScreenWidth > 375){
        W = (kScreenWidth - 30)/5;
    }else{
        W = (kScreenWidth - 25)/4;
    }
    CGSize size = CGSizeMake(W, 30);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DeLog(@"%@",self.collecData[indexPath.row]);
    DeLog(@"%ld",(long)indexPath.row);
    
    self.desc = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self loadShopOrderListWithPage:1 hud:NO];
    
    self.collectionView.hidden = YES;
}
@end
