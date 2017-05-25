//
//  AssociationViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AssociationViewController.h"
#import "AssociationCell.h"
#import "AssociationModel.h"
#import "EngineerDetaileViewController.h"

@interface AssociationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AssociationModel * associationModel;


@end

@implementation AssociationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关联用户";
    [_tableView registerNib:[UINib nibWithNibName:@"AssociationCell" bundle:nil] forCellReuseIdentifier:@"AssociationCell"];

    
    [self loadZhanghaoList];

    
    
    [_tableView headerAddMJRefresh:^{
        
        [self loadZhanghaoList];
    }];

    
    // Do any additional setup after loading the view from its nib.
}


- (void)loadZhanghaoList{


    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    [MCNetTool postWithUrl:HttpMeMyUniAcc params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _associationModel = [AssociationModel mj_objectWithKeyValues:requestDic];
        [_tableView reloadData];
        
        [_tableView headerEndRefresh];

        
    } fail:^(NSString *error) {
       
        [self showErrorText:error];

        [_tableView headerEndRefresh];

    }];


}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section ==0)return _associationModel.user_to_me?1:0;
    return _associationModel.me_to_user.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AssociationCell *cell =[tableView dequeueReusableCellWithIdentifier:@"AssociationCell"];
    
    if (indexPath.section==0) {
        cell.user_to_me= _associationModel.user_to_me;
    }else{
        Me_To_User * me_to_user = _associationModel.me_to_user[indexPath.row];
         cell.me_to_user= me_to_user;
     }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * member_id;
    
    if (indexPath.section==0) {
        
        member_id = _associationModel.user_to_me.member_id;
    }else{
        Me_To_User * me_to_user = _associationModel.me_to_user[indexPath.row];
        member_id = me_to_user.member_id;
    }
    // 工程师详情
    EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
    vc.member_id = member_id;
    [self.navigationController pushViewController:vc animated:YES];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,40)];
    if(section == 0){
        if (_associationModel.user_to_me) {
            lab.text =  @"    邀请我的";
        }
     }
    if(section == 1){
        lab.text =  @"    我邀请的";
     }
    return lab;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _associationModel.user_to_me?40.0f:0.001f;
    }
    return 40;
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
