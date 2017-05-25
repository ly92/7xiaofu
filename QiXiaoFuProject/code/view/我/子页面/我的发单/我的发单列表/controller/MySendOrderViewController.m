//
//  MySendOrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MySendOrderViewController.h"
#import "MySendOrderCell.h"
#import "MySendOrderDetaileViewController.h"
#import "MySendOrderModel.h"
#import "BlockUIAlertView.h"
#import "ChongSendOrderVC1.h"
#import "JieFanDanZaiCiPayViewController.h"
#import "CommentViewController.h"
#import "ChatViewController.h"
#import "SendOrderViewController.h"
#import "CertificationViewController.h"

@interface MySendOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MySendOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的发单";
    
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"发单" target:self action:@selector(rightFaItemAction:)];

    _page = 1;
    _dataArray = [NSMutableArray new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MySendOrderCell" bundle:nil] forCellReuseIdentifier:@"MySendOrderCell"];
    _tableView.tableFooterView = [UIView new];
    

    [self addRefreshView];
    // Do any additional setup after loading the view from its nib.
}






- (void)rightFaItemAction:(UIBarButtonItem *)item{
    
    [Utool verifyLoginAndCertification:self LogonBlock:^{
        
        SendOrderViewController * vc = [[SendOrderViewController alloc]initWithNibName:@"SendOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    } CertificationBlock:^{
        
        CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
}


- (void)addRefreshView{
    
    [_tableView headerAddMJRefresh:^{
        [self myBillListDataPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self myBillListDataPage:_page hud:NO];

    }];

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self myBillListDataPage:1 hud:YES];


}


- (void)myBillListDataPage:(NSInteger )page hud:(BOOL )hud{


    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    //params[@"pay_statu"] = _bill_statu;// 支付状态【0 待支付】【1 已支付】
    params[@"bill_statu"] = @(self.sendOrderStatus ? :SendOrderStatusUnReceive);//发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】
    hud?[self showLoading]:@"";

    [MCNetTool postWithUrl:HttpMeMyBillList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page ++;
        NSArray * array = [MySendOrderModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
        [_tableView reloadData];
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];

        hud?[self dismissLoading]:@"";
        
    } fail:^(NSString *error) {
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        
        hud?[self dismissLoading]:@"";
//        [self showErrorText:error];
//
//        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        [YWNoNetworkView showNoNetworkInView:self.view reloadBlock:^{
            [self myBillListDataPage:_page hud: _page > 1 ? NO :YES ];
        }];

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
  
    MySendOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MySendOrderCell"];
    cell.indexPath = indexPath;
    MySendOrderModel * mySendOrderModel = _dataArray[indexPath.section];
    cell.mySendOrderModel = mySendOrderModel;
    
    // 客户取消发单
    cell.mySendOrderCellWithBtnState_cancle =^(MySendOrderModel * sendOrderModel){
        
        [self sendOrder_cancleOrder_withModel:sendOrderModel];
        
        [self deleateChatlistWithUserPhone:sendOrderModel.call_name];

    };
    
  
    // 撤回
    cell.mySendOrderCellWithBtnState_CheHui =^(MySendOrderModel * sendOrderModel){
        
        [self sendOrder_CheXiaoOrder_withModel:sendOrderModel];
        
    };
    // 重新发布
    cell.mySendOrderCellWithBtnState_ChongXinFaBu =^(MySendOrderModel * sendOrderModel){
        
        
        ChongSendOrderVC1 * vc = [[ChongSendOrderVC1 alloc]initWithNibName:@"ChongSendOrderVC1" bundle:nil];
        vc.f_id = sendOrderModel.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    // 取消订单
    cell.mySendOrderCellWithBtnState_QuXiaoDingDan =^(MySendOrderModel * sendOrderModel){
        
        
        
        if(sendOrderModel.bill_statu == 2 || sendOrderModel.bill_statu == 3 || sendOrderModel.bill_statu == 6 || sendOrderModel.bill_statu == 7 ){
        
            
            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消订单将扣除服务费用的10%,\n你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
                
                if(buttonIndex == 1){
                    
                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"id"] = sendOrderModel.id;
                    
                    [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        [self showSuccessText:@"订单取消成功"];
                        
                        [self deleateChatlistWithUserPhone:sendOrderModel.call_name];
                        
                        [self myBillListDataPage:1 hud:YES];// 撤销成功刷新列表
                        
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                }
                
            } otherButtonTitles:@"确定取消"];
            [alert show];
        
        }else{
            
            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
                
                if(buttonIndex == 1){
                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"id"] = sendOrderModel.id;
                    [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        [self showSuccessText:@"订单取消成功"];
                        [self myBillListDataPage:1 hud:YES];// 撤销成功刷新列表
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                }
            } otherButtonTitles:@"确定取消"];
            [alert show];
        }
    };
    // 确认完成
    cell.mySendOrderCellWithBtnState_QueRenWanCheng =^(MySendOrderModel * sendOrderModel){
        
        //  客户完成发单  http://139.129.213.138/tp.php/Home/My/comBill/
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = sendOrderModel.id;
        
        [MCNetTool postWithUrl:HttpMeComBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:@"订单已完成"];
            
            // 去评价
            CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
            vc.f_id = sendOrderModel.id;
            vc.commentViewBlock =^(){
                
            };
            
            [self deleateChatlistWithUserPhone:sendOrderModel.call_name];

            
            [self.navigationController pushViewController:vc animated:YES];
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    };
    // 去评价
    cell.mySendOrderCellWithBtnState_Comment =^(MySendOrderModel * sendOrderModel){
        
         [self sendOrder_goComment_withModel:sendOrderModel];

        
    };
    // 删除订单
    cell.mySendOrderCellWithBtnState_Delete =^(MySendOrderModel * sendOrderModel,NSIndexPath * cellIndexPath){
        
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"删除之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = sendOrderModel.id;
                
                [MCNetTool postWithUrl:HttpMeMyBillDel params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"删除成功"];
                    
                    [_dataArray removeObjectAtIndex:cellIndexPath.section];//移除数据源的数据
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:cellIndexPath.section];
                    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];//移除tableView中的section
                    
                    
                    [self deleateChatlistWithUserPhone:sendOrderModel.call_name];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
            
        } otherButtonTitles:@"删除"];
        [alert show];


    };
    // 去支付
    cell.mySendOrderCellWithBtnState_GoPay =^(MySendOrderModel * sendOrderModel){
        
        [self sendOrder_goPay_withModel:sendOrderModel];
    };
    
    cell.orderSendDetaileCancle_WeiWanCheng =^(MySendOrderModel * sendOrderModel){
        
        [self showLoading];
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = sendOrderModel.id;
        
        [MCNetTool postWithUrl:HttpMeNoBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            
            [self showSuccessText:msg];
            
            [self myBillListDataPage:1 hud:YES];//

            
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    };

    
    
    
    cell.mySendOrderCellWithBtnChat =^(MySendOrderModel * sendOrderModel){
        
        
        [self sendOrder_goPChat_withModel:sendOrderModel];

        
    };
    
    return cell;
}


- (void)deleateChatlistWithUserPhone:(NSString *)userPhone{
    if (userPhone.length != 0) {
        [[EMClient sharedClient].chatManager deleteConversation:userPhone deleteMessages:NO];
    }
}



#pragma mark - 去支付
/**
 去支付

  */
- (void)sendOrder_goPay_withModel:(MySendOrderModel * )sendOrderModel{

    JieFanDanZaiCiPayViewController * vc = [[JieFanDanZaiCiPayViewController alloc]initWithNibName:@"JieFanDanZaiCiPayViewController" bundle:nil];
    vc.type = 1;
    vc.f_id = sendOrderModel.id;
    vc.order_price = [sendOrderModel.service_price floatValue];
    vc.jieFanDanZaiCiPayViewBlock =^(){
    
        [self myBillListDataPage:1 hud:YES];

    };
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 去聊天
/**
 去聊天
 */
- (void)sendOrder_goPChat_withModel:(MySendOrderModel * )sendOrderModel{
    
    if([sendOrderModel.call_name isEqualToString:kPhone]){
        return;
    }
    
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:sendOrderModel.call_name
                                                                                   friendUsername:sendOrderModel.call_nik_name
                                                                                   friendUserIcon:sendOrderModel.ot_user_avatar
                                                                                             user:kPhone
                                                                                         userName:kUserName
                                                                                         userIcon:kUserIcon];
    
    chatController.title = sendOrderModel.call_nik_name;
    chatController.friendIcon = sendOrderModel.ot_user_avatar;
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];

    
}
#pragma mark - 去评价
/**
 去评价
 */
- (void)sendOrder_goComment_withModel:(MySendOrderModel * )sendOrderModel{
    
    CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    vc.f_id = sendOrderModel.id;
    vc.commentViewBlock =^(){
    
        [self myBillListDataPage:1 hud:YES];

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 客户取消发单
/**
 客户取消发单
 */
- (void)sendOrder_cancleOrder_withModel:(MySendOrderModel * )sendOrderModel{
    
    //  客户取消发单  http://139.129.213.138/tp.php/Home/My/offBill/
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定要取消此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            
            [self showLoading];

            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"id"] = sendOrderModel.id;
            
            [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"取消成功"];
                
                [self myBillListDataPage:1 hud:YES];// 取消成功刷新列表
                
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
        
    } otherButtonTitles:@"取消"];
    [alert show];
    
}

#pragma mark - 客户撤销发单
/**
客户撤销发单
 */
- (void)sendOrder_CheXiaoOrder_withModel:(MySendOrderModel * )sendOrderModel{
    
    //  订单失效才可以撤回
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"撤销之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            
            [self showLoading];

            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"id"] = sendOrderModel.id;
            
            [MCNetTool postWithUrl:HttpMeUndoBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"撤销成功"];
                
                [self myBillListDataPage:1 hud:YES];// 撤销成功刷新列表
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"撤回"];
    [alert show];
    
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  181;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MySendOrderDetaileViewController * vc = [[MySendOrderDetaileViewController alloc]initWithNibName:@"MySendOrderDetaileViewController" bundle:nil];
    MySendOrderModel * mySendOrderModel = _dataArray[indexPath.section];
    vc.pro_id = mySendOrderModel.id;
    vc.pay_statu = mySendOrderModel.pay_statu;
    [self.navigationController pushViewController:vc animated:YES];

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
