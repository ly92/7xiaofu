
//
//  SystemMessageViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SyetemMessageRemindCell.h"
#import "SyetemMessageCell.h"
#import "SysTemMessageModel.h"
#import "ProductDetaileViewController.h"
#import "WalletViewController.h"
#import "BlockUIAlertView.h"
#import "OrderDetailViewController.h"
#import "CertificationViewController.h"
#import "OrderDetailViewController.h"
#import "MySendOrderDetaileViewController.h"
#import "OrderDetaileViewController.h"


@interface SystemMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dealArray;

@property (assign, nonatomic)  NSInteger page;
@property (weak, nonatomic) IBOutlet UIView *dealBtnView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealBtnViewH;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.systemMessageType == SystemMessageTypeMoney){
        self.navigationItem.title = @"资金消息";
    }else if (self.systemMessageType == SystemMessageTypeSendReceiveMoney){
        self.navigationItem.title = @"接发单消息";
    }else{
        self.navigationItem.title = @"系统消息";
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"编辑" target:self action:@selector(dealMessageAction)];
    
    _dataArray = [NSMutableArray new];
    _page = 1;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    [_tableView registerNib:[UINib nibWithNibName:@"SyetemMessageRemindCell" bundle:nil] forCellReuseIdentifier:@"SyetemMessageRemindCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SyetemMessageCell" bundle:nil] forCellReuseIdentifier:@"SyetemMessageCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    // Do any additional setup after loading the view from its nib.
    
    
    [self loadSystemMessageWithRefreshPage:1];
    
    
    [_tableView headerAddMJRefresh:^{
        [self loadSystemMessageWithRefreshPage:1];
        
    }];
    [_tableView footerAddMJRefresh:^{
        [self loadSystemMessageWithRefreshPage:_page];
    }];
    
}

- (NSMutableArray *)dealArray{
    if (!_dealArray){
        _dealArray = [NSMutableArray array];
    }
    return _dealArray;
}

//处理信息
- (void)dealMessageAction{
    if (self.dealBtnViewH.constant == 0){
        self.dealBtnViewH.constant = 50;
        self.dealBtnView.hidden = NO;
    }else{
        self.dealBtnViewH.constant = 0;
        self.dealBtnView.hidden = YES;
    }
    [self.dealArray removeAllObjects];
    
    [self.tableView reloadData];
    if (self.dataArray.count < 10) {
        [_tableView hidenFooter];
    }
}

- (void)loadSystemMessageWithRefreshPage:(NSInteger )page{
    self.dealBtnViewH.constant = 0;
    self.dealBtnView.hidden = YES;
    [self.dealArray removeAllObjects];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"curpage"] = @(page);
    params[@"op"] = @"message_list";
    params[@"act"] = @"member_index";
    params[@"message_type"] = @(self.systemMessageType);
    
    [MCNetTool postWithCachePageUrl:HttpApi params:params success:^(NSDictionary *requestDic, NSString *msg, BOOL hasmore, NSInteger page_total) {
        
        _page = page;
        _page ++;
        
        NSMutableArray *mutableArr=[NSMutableArray array];
        for (NSDictionary *systemMessageDict in requestDic) {
            SysTemMessageModel *systemMessageModel = [SysTemMessageModel mj_objectWithKeyValues:systemMessageDict];
            if ([systemMessageModel.message_id yw_notNull]) {
                [mutableArr addObject:systemMessageModel];
            }
        }
        
        NSArray * array = [SysTemMessageModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:mutableArr]:[_dataArray addObjectsFromArray:mutableArr];
        
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
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SysTemMessageModel * messageModel = _dataArray[indexPath.section];
    
    //    if (messageModel.jump_type ==72) {
    //
    //        SyetemMessageRemindCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SyetemMessageRemindCell"];
    //        cell.messageModel =messageModel;
    //        cell.indexPath = indexPath;
    //        [cell.acceptBtn  tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
    //
    //
    //            SysTemMessageModel * message = _dataArray[btn.tag];
    //
    //            NSMutableDictionary * params = [NSMutableDictionary new];
    //            params[@"userid"] = kUserId;
    //            params[@"id"] = message.jump_id;
    //
    //            [MCNetTool postWithUrl:HttpMainTakeBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
    //
    //                NSInteger state = [requestDic[@"state"] integerValue];
    //                 NSString * pro_id = requestDic[@"bill_id"];
    //
    //                // 【1】 接单成功 【2 项目已被抢走】【3 不能接自己发布的项目】【4 没有进行实名认证】【5 订单生成失败，后台逻辑错误】
    //
    //                if ( state == 1) {
    //
    //                    [self receivingOrderSucc:pro_id];
    //
    //                }else if (state ==2){
    //
    //                    [self receivingOrderFailure];
    //
    //                }else if (state ==3){
    //
    //                    [self showErrorText:@"不能接自己发布的项目"];
    //
    //                }else if (state ==4){
    //
    //                    [self goCertification];
    //
    //                }else if (state ==5){
    //                    [self showErrorText:@"订单生成失败，后台逻辑错误"];
    //                }
    //
    //
    //                [self loadSystemMessageWithRefreshPage:1];
    //
    //
    //
    //            } fail:^(NSString *error) {
    //                [self showErrorText:error];
    //            }];
    //
    //        }];
    //
    //        [cell.ignoreBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
    //
    //
    //            SysTemMessageModel * message = _dataArray[btn.tag];
    //
    //            NSMutableDictionary * params = [NSMutableDictionary new];
    //            params[@"userid"] = kUserId;
    //            params[@"store_id"] = @"1";
    //            params[@"message_id"] = message.message_id;
    //
    //            [MCNetTool postWithUrl:HttpMessageDetaile params:params success:^(NSDictionary *requestDic, NSString *msg) {
    //
    //                [self loadSystemMessageWithRefreshPage:1];
    //
    //            } fail:^(NSString *error) {
    //
    //            }];
    //
    //        }];
    //
    //        return cell;
    //
    //    }else{
    
    SyetemMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SyetemMessageCell"];
    cell.messageModel =messageModel;
    
    if (self.dealBtnView.hidden){
        cell.selectedImgV.hidden = YES;
    }else{
        cell.selectedImgV.hidden = NO;
        if ([self.dealArray containsObject:@(indexPath.section)]){
            cell.selectedImgV.image = [UIImage imageNamed:@"btn_checkbox_s"];
        }else{
            cell.selectedImgV.image = [UIImage imageNamed:@"btn_checkbox_n"];
        }
        
    }
    return cell;
    
    //    }
    //    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dealBtnView.hidden){
        //资金消息不进入详情页
        if (self.systemMessageType == SystemMessageTypeMoney){
            return;
        }
        
        SysTemMessageModel * messageModel = _dataArray[indexPath.section];
        
        // 【71：项目详情】【72：接单详情】【73：发单详情】【74：跳转到钱包详情里，此时jump_id为空】【75：众筹详情】
        
        if (messageModel.jump_type ==71) {
            // 项目详情
            ProductDetaileViewController * vc  = [[ProductDetaileViewController alloc]initWithNibName:@"ProductDetaileViewController" bundle:nil];
            vc.p_id =messageModel.jump_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (messageModel.jump_type ==72) {
            OrderDetailViewController * vc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
            vc.pro_id = messageModel.jump_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (messageModel.jump_type ==73) {
            MySendOrderDetaileViewController * vc = [[MySendOrderDetaileViewController alloc]initWithNibName:@"MySendOrderDetaileViewController" bundle:nil];
            vc.pro_id = messageModel.jump_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if (messageModel.jump_type ==74) {
            WalletViewController * vc = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if (messageModel.jump_type ==76) {
            OrderDetaileViewController * vc = [[OrderDetaileViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
            vc.order_id = messageModel.jump_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if(messageModel.message_open == 0){
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"message_id"] = messageModel.message_id;
            
            [MCNetTool postWithUrl:HttpMessageDetaile params:params success:^(NSDictionary *requestDic, NSString *msg) {
                
                
                messageModel.message_open = 1;
                
                if (messageModel.jump_type ==72) {
                    
                    SyetemMessageRemindCell *cell =[tableView cellForRowAtIndexPath:indexPath];
                    cell.messageModel =messageModel;
                    
                }else{
                    
                    SyetemMessageCell *cell =[tableView cellForRowAtIndexPath:indexPath];
                    cell.messageModel =messageModel;
                }
                
            } fail:^(NSString *error) {
                
            }];
            
        }
    }else{
        if ([self.dealArray containsObject:@(indexPath.section)]){
            [self.dealArray removeObject:@(indexPath.section)];
        }else{
            [self.dealArray addObject:@(indexPath.section)];
        }
        
        [self.tableView reloadData];
        if (self.dataArray.count < 10) {
            [_tableView hidenFooter];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}




#pragma mark - 接单成功
- (void)receivingOrderSucc:(NSString *)pro_id{
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"接单成功" message:@"\n恭喜你接单成功,现在要去查看订单吗?\n" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            
            OrderDetailViewController * vc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
            vc.pro_id =pro_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            [self .navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } otherButtonTitles:@"查看"];
    [alert show];
    
    
}
#pragma mark - 接单失败
- (void)receivingOrderFailure{
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"接单失败" message:@"\n不好意思,订单被别人抢走了,再去转转吧\n" cancelButtonTitle:nil clickButton:^(NSInteger buttonIndex) {
        
    } otherButtonTitles:@"我知道了"];
    [alert show];
    
}

- (void)goCertification{
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您尚未进行实名认证,认证之后才能接单,要立即去认证吗?" cancelButtonTitle:@"先等等" clickButton:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){
            CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } otherButtonTitles:@"去认证"];
    [alert show];
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

#pragma mark - 处理信息请求
- (IBAction)dealBtnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 11:{
            //已读
            [self dealMessageNetWithOPType:@"take_message"];
        }
            break;
        case 22:{
            //删除
            [self dealMessageNetWithOPType:@"del_message"];
        }
            break;
        case 33:{
            //取消
            [self dealMessageAction];
        }
            break;
            
        default:
            break;
    }
}


- (void)dealMessageNetWithOPType:(NSString *)op{
    
    if (self.dealArray.count == 0){
        [self showErrorText:@"请至少选择一条"];
        return;
    }
    
    NSMutableArray *message_arr = [NSMutableArray array];
    for (NSNumber *num in self.dealArray) {
        NSInteger index = [num integerValue];
        if (self.dataArray.count > index){
            SysTemMessageModel * messageModel = self.dataArray[index];
            [message_arr addObject:messageModel.message_id];
        }
    }
    NSString *message_ids = [message_arr componentsJoinedByString:@","];
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"op"] = op;
    params[@"act"] = @"member_index";
    params[@"message_id"] = message_ids;
    
    [MCNetTool postWithUrl:HttpApi params:params success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:@"处理成功！"];
            [self loadSystemMessageWithRefreshPage:1];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
}


@end
