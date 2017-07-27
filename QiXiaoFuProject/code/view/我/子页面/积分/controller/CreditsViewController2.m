//
//  CreditsViewController2.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/7/27.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "CreditsViewController2.h"
#import "CreditsTableViewCell.h"
#import "CreditsModel.h"


@interface CreditsViewController2 ()

@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *reditsLbl;
@property (weak, nonatomic) IBOutlet UIView *ruleView;
@property (weak, nonatomic) IBOutlet UIView *subRuleView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *expendBtn;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftDis;




@property (nonatomic, strong) CreditsModel *creditsModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation CreditsViewController2
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.topImgV stopAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subRuleView.layer.cornerRadius = 5;
    
    NSMutableArray *imgsArray = [NSMutableArray array];
    for (int i = 10; i > 0; i --) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Integral_background_%d",i]];
        [imgsArray addObject:img];
    }
    self.topImgV.animationImages = imgsArray;
    self.topImgV.animationDuration = 1;
    [self.topImgV startAnimating];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CreditsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreditsTableViewCell"];

    [self.tableView headerAddMJRefresh:^{
        [self loadReditsListPage:1 hud:NO];
    }];
    [self.tableView footerAddMJRefresh:^{
        [self loadReditsListPage:_page hud:NO];
    }];
    
    [self loadReditsListPage:1 hud:YES];
 
    [self.ruleView addTapAction:@selector(showRuleAction) forTarget:self];
}

- (IBAction)showRuleAction {
    self.ruleView.hidden = !self.ruleView.hidden;
}
- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)categoryAction:(UIButton *)btn {
    self.allBtn.selected = NO;
    self.expendBtn.selected = NO;
    self.incomeBtn.selected = NO;
    btn.selected = YES;
    self.lineLeftDis.constant = btn.tag * kScreenWidth / 3.0;
    if (!self.allBtn.selected){
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.dataArray empty:EmptyDataTableViewDefault withScrollView:self.tableView];
        [self.tableView hidenFooter];
    }else{
        [self loadReditsListPage:1 hud:YES];
    }
}

- (void)loadReditsListPage:(NSInteger)page hud:(BOOL)hud{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"member_id"] = kUserId;
    params[@"curpage"] = @(page);
    
    if (hud){
        [self showLoading];
    }
    if (page == 1){
        [self.dataArray removeAllObjects];
    }
    
    [MCNetTool postWithUrl:HttpRedits params:params success:^(NSDictionary *requestDic, NSString *msg) {
        if (hud){
            [self dismissLoading];
        }
        _page = page;
        _page ++;
        self.creditsModel = [CreditsModel mj_objectWithKeyValues:requestDic];
        
        self.reditsLbl.text = self.creditsModel.all_integral;
        
        
        [self.dataArray addObjectsFromArray:self.creditsModel.list];
        
        [self.tableView reloadData];
        page==1?[self.tableView headerEndRefresh]:[self.tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.dataArray empty:EmptyDataTableViewDefault withScrollView:self.tableView];
        
        if (self.creditsModel.list.count < 10){
            [self.tableView hidenFooter];
        }

    } fail:^(NSString *error) {
        if (hud){
            [self dismissLoading];
        }
        page==1?[self.tableView headerEndRefresh]:[self.tableView footerEndRefresh];
        [self showErrorText:error];
    }];
}




#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count > 0){
        return self.dataArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CreditsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditsTableViewCell"];
    
    if (self.dataArray.count > indexPath.row){
        CreditsObj *credits = self.dataArray[indexPath.row];
        cell.nameLbl.text = credits.sourceValue;
        
        cell.timeLbl.text = [Utool timeStampPointTimeFormatter:credits.addtime];
        
        if ([credits.integral hasPrefix:@"-"]){
            cell.amountLbl.text = [NSString stringWithFormat:@"%@",credits.integral];
//            cell.amountLbl.textColor = [UIColor greenColor];
        }else if ([credits.integral hasPrefix:@"+"]){
//            cell.amountLbl.textColor = [UIColor redColor];
            cell.amountLbl.text = [NSString stringWithFormat:@"%@",credits.integral];
        }else{
            if ([credits.integral intValue] > 0){
//                cell.amountLbl.textColor = [UIColor redColor];
                cell.amountLbl.text = [NSString stringWithFormat:@"+%@",credits.integral];
            }
        }
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
