//
//  MySendOrderDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MySendOrderDetaileViewController.h"
#import "OrderDetailHeaderView.h"
#import "ProductDetaileHeaderCell.h"
#import "ProductDetaileCell.h"
#import "ProductDetail1TableViewCell.h"
#import "ProductDetaileFooterView.h"
#import "OrderDetailImageCell.h"
#import "OrderSendDetaileCancleCell.h"

#import "OrderDetaileKeHuContentCell.h"//  我的发单

#import "OrderDetaileProModel.h"
#import "BlockUIAlertView.h"
#import "JieFanDanZaiCiPayViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSArray+Utils.h"
#import "ChatViewController.h"
#import "CommentViewController.h"
#import "ChongSendOrderVC1.h"

static NSString * const kSeverName = @"项目名称";
static NSString * const kSeverLY = @"服务领域";
static NSString * const kSeverPPXH = @"品牌型号";
static NSString * const kSeverNumber = @"数量/单位";
static NSString * const kSeverXS = @"服务形式";
static NSString * const kSeverLX = @"服务类型";
static NSString * const kSeverTime = @"预约服务时间";
static NSString * const kSeverQY = @"服务区域";
//static NSString * const kSeverOtherQY = @"其他服务领域";
static NSString * const kSeverMark = @"备注";
static NSString * const kSeverPrice = @"服务价格";
static NSString * const kSeverSparePart = @"使用备件";
static NSString * const kSeverImage = @"图片121";
static NSString * const kSeverCancle = @"取消订单121";


static NSString * const kSeverKehuContent = @"客户调价内容";
@interface MySendOrderDetaileViewController ()<UIScrollViewDelegate>
{
    
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

@implementation MySendOrderDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    _orderHaveImage = YES;
    _orderTiaoJiaHaveImage = YES;
    
    _tiaoImageArray = [NSArray new];
    
    _tiaoPrice = 0;
    
    _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_red"] forState:UIControlStateNormal];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_n"] forState:UIControlStateHighlighted];
    [_chatBtn setBackgroundImage:[UIImage imageNamed:@"icon_chat_n"] forState:UIControlStateSelected];
    _chatBtn.size = _chatBtn.currentBackgroundImage.size;
    [_chatBtn addTarget:self action:@selector(chatItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:_chatBtn];
    _chatBtn.hidden = YES;
    
    
    //    _titles = @[kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverOtherQY,kSeverOtherXH,kSeverMark,kSeverPrice];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetail1TableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductDetail1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailImageCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderSendDetaileCancleCell" bundle:nil] forCellReuseIdentifier:@"OrderSendDetaileCancleCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"OrderDetaileKeHuContentCell" bundle:nil] forCellReuseIdentifier:@"OrderDetaileKeHuContentCell"];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    _orderDetailHeaderView = [OrderDetailHeaderView orderDetailHeaderView];
    _orderDetailHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [headerView addSubview:_orderDetailHeaderView];
    self.tableView.tableHeaderView =headerView;
        
    
   
 
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self myBillDetailRequest];
    
}


#pragma mark - 我要发单显示
- (void)myBillDetailRequest{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"id"] = _pro_id;
    
    
    [MCNetTool postWithUrl:HttpMeMyBillDetail params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _orderDetaileProModel = [OrderDetaileProModel mj_objectWithKeyValues:requestDic];
        _orderDetaileProModel.pay_statu =_pay_statu;
        
        
        
        
//        NSArray * titles = @[kSeverName,kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverOtherQY,kSeverMark,kSeverPrice,kSeverImage,kSeverCancle];
//        NSArray * titles = @[kSeverName,kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverMark,kSeverPrice,kSeverSparePart,kSeverImage,kSeverCancle];
        NSArray * titles = @[kSeverName,kSeverLY,kSeverPPXH,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverMark,kSeverPrice,kSeverImage,kSeverCancle];
        
        _titles = [NSMutableArray arrayWithArray:titles];
        
        if(_orderDetaileProModel.call_name.length == 0){
            _chatBtn.hidden = YES;
        }else{
            _chatBtn.hidden = NO;
        }
        if(_orderDetaileProModel.bill_statu == 1 || _orderDetaileProModel.bill_statu == 3 || _orderDetaileProModel.bill_statu == 4 || _orderDetaileProModel.bill_statu == 5|| _orderDetaileProModel.bill_statu == 7 ){
            _chatBtn.hidden = YES;

        }else{
            _chatBtn.hidden = NO;
        }

        if (_orderDetaileProModel.os ==1) {
            _chatBtn.selected = YES;
        }else{
            _chatBtn.selected = NO;
        }

        _orderDetailHeaderView.orderNumLab.text = [NSString stringWithFormat:@"订单序号 %@",_orderDetaileProModel.bill_sn];
        _orderDetailHeaderView.orderTimeLab.text = [NSString stringWithFormat:@"创建时间 %@",[Utool comment_timeStamp2TimeFormatter:_orderDetaileProModel.inputtime]];
        
        // 订单没有图片
        if (_orderDetaileProModel.image.count == 0) {
            _orderHaveImage = NO;
            [_titles removeObject:kSeverImage];
        }
        
        //  service_up_price  == 0  没有调价   > 0  有调价
        
        
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
            
            if(_orderDetaileProModel.pay_statu == 0){
                [cell.stateBtn setTitle:@"待支付" forState:UIControlStateNormal];
            }else{
                [cell.stateBtn setTitle:@"待接单" forState:UIControlStateNormal];
            }
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
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        NSString * title = _titles[indexPath.row];
        
        if(indexPath.row == 6 /*|| indexPath.row == 8*/){
            
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
             return cell;
        }else if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 ||
                 indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 7 ||
                 indexPath.row == 8 || indexPath.row == 9 /*|| indexPath.row == 10*/ ){
            
            
            ProductDetaileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetaileCell"];
            cell.titleLab.text = _titles[indexPath.row];
            
            if (indexPath.row == 0) {
                //项目名称
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
            }
//            else if(indexPath.row == 10){
//                // 使用备件
//                cell.contentLab.text = [NSString stringWithFormat:@"%@",@"XXXXX(56712356),YYYYYYY(17836712),ZzzzZZZ(617468734623)"];
//            }
            return cell;
            
            
        }
        else if([title isEqualToString:kSeverImage]){
            
            OrderDetailImageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailImageCell"];
            cell.imageArray =_orderDetaileProModel.image;
            return cell;
            
        }else if([title isEqualToString:kSeverCancle]){
            OrderSendDetaileCancleCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderSendDetaileCancleCell"];
            cell.is_eval =_orderDetaileProModel.is_eval;
            cell.t_state =_orderDetaileProModel.t_state;
            cell.pay_statu =_orderDetaileProModel.pay_statu;
            cell.bill_statu =_orderDetaileProModel.bill_statu;
             // 取消订单
            cell.orderSendDetaileCancle_cancle =^( ){
                
                //kTipAlert(@"取消订单");
                
                if(_orderDetaileProModel.bill_statu == 2 || _orderDetaileProModel.bill_statu == 3 || _orderDetaileProModel.bill_statu == 6 || _orderDetaileProModel.bill_statu == 7 ){
                    
                    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消订单将扣除服务费用的10%,\n你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
                        
                        if(buttonIndex == 1){
                            
                            [self showLoading];
                            
                            NSMutableDictionary * params = [NSMutableDictionary new];
                            params[@"userid"] = kUserId;
                            params[@"id"] = _pro_id;
                            [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                                [self showSuccessText:msg];
                                
                                [self myBillDetailRequest];
                                
                                [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];

                                
                            } fail:^(NSString *error) {
                                [self showErrorText:error];
                            }];
                            
                        }
                        
                    } otherButtonTitles:@"确定取消"];
                    [alert show];
                    
                }else{
                    
                    [self showLoading];

                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"id"] = _pro_id;
                    [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        [self showSuccessText:msg];
                        
                        [self myBillDetailRequest];
                        
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                    

                }                
                
            };
            
            // 删除订单
            cell.orderSendDetaileCancle_Delete =^(){
                
                
                BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"删除之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
                    
                    if(buttonIndex == 1){
                        
                        [self showLoading];

                        NSMutableDictionary * params = [NSMutableDictionary new];
                        params[@"userid"] = kUserId;
                        params[@"id"] = _pro_id;
                        
                        [MCNetTool postWithUrl:HttpMeMyBillDel params:params success:^(NSDictionary *requestDic, NSString *msg) {
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
            
            // 确认完成-
            cell.orderSendDetaileCancle_QueRenWanCheng =^( ){
                
                [self showLoading];

                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _pro_id;
                
                [MCNetTool postWithUrl:HttpMeComBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:@"订单已完成"];
                    
                    [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];

                    CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
                    vc.f_id = _orderDetaileProModel.id;
                    vc.commentViewBlock =^(){
                        [self myBillDetailRequest];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];

                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];

                
            };
            // 取消
            cell.orderSendDetaileCancle_cancle =^( ){
                
                
  
                
                if(_orderDetaileProModel.bill_statu == 2 || _orderDetaileProModel.bill_statu == 3 || _orderDetaileProModel.bill_statu == 6 || _orderDetaileProModel.bill_statu == 7 ){
                    
                    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"取消订单将扣除服务费用的10%,\n你确定要取消订单吗?" cancelButtonTitle:@"放弃取消" clickButton:^(NSInteger buttonIndex) {
                        
                        if(buttonIndex == 1){
                            
                            [self showLoading];

                            NSMutableDictionary * params = [NSMutableDictionary new];
                            params[@"userid"] = kUserId;
                            params[@"id"] = _pro_id;
                            [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                                [self showSuccessText:msg];
                                
                                [self myBillDetailRequest];
                                
                                [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];
                                
                                
                            } fail:^(NSString *error) {
                                [self showErrorText:error];
                            }];
                            
                        }
                        
                    } otherButtonTitles:@"确定取消"];
                    [alert show];
                    
                }else{
                    
                    [self showLoading];

                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"id"] = _pro_id;
                    [MCNetTool postWithUrl:HttpMeOffBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        [self showSuccessText:msg];
                        
                        [self myBillDetailRequest];
                        
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                    
                }
                
            };
            
            // 去支付
            cell.orderSendDetaileCancle_GoPay =^(){
                
                JieFanDanZaiCiPayViewController * vc = [[JieFanDanZaiCiPayViewController alloc]initWithNibName:@"JieFanDanZaiCiPayViewController" bundle:nil];
                vc.type = 1;
                vc.f_id = _pro_id;
                vc.order_price =[_orderDetaileProModel.service_price floatValue];
                
                vc.jieFanDanZaiCiPayViewBlock =^(){
                    
                    //kTipAlert(@"去支付");
                     [self myBillDetailRequest];
                 
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            // 调价
            cell.orderSendDetaileCancle_Tiaojia =^(UIButton * btn){
                
//                btn.selected =!btn.selected;
                
//                if(btn.selected){
                    if(![_titles containsObject:kSeverKehuContent]){
                    
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_titles.count inSection:1];
                    [indexPaths addObject: indexPath];
                    [_titles addObject:kSeverKehuContent];
                    //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                    
                }else{
                    [_titles removeObject:kSeverKehuContent];//移除数据源的数据
                    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:_titles.count inSection:1];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];//移除tableView中的
                    _tiaoPrice = 0;
                    
                    [_tableView reloadData];
                }

            };
            // 去评价
            cell.orderSendDetaileCancle_Comment =^(){
                
                CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
                vc.f_id = _orderDetaileProModel.id;
                vc.commentViewBlock =^(){
                    
                    [self myBillDetailRequest];
                    
                };
                [self deleateChatlistWithUserPhone:_orderDetaileProModel.call_name];

                
                [self.navigationController pushViewController:vc animated:YES];
            };
             
            // 未完成
            cell.orderSendDetaileCancle_WeiWanCheng =^(){
                
                [self showLoading];

                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"id"] = _orderDetaileProModel.id;
                
                [MCNetTool postWithUrl:HttpMeNoBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    [self showSuccessText:msg];
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];
             };
             // 重新发布
            cell.orderSendDetaileCancle_ChongXinFaBu =^(){
                 ChongSendOrderVC1 * vc = [[ChongSendOrderVC1 alloc]initWithNibName:@"ChongSendOrderVC1" bundle:nil];
                vc.f_id = _orderDetaileProModel.id;
                [self.navigationController pushViewController:vc animated:YES];
                
            };
            
            // 撤回
            cell.orderSendDetaileCancle_CheHui =^(){
                
                [self sendOrder_CheXiaoOrder_withModel:_orderDetaileProModel];
                
                
            };
             return cell;
         }
        else if([title isEqualToString:kSeverKehuContent]){

            OrderDetaileKeHuContentCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetaileKeHuContentCell"];
            cell.service_price = [_orderDetaileProModel.service_price floatValue];
            cell.orderDetaileKeHuContentCellBlock = ^(NSString * price){
                
                _tiaoPrice = [price floatValue];
                
            };
            
            cell.orderDetaileKeHuContentImageArrayCellBlock = ^(NSArray * imageArray ){
                
                 _tiaoImageArray = imageArray;
             };
            
            [cell.tureBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_tiaoPrice == [_orderDetaileProModel.service_price floatValue]) {
                    [self showErrorText:@"调节的价格不能跟原价一样"];
                    
                }else if (_tiaoPrice == 0){
                    [self showErrorText:@"调节的价格不能为0"];
                }else if (_tiaoPrice < [_orderDetaileProModel.service_price floatValue]) {
                    
                    [self showLoading];

                    
                    NSMutableDictionary * params = [NSMutableDictionary new];
                    params[@"userid"] = kUserId;
                    params[@"id"] = _orderDetaileProModel.id;
                    params[@"service_up_price"] = @(_tiaoPrice);
                    
                    if (_tiaoImageArray.count != 0) {
                        // params[@"up_images"] = [_tiaoImageArray JSONString_Ext];
                        params[@"up_images"] = [_tiaoImageArray componentsJoinedByString:@","];
                    }
                    
                    [MCNetTool postWithUrl:HttpMeUpBillPriceGuest params:params success:^(NSDictionary *requestDic, NSString *msg) {
                        
                        [self showSuccessText:@"调价成功"];
                        
                        [self myBillDetailRequest];
                        
                        
                    } fail:^(NSString *error) {
                        [self showErrorText:error];
                    }];
                    
                    
                }else if (_tiaoPrice > [_orderDetaileProModel.service_price floatValue]) {
                    
                    JieFanDanZaiCiPayViewController * vc = [[JieFanDanZaiCiPayViewController alloc]initWithNibName:@"JieFanDanZaiCiPayViewController" bundle:nil];
                    vc.type = 2;
                    vc.f_id = _pro_id;
                    vc.order_price =_tiaoPrice - [_orderDetaileProModel.service_price floatValue];//  调整后需要支付的价格
                    vc.tioajia_order_price =_tiaoPrice ;// 调整后的价格
                    vc.tiaojiaImageUrlArray = _tiaoImageArray;
                    
                    vc.jieFanDanZaiCiPayViewBlock =^(){
                        
                        [self myBillDetailRequest];
                    };
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
            }];
            
            return cell;
        }
        
    }
    return nil;
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
    if([title isEqualToString:kSeverKehuContent]){
        return 205;
    }
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

#pragma mark - 客户撤销发单
/**
 客户撤销发单
 */
- (void)sendOrder_CheXiaoOrder_withModel:(OrderDetaileProModel * )orderDetaileProModel{
    
    //  订单失效才可以撤回
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"撤销之后订单无法被找回,你确认要删除此订单吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            
            [self showLoading];

            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"id"] = orderDetaileProModel.id;
            
            [MCNetTool postWithUrl:HttpMeUndoBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"撤销成功"];
                
                
                [self deleateChatlistWithUserPhone:orderDetaileProModel.call_name];
                
                [self myBillDetailRequest];
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"撤回"];
    [alert show];
    
}



#pragma mark - 进入聊天界面
- (void)chatItemAction:(UIBarButtonItem *)item{
    if([_orderDetaileProModel.call_name isEqualToString:kPhone]){
        return;
    }
    
    
    
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:_orderDetaileProModel.call_name
                                                                                   friendUsername:_orderDetaileProModel.call_nik_name
                                                                                   friendUserIcon:_orderDetaileProModel.ot_user_avatar
                                                                                             user:kPhone
                                                                                         userName:kUserName
                                                                                         userIcon:kUserIcon];
    
    chatController.title = _orderDetaileProModel.call_nik_name;
    chatController.friendIcon = _orderDetaileProModel.ot_user_avatar;
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}


- (void)deleateChatlistWithUserPhone:(NSString *)userPhone{
    if (userPhone.length != 0) {
        [[EMClient sharedClient].chatManager deleteConversation:userPhone deleteMessages:NO];
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
