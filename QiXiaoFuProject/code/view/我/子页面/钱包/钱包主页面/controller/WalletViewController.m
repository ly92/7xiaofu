//
//  WalletViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletHeaderView.h"
#import "WalletDetaileViewController.h"
#import "RechargeWithdrawViewController.h"

@interface WalletViewController (){

    NSString * _available_predeposit;// 钱包余额
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WalletHeaderView *walletHeaderView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"钱包";
 
    
    UIView * hearderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 154)];
    hearderView.backgroundColor = [UIColor redColor];
      WalletHeaderView * headerView = [WalletHeaderView walletHeaderView];
      headerView.frame = CGRectMake(0, 0, kScreenWidth, 154);
     [hearderView  addSubview:headerView];
    _tableView.tableHeaderView =hearderView;
    _walletHeaderView = headerView;
    
    [headerView.mingxiBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
 
         WalletDetaileViewController * vc = [[WalletDetaileViewController alloc]initWithNibName:@"WalletDetaileViewController" bundle:nil];
         [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [headerView.tixianBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        //提现
        RechargeWithdrawViewController * vc = [[RechargeWithdrawViewController alloc]initWithNibName:@"RechargeWithdrawViewController" bundle:nil];
        vc.vcType = 2;
        vc.available_predeposit = _available_predeposit;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [headerView.chongzhiBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        //充值
        RechargeWithdrawViewController * vc = [[RechargeWithdrawViewController alloc]initWithNibName:@"RechargeWithdrawViewController" bundle:nil];
        vc.vcType = 1;
          [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    
    
    
  


    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    
    [MCNetTool postWithUrl:HttpMeShowBalance params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        // 钱包
        if ([requestDic.allKeys containsObject:@"available_predeposit"]){
            _available_predeposit = [requestDic objectForKey:@"available_predeposit"];
            
        }else{
            _available_predeposit = @"0";
        }
        _walletHeaderView.moneyLab.text =[NSString stringWithFormat:@"¥%@",_available_predeposit];
        
        //  众筹   requestDic[@"zc_price"]
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        
        
    }];

}





#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     [<#tableView#> registerNib:[UINib nibWithNibName:@"<#cellNibName#>" bundle:nil] forCellReuseIdentifier:@"<#cellIdentifier#>"];
     [<#tableView#> registerClass:[UITableViewCell class] forCellReuseIdentifier:@"<#cellIdentifier#>"];
     */
    
    /*
     UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"<#cellIdentifier#>"];
     */
    
    /*
     <#ClassCell#> *cell =[tableView dequeueReusableCellWithIdentifier:@"<#ClassCellIdentifier#>"];
     */
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
