//
//  MyReceivingOrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MyReceivingOrderViewController.h"
#import "MyReceivingOrderCell.h"
#import "OrderDetailViewController.h"
//#import "ReplacementOrderViewController.h"
#import "MySendOrderModel.h"
#import "EngineerTureOrderFinishViewController.h"
#import "BlockUIAlertView.h"
#import "JieFanDanZaiCiPayViewController.h"
#import "ChatViewController.H"
#import "CommentViewController.h"
#import "CommentListViewController.h"


@interface MyReceivingOrderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, assign) NSInteger page;


@end

@implementation MyReceivingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的接单";
    _page = 1;
    _dataArray = [NSMutableArray new];
    
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"补单" target:self action:@selector(rightBuDanItemAction:)];

    [_tableView registerNib:[UINib nibWithNibName:@"MyReceivingOrderCell" bundle:nil] forCellReuseIdentifier:@"MyReceivingOrderCell"];
    _tableView.tableFooterView = [UIView new];
    
    
    [self myBillListDataPage:1 hud:YES];
    
    [self addRefreshView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferSuccess) name:@"TRANSFERSUCCESS" object:nil];
    // Do any additional setup after loading the view from its nib.
}

//转移操作成功后刷新
- (void)transferSuccess{
    [self myBillListDataPage:1 hud:YES];
}

- (void)addRefreshView{
    
    
    [_tableView headerAddMJRefresh:^{
        
        [self myBillListDataPage:1 hud:NO];
    }];
    [_tableView footerAddMJRefresh:^{
        [self myBillListDataPage:_page hud:NO];
        
    }];
    
}


- (void)myBillListDataPage:(NSInteger )page hud:(BOOL )hud{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"curpage"] = @(page);
    //params[@"pay_statu"] = _bill_statu;// 支付状态【0 待支付】【1 已支付】
    params[@"bill_statu"] = @(self.receiveOrderStatus ? :ReceiveOrderStausReceived);//发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】
    
    [MCNetTool postWithUrl:HttpMeMyOtList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _page = page;
        _page ++;
        NSArray * array = [MySendOrderModel mj_objectArrayWithKeyValuesArray:requestDic];
        
        page==1?[_dataArray setArray:array]:[_dataArray addObjectsFromArray:array];
        
     
        [_tableView reloadData];
        
        if (array.count < 10) {
            [_tableView hidenFooter];
        }
        
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        
    } fail:^(NSString *error) {
        page==1?[_tableView headerEndRefresh]:[_tableView footerEndRefresh];

        hud?[self dismissLoading]:@"";

//        [self showErrorText:error];
//        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewDefault withScrollView:_tableView];
        
        [YWNoNetworkView showNoNetworkInView:self.view reloadBlock:^{
            [self myBillListDataPage:_page hud: _page > 1 ? NO :YES ];
        }];
        
    }];
    
}


//- (void)rightBuDanItemAction:(UIBarButtonItem *)item{
//
//    ReplacementOrderViewController * vc  = [[ReplacementOrderViewController alloc]initWithNibName:@"ReplacementOrderViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
//
//}


#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyReceivingOrderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"MyReceivingOrderCell"];
     cell.indexPath = indexPath;
    MySendOrderModel * mySendOrderModel = _dataArray[indexPath.section];
    cell.mySendOrderModel = mySendOrderModel;
    
    // 取消订单
    cell.myReceivingOrderCellWithBtnState_QuXiaoDingDan =^(MySendOrderModel * sendOrderModel){
        
        //kTipAlert(@"取消订单");
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消订单将扣除服务费用的10%,\n你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = sendOrderModel.id;
                [MCNetTool postWithUrl:HttpMeMyEngOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    
                    // state == 1 余额不足
                    //state ==  0  取消成功
                    NSInteger state = (int)requestDic[@"state"];
                    
                    if (state == 1) {
                        
                        [self showErrorText:msg];
                        
                    }else{
                        
                        [self myBillListDataPage:1 hud:YES];//  订单确认成功，重新刷新列表
                        [self showSuccessText:msg];
                        
                    }

                    [self deleateChatlistWithUserPhone:sendOrderModel.call_name];

                
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
            
        } otherButtonTitles:@"确定取消"];
        [alert show];

        
    };

    // 删除订单
    cell.myReceivingOrderCellWithBtnState_Delete =^(MySendOrderModel * sendOrderModel,NSIndexPath * cellIndexPath){
        
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"删除之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
        
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = sendOrderModel.id;
         
                [MCNetTool postWithUrl:HttpMeEngDelBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:msg];
                    
                    [_dataArray removeObjectAtIndex:cellIndexPath.section];//移除数据源的数据
                    // 或者
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
    
    // 调价工程师确认  -- 同意
    cell.myReceivingOrderCellWithBtnState_TongYi =^(MySendOrderModel * sendOrderModel){
        
        //kTipAlert(@"调价工程师确认  -- 同意");
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = sendOrderModel.id;
        params[@"state"] = @"1";

        [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:msg];
            
            
            [self myBillListDataPage:1 hud:YES];

            
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    };
    cell.myReceivingOrderCellWithBtnState_BuTongYi =^(MySendOrderModel * sendOrderModel){
        
        //kTipAlert(@"调价工程师确认  -- 不同意");
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = sendOrderModel.id;
        params[@"state"] = @"0";
        
        [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
            [self showSuccessText:@"拒绝调价"];
            
            [self myBillListDataPage:1 hud:YES];
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
    };
    
    // 确认完成--> 去选择使用的备件sn码  并完成订单
    cell.myReceivingOrderCellWithBtnState_QueRenWanCheng =^(MySendOrderModel * sendOrderModel){
        
        EngineerTureOrderFinishViewController * vc = [[EngineerTureOrderFinishViewController alloc]initWithNibName:@"EngineerTureOrderFinishViewController" bundle:nil];
        
        if (sendOrderModel.bill_statu == 7) {
            vc.type = 2;

        }else{
            vc.type = 1;
        }
        
        vc.f_id = sendOrderModel.id;

        vc.engineerTureOrderFinishViewBlock =^(){
            
            [self myBillListDataPage:1 hud:YES];//  订单确认成功，重新刷新列表
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    };

    // 取消
    cell.myReceivingOrderCellWithBtnState_cancle =^(MySendOrderModel * sendOrderModel){
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确认放弃本次操作吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = sendOrderModel.id;
                [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:msg];
                    
                    
                    [self deleateChatlistWithUserPhone:sendOrderModel.call_name];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
        } otherButtonTitles:@"确定"];
        [alert show];
    };
    // 去支付
    cell.myReceivingOrderCellWithBtnState_GoPay =^(MySendOrderModel * sendOrderModel){
        
        JieFanDanZaiCiPayViewController * vc = [[JieFanDanZaiCiPayViewController alloc]initWithNibName:@"JieFanDanZaiCiPayViewController" bundle:nil];
        vc.type = 1;
        vc.f_id = sendOrderModel.id;
        vc.order_price = [sendOrderModel.service_price floatValue];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    cell.myReceivingOrderCellWithBtnChat =^(MySendOrderModel * sendOrderModel){
 
        
        if([sendOrderModel.call_name isEqualToString:kPhone]){
            return;
        }
        
        
        ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:sendOrderModel.call_name
                                                                                       friendUsername:sendOrderModel.call_nik_name
                                                                                       friendUserIcon:sendOrderModel.bill_user_avatar
                                                                                                 user:sendOrderModel.call_name
                                                                                             userName:kUserName
                                                                                             userIcon:kUserIcon];
        chatController.title = sendOrderModel.call_nik_name;
        chatController.friendIcon = sendOrderModel.bill_user_avatar;
        chatController.userIcon = kUserIcon;
        [self.navigationController pushViewController:chatController animated:YES];

        
    };
    
    cell.myReceivingOrderCellWithBtnKaishiGongzuo =^(MySendOrderModel * sendOrderModel){
        
      
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        params[@"id"] = sendOrderModel.id;
        [MCNetTool postWithUrl:HttpMeEngStartWork params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            [self myBillListDataPage:1 hud:YES];//  订单确认成功，重新刷新列表

            [self showSuccessText:msg];
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    };
    
    //拒绝转移订单
    cell.myReceivingOrderCellWithBtnRefuseTransfer = ^(MySendOrderModel *sendOrderModel){
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定拒绝接受转移的订单？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"move_to_eng_id"] = sendOrderModel.ot_user_id;//接受者的id
                params[@"id"] = sendOrderModel.id;//订单id
                params[@"move_to_eng_name"] = sendOrderModel.call_nik_name;//接受者的昵称
                params[@"move_state"] = sendOrderModel.move_state;
                
                [MCNetTool postWithUrl:HttpTransferRefuseMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self myBillListDataPage:1 hud:YES];//  成功，重新刷新列表
                    [self showSuccessText:msg];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
            
        } otherButtonTitles:@"确定"];
        [alert show];
    };
    
    //接受转移订单
    cell.myReceivingOrderCellWithBtnAgreeTransfer = ^(MySendOrderModel *sendOrderModel){
        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定接受转移的订单？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"move_to_eng_id"] = sendOrderModel.ot_user_id;//接受者的id
                params[@"id"] = sendOrderModel.id;//订单id
                params[@"move_to_eng_name"] = sendOrderModel.call_nik_name;//接受者的昵称
                params[@"move_state"] = sendOrderModel.move_state;
                
                [MCNetTool postWithUrl:HttpTransferAgreeMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self myBillListDataPage:1 hud:YES];//  成功，重新刷新列表
                    [self showSuccessText:msg];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }
            
        } otherButtonTitles:@"确定"];
        [alert show];
    };
    
    //去评价客户
    cell.myReceivingOrderCellEvaluate_Btn = ^(){
        CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
        vc.f_id = mySendOrderModel.id;
        vc.isFromEng = YES;
        vc.commentViewBlock =^(){
            [self myBillListDataPage:1 hud:YES];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //查看评价
    cell.myReceivingOrderCellSeeEvaluate_Btn = ^{
        CommentListViewController * vc   =[[CommentListViewController alloc]initWithNibName:@"CommentListViewController" bundle:nil];
        vc.isSeeComment = YES;
        vc.sender_id = mySendOrderModel.ot_user_id;
        vc.receiver_id = kUserId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailViewController * vc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
    MySendOrderModel * mySendOrderModel = _dataArray[indexPath.section];
    vc.pro_id = mySendOrderModel.id;
    vc.move_state = mySendOrderModel.move_state;
    [self.navigationController pushViewController:vc animated:YES];

    
}


- (void)deleateChatlistWithUserPhone:(NSString *)userPhone{
    if (userPhone.length != 0) {
        [[EMClient sharedClient].chatManager deleteConversation:userPhone deleteMessages:NO];
    }
}






- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
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
