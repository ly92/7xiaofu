//
//  EnrollEngineerListViewController.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/17.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "EnrollEngineerListViewController.h"
#import "EnrollEngineerCell.h"
#import "AssociationModel.h"
#import "BlockUIAlertView.h"
#import "EngineerDetaileViewController.h"


@interface EnrollEngineerListViewController ()

@property (nonatomic, strong) NSMutableArray *engineerArray;

@property (nonatomic, copy) NSString *selectedId;
@end

@implementation EnrollEngineerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"报名列表";
    self.tableView.backgroundColor = rgb(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EnrollEngineerCell" bundle:nil] forCellReuseIdentifier:@"EnrollEngineerCell"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(sureAction)];
    self.selectedId = @"0";
    
    [self loaddata];
}

- (void)sureAction{
    
    if ([self.selectedId isEqualToString:@"0"]){
        [self showErrorText:@"请选择工程师！"];
        return;
    }
    [self showLoading];
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"bill_id"] = self.billId;
    params[@"ot_user_id"] = self.selectedId;
    [MCNetTool postWithUrl:@"tp.php/Home/Member/makeBill?" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self showSuccessText:@"操作成功！"];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
}

- (NSMutableArray *)engineerArray{
    if(!_engineerArray){
        _engineerArray = [NSMutableArray array];
    }
    return _engineerArray;
}


- (void)loaddata{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"bill_id"] = self.billId;
    [self showLoading];
    [self.engineerArray removeAllObjects];
    [MCNetTool postWithUrl:HttpMainEnrollEngineerList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        NSArray * array = [EnrollEnigeer mj_objectArrayWithKeyValuesArray:requestDic];
        [self.engineerArray setArray:array];
        [self dismissLoading];
        
        [self.tableView reloadData];
    } fail:^(NSString *error) {
        [self dismissLoading];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.engineerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnrollEngineerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnrollEngineerCell" forIndexPath:indexPath];
    
    if (self.engineerArray.count > indexPath.row){
        EnrollEnigeer *model = self.engineerArray[indexPath.row];
        [cell.iconImgV setImageWithUrl:model.ot_user_avatar placeholder:kDefaultImage_header];
        cell.nameLbl.text = model.ot_user_name;
        
        if ([model.ot_user_id isEqualToString:self.selectedId]){
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
        
        cell.selectedEngineerBlock = ^{
            
            self.selectedId = model.ot_user_id;
            [self.tableView reloadData];
            
//            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"指定工程师:%@ 接单？",model.ot_user_name] cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
//                if(buttonIndex == 1){
//                                    }
//            } otherButtonTitles:@"确定"];
//            [alert show];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.engineerArray.count > indexPath.row){
        EnrollEnigeer *model = self.engineerArray[indexPath.row];
        // 工程师详情
        EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
        vc.member_id = model.ot_user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
