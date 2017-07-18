//
//  MessageViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//  消息主页面

#import "MessageViewController.h"
#import "MessageCell.h"
#import "SystemMessageViewController.h"
#import "ConversationListController.h"


@interface MessageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSString * message_count;//未读消息数量

@property (strong, nonatomic) NSMutableArray * dataArray;



@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];

    
    _tableView.tableFooterView = [UIView new];
    
    _dataArray = [NSMutableArray new];
    
    

//
//    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:@"8001" conversationType:eConversationTypeChat];
//    
    
    
    [self loadNoReadCount];
    
    
    [self addMessageRefreshView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)addMessageRefreshView{
    
    
    [_tableView headerAddMJRefresh:^{
        
        
    }];
    [_tableView footerAddMJRefresh:^{
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


}


#pragma mark - 获取未读消息数目

- (void)loadNoReadCount{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
 
    
    [MCNetTool postWithUrl:HttpMessageReadCount params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _message_count =requestDic[@"message_count"];
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
    
}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
        if (indexPath.row == 0){
            cell.iconImageView.image = [UIImage imageNamed:@"img_systemnesw"];
        }else if (indexPath.row == 1){
            cell.iconImageView.image = [UIImage imageNamed:@"wallet_message"];
        }else{
            cell.iconImageView.image = [UIImage imageNamed:@"task_message"];
        }
        if ([_message_count integerValue] ==0) {
            cell.countLab.hidden = YES;
        }else{
            cell.countLab.hidden = NO;
            cell.countLab.text = _message_count;
        }
        return cell;

    }else if (indexPath.section == 1){
        MessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
        
        EMConversation * eMConversation = _dataArray[indexPath.row];
        
        
        LxDBAnyVar(eMConversation.ext);
        
    
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
//        SystemMessageViewController * vc = [[SystemMessageViewController alloc]initWithNibName:@"SystemMessageViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
//        
        
        ConversationListController * vc = [[ConversationListController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
    }
    return 0.00000001f;
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
