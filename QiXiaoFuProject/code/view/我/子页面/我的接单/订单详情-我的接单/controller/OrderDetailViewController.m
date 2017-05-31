//
//  OrderDetailViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailHeaderView.h"
#import "ProductDetaileHeaderCell.h"
#import "ProductDetaileCell.h"
#import "ProductDetail1TableViewCell.h"
#import "ProductDetaileFooterView.h"
#import "OrderDetailImageCell.h"
#import "OrderDetaileCancleCell.h"
#import "OrderDetaileTiaoJiaImageCell.h"
#import "OrderDetaileTiaoJiaCell.h"


#import "OrderDetaileProModel.h"
#import "BlockUIAlertView.h"
#import "EngineerTureOrderFinishViewController.h"
#import "JieFanDanZaiCiPayViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSArray+Utils.h"
#import "ChatViewController.h"
#import "AssociationViewController.h"


static NSString * const kSeverName = @"项目名称";
static NSString * const kSeverLY = @"服务领域";
static NSString * const kSeverPPXH = @"品牌型号";
static NSString * const kSeverNumber = @"数量/单位";
static NSString * const kSeverXS = @"服务形式";
static NSString * const kSeverLX = @"服务类型";
static NSString * const kSeverTime = @"预约服务时间";
static NSString * const kSeverQY = @"服务区域";
//static NSString * const kSeverOtherQY = @"其他服务领域";
//static NSString * const kSeverOtherXH = @"其他品牌型号";
static NSString * const kSeverMark = @"备注";
static NSString * const kSeverPrice = @"服务价格";
static NSString * const kSeverSparePart = @"使用备件";
static NSString * const kSeverImage = @"图片121";
static NSString * const kSeverCancle = @"取消订单121";
static NSString * const kSeverTiaoJiaImage = @"调价有图片123";
static NSString * const kSeverTiaoJia = @"调价没有图片123";




@interface OrderDetailViewController (){


    BOOL _orderHaveImage;// 订单有没有图片
    BOOL _orderTiaoJiaHaveImage;// 订单调价有没有图片
    
    CGFloat _tiaoPrice;// 调的价格
    NSArray *_tiaoImageArray;// 调的价格上传的图片

    
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) OrderDetailHeaderView * orderDetailHeaderView;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) OrderDetaileProModel * orderDetaileProModel;
@property (nonatomic, strong) UIButton * chatBtn;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.navigationItem.title = @"订单详情";
    
    _orderHaveImage = YES;
    _orderTiaoJiaHaveImage = YES;
    
    _tiaoImageArray = [NSArray new];
    
    _tiaoPrice = 0;
    
    _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_n"] forState:UIControlStateNormal];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_red"] forState:UIControlStateHighlighted];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_red"] forState:UIControlStateSelected];
    _chatBtn.size = _chatBtn.currentBackgroundImage.size;
    [_chatBtn addTarget:self action:@selector(chatItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:_chatBtn];

    
    
//    _titles = @[kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverOtherQY,kSeverOtherXH,kSeverMark,kSeverPrice];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetail1TableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductDetail1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailImageCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetaileCancleCell" bundle:nil] forCellReuseIdentifier:@"OrderDetaileCancleCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetaileTiaoJiaImageCell" bundle:nil] forCellReuseIdentifier:@"OrderDetaileTiaoJiaImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetaileTiaoJiaCell" bundle:nil] forCellReuseIdentifier:@"OrderDetaileTiaoJiaCell"];
 
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _orderDetailHeaderView = [OrderDetailHeaderView orderDetailHeaderView];
    _orderDetailHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [headerView addSubview:_orderDetailHeaderView];
    self.tableView.tableHeaderView =headerView;
 


     
// Do any additional setup after loading the view from its nib.
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self myOtBillDetailRequest];
    
}


#pragma mark - 我要接单显示
- (void)myOtBillDetailRequest{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"id"] = _pro_id;

    
    [self showLoading];
    
    [MCNetTool postWithUrl:HttpMeMyOtDetail params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _orderDetaileProModel = [OrderDetaileProModel mj_objectWithKeyValues:requestDic];
        
        
        [self dismissLoading];
        
        
//        NSArray * titles = @[kSeverName,kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverOtherQY,kSeverMark,kSeverPrice,kSeverImage,kSeverCancle,kSeverTiaoJiaImage,kSeverTiaoJia];
        
        NSArray * titles = @[kSeverName,kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverMark,kSeverPrice,kSeverSparePart,kSeverImage,kSeverCancle,kSeverTiaoJiaImage,kSeverTiaoJia];
        _titles = [NSMutableArray arrayWithArray:titles];


        _orderDetailHeaderView.orderNumLab.text = [NSString stringWithFormat:@"订单序号 %@",_orderDetaileProModel.bill_sn];
        _orderDetailHeaderView.orderTimeLab.text = [NSString stringWithFormat:@"创建时间 %@",[Utool comment_timeStamp2TimeFormatter:_orderDetaileProModel.inputtime]];
        
        // 订单没有图片
        if (_orderDetaileProModel.image.count == 0) {
            _orderHaveImage = NO;
            [_titles removeObject:kSeverImage];
        }
        
        
        if(_orderDetaileProModel.call_name.length == 0){
            _chatBtn.hidden = YES;
        }else{
            _chatBtn.hidden = NO;
        }
        
        if (_orderDetaileProModel.os ==1) {
            _chatBtn.selected = YES;
        }else{
            _chatBtn.selected = NO;
         }
        
        
        if(_orderDetaileProModel.bill_statu == 1 || _orderDetaileProModel.bill_statu == 3){
            _chatBtn.hidden = YES;

        }else{
            _chatBtn.hidden = NO;
            
        }

       //  service_up_price  == 0  没有调价   > 0  有调价
        
        if([_orderDetaileProModel.service_up_price integerValue] == 0){
        
            [_titles removeObject:kSeverTiaoJia];
            [_titles removeObject:kSeverTiaoJiaImage];

        }else{
        
            //  调价没有图片
            if (_orderDetaileProModel.up_images.count == 0) {
                [_titles removeObject:kSeverTiaoJiaImage];
            }else{
                // 调价有图片
                [_titles removeObject:kSeverTiaoJia];
            }
        }
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
         [self showErrorText:error];
     }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0){
        ProductDetaileHeaderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetaileHeaderCell"];
        [cell.iconImageView setImageWithUrl:_orderDetaileProModel.bill_user_avatar placeholder:kDefaultImage_header];
        cell.nameLab.text = _orderDetaileProModel.bill_user_name;
        cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:_orderDetaileProModel.inputtime];
        
        //发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】

        if (_orderDetaileProModel.bill_statu ==0) {
            [cell.stateBtn setTitle:@"撤销" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==1) {
            [cell.stateBtn setTitle:@"待接单" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==2) {
            [cell.stateBtn setTitle:@"已接单" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==3) {
            [cell.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==4) {
            [cell.stateBtn setTitle:@"已失效" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==5) {
            [cell.stateBtn setTitle:@"已取消" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==6) {
            [cell.stateBtn setTitle:@"调价中" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==7) {
            [cell.stateBtn setTitle:@"补单" forState:UIControlStateNormal];
        }else if (_orderDetaileProModel.bill_statu ==8) {
            [cell.stateBtn setTitle:@"已接单" forState:UIControlStateNormal];
        }
        
        //转移状态
        if ([_orderDetaileProModel.move_state intValue] == 1){
            [cell.stateBtn setTitle:@"转移待确定" forState:UIControlStateNormal];
        }else if ([_orderDetaileProModel.move_state intValue] == 2){
            [cell.stateBtn setTitle:@"已转移转移" forState:UIControlStateNormal];
        }
        
        return cell;
    }
    
    if (indexPath.section == 1) {

        NSString * title = _titles[indexPath.row];
        
        if(indexPath.row == 6/*|| indexPath.row == 8*/){
        
            ProductDetail1TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetail1TableViewCell"];
            cell.titleLab.text = _titles[indexPath.row];

            if(indexPath.row == 6){
                //预约服务时间
                cell.contentLab.text = [NSString stringWithFormat:@"%@-%@",
                                        [Utool timeStamp2TimeFormatter:_orderDetaileProModel.service_stime],
                                        [Utool timeStamp2TimeFormatter:_orderDetaileProModel.service_etime]];

            }
//            else if (indexPath.row == 8){
//                // 其他服务领域
//                cell.contentLab.text = _orderDetaileProModel.other_service_sector.length==0?@"     ":_orderDetaileProModel.other_service_sector;;
// 
//            }
            /*
            else if (indexPath.row == 8){
                //其他品牌型号
                cell.contentLab.text = _orderDetaileProModel.other_service_brand;
            }
             */
        
            return cell;
        }else if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 ||
                 indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 ||
                 indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 ){
        
        
            ProductDetaileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetaileCell"];
            cell.titleLab.text = _titles[indexPath.row];
            
            if (indexPath.row == 0) {
                //服务领域
                cell.contentLab.text = _orderDetaileProModel.entry_name;
            }else if (indexPath.row == 1) {
                //服务领域
                cell.contentLab.text = _orderDetaileProModel.service_sector;
            }else if(indexPath.row == 2){
                //品牌型号
                cell.contentLab.text = _orderDetaileProModel.service_brand;
                
            }else if(indexPath.row == 3){
                //数量单位
                cell.contentLab.text =_orderDetaileProModel.number;
            }else if(indexPath.row == 4){
                //服务形式
                cell.contentLab.text = _orderDetaileProModel.service_form;
            }else if(indexPath.row == 5){
                //服务类型
                cell.contentLab.text = _orderDetaileProModel.service_type;
            }
            else if(indexPath.row == 7){
                //服务区域
                cell.contentLab.text =   _orderDetaileProModel.service_address.length==0?@"     ":_orderDetaileProModel.service_address;

            }else if(indexPath.row == 8){
                // 备注
                cell.contentLab.text = _orderDetaileProModel.bill_desc.length==0?@"   ":_orderDetaileProModel.bill_desc;

            }else if(indexPath.row == 9){
                // 服务价格
                cell.contentLab.text = [NSString stringWithFormat:@"¥%@",_orderDetaileProModel.service_price];
            }else if(indexPath.row == 10){
                // 使用备件
                cell.contentLab.text = [NSString stringWithFormat:@"%@",@"XXXXX(56712356),YYYYYYY(17836712),ZzzzZZZ(617468734623)"];
            }
            return cell;
        
        
        }
        else if([title isEqualToString:kSeverImage]){
        
            OrderDetailImageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailImageCell"];
            cell.imageArray =_orderDetaileProModel.image;
            return cell;

        }else if([title isEqualToString:kSeverCancle]){
            OrderDetaileCancleCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetaileCancleCell"];
            cell.t_state =_orderDetaileProModel.t_state;
            cell.pay_statu =_orderDetaileProModel.pay_statu;
            cell.bill_statu =_orderDetaileProModel.bill_statu;
            cell.move_state = [_orderDetaileProModel.move_state integerValue];
            
            //转移订单
            cell.orderDetaileTransfer_Btn = ^(){
                AssociationViewController * vc = [[AssociationViewController alloc]initWithNibName:@"AssociationViewController" bundle:nil];
                vc.isFromTrans = YES;
                vc.orderId = _orderDetaileProModel.id;
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            
            //拒绝转移订单
            cell.orderDetaileTransfer_BtnRefuse = ^(){
                BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定拒绝接受转移的订单？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    
                    if(buttonIndex == 1){
                        NSMutableDictionary * params = [NSMutableDictionary new];
                        params[@"userid"] = kUserId;
                        params[@"move_to_eng_id"] = _orderDetaileProModel.ot_user_id;//接受者的id
                        params[@"id"] = _orderDetaileProModel.id;//订单id
                        params[@"move_to_eng_name"] = _orderDetaileProModel.call_nik_name;//接受者的昵称
                        params[@"move_state"] = @"0";//表示被拒绝
                        
                        [MCNetTool postWithUrl:HttpTransferRefuseMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
                            
                            [self.navigationController popViewControllerAnimated:YES];//  成功，返回
                            [self showSuccessText:msg];
                            
                        } fail:^(NSString *error) {
                            [self showErrorText:error];
                        }];
                    }
                    
                } otherButtonTitles:@"确定"];
                [alert show];
            };
            
            //接受转移订单
            cell.orderDetaileTransfer_BtnAgree = ^(){
                
                BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定接受转移的订单？" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    
                    if(buttonIndex == 1){
                        NSMutableDictionary * params = [NSMutableDictionary new];
                        params[@"userid"] = kUserId;
                        params[@"move_to_eng_id"] = _orderDetaileProModel.ot_user_id;//接受者的id
                        params[@"id"] = _orderDetaileProModel.id;//订单id
                        params[@"move_to_eng_name"] = _orderDetaileProModel.call_nik_name;//接受者的昵称
                        params[@"move_state"] = @"1";//表示接受
                        
                        [MCNetTool postWithUrl:HttpTransferAgreeMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
                            
                            [self.navigationController popViewControllerAnimated:YES];//  成功，返回
                            [self showSuccessText:msg];
                            
                        } fail:^(NSString *error) {
                            [self showErrorText:error];
                        }];
                    }
                    
                } otherButtonTitles:@"确定"];
                [alert show];
            };
            
            // 取消订单
            cell.orderDetaileCancle_QuXiaoDingDan =^( ){
                
                //kTipAlert(@"取消订单");
                
                
                BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消订单将扣除服务费用的10%,\n你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
                    
                    if(buttonIndex == 1){
                        
                        NSMutableDictionary * params = [NSMutableDictionary new];
                        params[@"userid"] = kUserId;
                        params[@"id"] = _pro_id;
                        
                        [MCNetTool postWithUrl:HttpMeMyEngOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                            
                            // state == 1 余额不足
                            //state ==  0  取消成功
                            NSInteger state = (int)requestDic[@"state"];
                            
                            if (state == 1) {
                                
                                [self showErrorText:msg];
                                
                            }else{
                            
                                [self.navigationController popViewControllerAnimated:YES];
                                [self showSuccessText:msg];

                            }
                            
                            [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];

                            
                        } fail:^(NSString *error) {
                            [self showErrorText:error];
                        }];
                    }
                    
                } otherButtonTitles:@"确定取消"];
                [alert show];
                
                
            };
            
            // 删除订单
            cell.orderDetaileCancle_Delete =^(){
                
                BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"删除之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    
                    if(buttonIndex == 1){
                        
                        NSMutableDictionary * params = [NSMutableDictionary new];
                        params[@"userid"] = kUserId;
                        params[@"id"] = _pro_id;
                        
                        [MCNetTool postWithUrl:HttpMeEngDelBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                            [self showSuccessText:msg];
                            
                            [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];

                            [self.navigationController popViewControllerAnimated:YES];
                            
                            
                        } fail:^(NSString *error) {
                            [self showErrorText:error];
                        }];
                    }
                    
                } otherButtonTitles:@"删除"];
                [alert show];
                
            };
            
            // 调价工程师确认  -- 同意
            cell.orderDetaileCancle_TongYi =^( ){
                
                //kTipAlert(@"调价工程师确认  -- 同意");
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _pro_id;
                params[@"state"] = @"1";
                
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self showSuccessText:msg];
                    
                    [self myOtBillDetailRequest];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            };
            cell.orderDetaileCancle_BuTongYi =^( ){
                
                //kTipAlert(@"调价工程师确认  -- 不同意");
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _pro_id;
                params[@"state"] = @"0";
                
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"拒绝调价"];
                    
                    [self myOtBillDetailRequest];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            };
            
            // 确认完成--> 去选择使用的备件sn码  并完成订单
            cell.orderDetaileCancle_QueRenWanCheng =^( ){
                
                EngineerTureOrderFinishViewController * vc = [[EngineerTureOrderFinishViewController alloc]initWithNibName:@"EngineerTureOrderFinishViewController" bundle:nil];
                
                if (_orderDetaileProModel.bill_statu == 7) {
                    vc.type = 2;// 补单
                }else{
                    vc.type = 1;// 工程师确认完成
                }
                vc.f_id = _pro_id;
                vc.engineerTureOrderFinishViewBlock =^(){
                    
                    [self myOtBillDetailRequest];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            };
            // 取消
            cell.orderDetaileCancle_cancle =^( ){
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _pro_id;
                [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    
                    [self myOtBillDetailRequest];

                    
                    [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];
                    [self showSuccessText:msg];
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            };
            
            // 去支付
            cell.orderDetaileCancle_GoPay =^(){
                
                JieFanDanZaiCiPayViewController * vc = [[JieFanDanZaiCiPayViewController alloc]initWithNibName:@"JieFanDanZaiCiPayViewController" bundle:nil];
                vc.type = 1;
                vc.f_id = _pro_id;
                vc.order_price =[_orderDetaileProModel.service_price floatValue];
                
                vc.jieFanDanZaiCiPayViewBlock =^(){
                    
                    [self myOtBillDetailRequest];
                };
                
                [self.navigationController pushViewController:vc animated:YES];
                
            };
            
            cell.myReceivingOrderCellWithBtnKaishiGongzuo =^(){
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _pro_id;
                [MCNetTool postWithUrl:HttpMeEngStartWork params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self myOtBillDetailRequest];
                    
                    [self showSuccessText:msg];
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            };
            
            
            return cell;
            
        }else if([title isEqualToString:kSeverTiaoJiaImage]){
            OrderDetaileTiaoJiaImageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetaileTiaoJiaImageCell"];
            cell.titleLab.text = [NSString stringWithFormat:@"客户提出调价,调价金额是: ¥%@",_orderDetaileProModel.service_up_price];
            cell.imageArray =_orderDetaileProModel.up_images;
            
            [cell.agreeBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _orderDetaileProModel.id;
                params[@"state"] = @"1";
              
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self showSuccessText:@"调价成功"];
                    
                    [self myOtBillDetailRequest];

                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
                
            }];
            
            [cell.cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _orderDetaileProModel.id;
                params[@"state"] = @"0";
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"拒绝调价"];
                    
                    [self myOtBillDetailRequest];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }];
            
            
            return cell;
            
        }else if([title isEqualToString:kSeverTiaoJia]){
            OrderDetaileTiaoJiaCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetaileTiaoJiaCell"];
            cell.titleLab.text = [NSString stringWithFormat:@"客户提出调价,调价金额是: ¥%@",_orderDetaileProModel.service_up_price];
            
            [cell.agreeBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _orderDetaileProModel.id;
                params[@"state"] = @"1";
                
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"调价成功"];
                    
                    [self myOtBillDetailRequest];

                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
                
            }];
            
            [cell.cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _orderDetaileProModel.id;
                params[@"state"] = @"0";
                
                [MCNetTool postWithUrl:HttpMeUpBillPriceEng params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"拒绝调价"];
                    
                    [self myOtBillDetailRequest];

                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
            }];
            
            return cell;
        }
        
    }
    return nil;
}


#pragma mark - 进入聊天界面
- (void)chatItemAction:(UIBarButtonItem *)item{
    
    if([_orderDetaileProModel.call_name isEqualToString:kPhone]){
        return;
    }
    
    
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:_orderDetaileProModel.call_name
                                                                                   friendUsername:_orderDetaileProModel.call_nik_name
                                                                                   friendUserIcon:_orderDetaileProModel.bill_user_avatar
                                                                                             user:kPhone
                                                                                         userName:kUserName
                                                                                         userIcon:kUserIcon];
    
    chatController.title = _orderDetaileProModel.call_nik_name;
    chatController.friendIcon = _orderDetaileProModel.bill_user_avatar;
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        return  80;
    }
    NSString * title = _titles[indexPath.row];
    if([title isEqualToString:kSeverImage]){
        return (kScreenWidth - 20 - 20)/3 + 20;
    }
    if([title isEqualToString:kSeverCancle]){
        return 44;
    }
    if([title isEqualToString:kSeverTiaoJiaImage]){
        return 200;
    }
    if([title isEqualToString:kSeverTiaoJia]){
        return 100;
    }
    return UITableViewAutomaticDimension;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




- (void)deleateChatlistWithUserPhone:(NSString *)userPhone{
    if (userPhone.length != 0) {
        [[EMClient sharedClient].chatManager deleteConversation:userPhone deleteMessages:NO];
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
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
