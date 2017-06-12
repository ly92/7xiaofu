//
//  EngineerDistributedViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDistributedViewController.h"
#import "EngineerDistributedCell.h"
#import "EngineerDistributedModel.h"
#import "ChatViewController.h"


#import "EngineerDistributedMapViewController.h"


@interface EngineerDistributedViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EngineerDistributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemCancleWithTitle:@"地图" target:self action:@selector(mapItemAction:)];
    
    
    _dataArray = [NSMutableArray new];
    [_tableView setSeparatorColor:kHexColor(E0E0E0)];
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerDistributedCell" bundle:nil] forCellReuseIdentifier:@"EngineerDistributedCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"goods_id"] = _goods_id;
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"area_id"] = _area_id;

    [MCNetTool postWithCacheUrl:HttpShopEngStorageList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _dataArray = [EngineerDistributedModel mj_objectArrayWithKeyValuesArray:requestDic];
        [_tableView reloadData];
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)mapItemAction:(UIBarButtonItem *)item{
    
    
    EngineerDistributedMapViewController * vc= [[EngineerDistributedMapViewController alloc] initWithNibName:@"EngineerDistributedMapViewController" bundle:nil];
    
    vc.mapItemArray = _dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EngineerDistributedCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EngineerDistributedCell"];
    EngineerDistributedModel * engineerDistributedModel = _dataArray[indexPath.row];
    [cell.iconImageView setImageWithUrl:engineerDistributedModel.member_avatar placeholder:kDefaultImage_header];
    cell.nameLab.text = engineerDistributedModel.call_nik_name;
    cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:engineerDistributedModel.time];
    cell.numLab.text = [NSString stringWithFormat:@"购买数量:%@",engineerDistributedModel.count];
    cell.chatBtn.tag = indexPath.row;
    [cell.chatBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        
        [self goChatWithtag:btn.tag];
        
    }];
    
    if (engineerDistributedModel.os ==1) {
        cell.chatBtn.selected = YES;
    }else{
        cell.chatBtn.selected = NO;
    }
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    


}

- (void)goChatWithtag:(NSInteger )tag{

    
    [Utool verifyLogin:self LogonBlock:^{
        
        
        
        
        
        
        
        
        
        
        
        EngineerDistributedModel * engineerDistributedModel = _dataArray[tag];
        if([engineerDistributedModel.call_name isEqualToString:kPhone]){
            return;
        }
        
        ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:engineerDistributedModel.call_name
                                                                                       friendUsername:engineerDistributedModel.member_truename
                                                                                       friendUserIcon:engineerDistributedModel.duifangtouxiang
                                                                                                 user:engineerDistributedModel.call_name
                                                                                             userName:kUserName
                                                                                             userIcon:kUserIcon];
        
        chatController.title = engineerDistributedModel.member_truename;
        chatController.friendIcon = engineerDistributedModel.duifangtouxiang;
        chatController.userIcon = kUserIcon;
        [self.navigationController pushViewController:chatController animated:YES];
        
    }];
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
