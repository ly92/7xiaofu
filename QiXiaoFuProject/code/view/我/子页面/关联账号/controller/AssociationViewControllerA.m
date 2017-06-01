//
//  AssociationViewControllerA.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/5/31.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "AssociationViewControllerA.h"
#import "AssociationCell.h"
#import "AssociationModel.h"
#import "EngineerDetaileViewController.h"
#import "BlockUIAlertView.h"

@interface AssociationViewControllerA ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AssociationModel * associationModel;

@property (nonatomic, strong) NSMutableArray *bDataArray;
@property (nonatomic, strong) NSMutableArray *cDataArray;

@property (nonatomic, assign) NSInteger selectedSection;


@end

@implementation AssociationViewControllerA

- (NSMutableArray *)bDataArray{
    if (!_bDataArray){
        _bDataArray = [NSMutableArray array];
    }
    return _bDataArray;
}
- (NSMutableArray *)cDataArray{
    if (!_cDataArray){
        _cDataArray = [NSMutableArray array];
    }
    return _cDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关联用户";
    [_tableView registerNib:[UINib nibWithNibName:@"AssociationCell" bundle:nil] forCellReuseIdentifier:@"AssociationCell"];

    self.selectedSection = -1;
    
    [self loadZhanghaoList];
    
    [_tableView headerAddMJRefresh:^{
        
        [self loadZhanghaoList];
    }];
    
}


- (void)loadZhanghaoList{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    [MCNetTool postWithUrl:HttpMeMyUniAcc1 params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _associationModel = [AssociationModel mj_objectWithKeyValues:requestDic];
        
//        NSMutableArray *tempArray = [NSMutableArray array];
//        for (Me_To_User *model in _associationModel.me_to_user) {
//            if ([model.jibie isEqualToString:@"B"]){
//                [self.bDataArray addObject:model];
//            }else{
//                [tempArray addObject:model];
//            }
//        }
//        [self.cDataArray addObject:tempArray];
        
        [_tableView reloadData];
        
        [_tableView headerEndRefresh];
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        
        [_tableView headerEndRefresh];
        
    }];
    
    
}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.associationModel.me_to_user yw_notNull]){
        return self.associationModel.me_to_user.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.selectedSection && self.associationModel.me_to_user.count > section){
        Me_To_User *me_touser = self.associationModel.me_to_user[section];
        return me_touser.zi.count + 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AssociationCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AssociationCell"];
    
    if (indexPath.row == 0){
        Me_To_User *me_touser = self.associationModel.me_to_user[indexPath.section];
        cell.me_to_user = me_touser;
        cell.iconLeftDis.constant = 10;
        cell.btnW.constant = 30;
        cell.openBtn.hidden = NO;
        cell.openBlock = ^{
          //展开C级
            if (self.selectedSection == indexPath.section){
                self.selectedSection = -1;
            }else{
                self.selectedSection = indexPath.section;
            }
            [self.tableView reloadData];
        };
    }else{
        Me_To_User *me_touser = self.associationModel.me_to_user[indexPath.section];
        if (me_touser.zi.count > indexPath.row - 1){
            AZi *azi = me_touser.zi[indexPath.row - 1];
            cell.azi = azi;
            cell.iconLeftDis.constant = 30;
            cell.btnW.constant = 0;
            cell.openBtn.hidden = YES;
        }
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * member_id;
    NSString *move_to_eng_name;
    
    
    if (indexPath.row==0) {
        if (_associationModel.me_to_user.count > indexPath.section){
            Me_To_User * me_to_user = _associationModel.me_to_user[indexPath.section];
            member_id = me_to_user.member_id;
            move_to_eng_name = me_to_user.member_name;
        }
    }else{
        Me_To_User *me_touser = self.associationModel.me_to_user[indexPath.section];
        if (me_touser.zi.count > indexPath.row - 1){
            AZi *azi = me_touser.zi[indexPath.row - 1];
            member_id = azi.member_id;
            move_to_eng_name = azi.member_name;
        }
    }
    
    if (self.isFromTrans){
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定将订单转移到:%@",move_to_eng_name] cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"move_to_eng_id"] = member_id;//接受者的id
                params[@"id"] = self.orderId;//订单id
                params[@"move_to_eng_name"] = move_to_eng_name;//接受者的昵称
                
                [MCNetTool postWithUrl:HttpTransferStartMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    //转移成功后的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRANSFERSUCCESS" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [self showSuccessText:msg];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
            
        } otherButtonTitles:@"确定"];
        [alert show];
    }else{
        
        // 工程师详情
        EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
        vc.member_id = member_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,40)];
    if(section == 0){
        lab.text =  @"    我邀请的";
    }
    return lab;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40.0;
    }
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
