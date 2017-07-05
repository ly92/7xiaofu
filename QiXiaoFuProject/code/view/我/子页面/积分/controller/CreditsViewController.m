//
//  CreditsViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/1.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "CreditsViewController.h"
#import "CreditsTableViewCell.h"
#import "CreditsModel.h"


@interface CreditsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *reditsLbl;

@property (nonatomic, strong) CreditsModel *creditsModel;

@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, assign) NSInteger page;
@end

@implementation CreditsViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的积分";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CreditsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CreditsTableViewCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    [_tableView headerAddMJRefresh:^{
        [self loadReditsListPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadReditsListPage:_page hud:NO];
    }];
    
    [self loadReditsListPage:1 hud:YES];

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
        
        if (self.creditsModel.list.count < 10){
            [_tableView hidenFooter];
        }
        
        [self.dataArray addObjectsFromArray:self.creditsModel.list];
        
        [_tableView reloadData];
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
    } fail:^(NSString *error) {
        if (hud){
            [self dismissLoading];
        }
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
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
            cell.amountLbl.text = [NSString stringWithFormat:@"%@积分",credits.integral];
            cell.amountLbl.textColor = [UIColor greenColor];
        }else if ([credits.integral hasPrefix:@"+"]){
            cell.amountLbl.textColor = [UIColor redColor];
            cell.amountLbl.text = [NSString stringWithFormat:@"%@积分",credits.integral];
        }else{
            if ([credits.integral intValue] > 0){
                cell.amountLbl.textColor = [UIColor redColor];
                cell.amountLbl.text = [NSString stringWithFormat:@"+%@积分",credits.integral];
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
