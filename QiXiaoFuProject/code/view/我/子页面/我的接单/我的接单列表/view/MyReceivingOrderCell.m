//
//  MyReceivingOrderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MyReceivingOrderCell.h"
#import "WB_Stopwatch.h"
#import "ChatViewController.h"


@interface MyReceivingOrderCell()<WB_StopWatchDelegate>{
    
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timesLab;


@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *severContentLab;
@property (weak, nonatomic) IBOutlet UILabel *severTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *severAdressLab;
@property (weak, nonatomic) IBOutlet UILabel *severPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *payState;
@property (weak, nonatomic) IBOutlet UILabel *payStateW;


@property (weak, nonatomic) IBOutlet UIView *bottom1View;


@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


@property (strong, nonatomic) WB_Stopwatch * stopWatchLabel;;



@end





@implementation MyReceivingOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    
    
    _stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:_timesLab andTimerType:WBTypeTimer];
    _stopWatchLabel.delegate = self;
    [_stopWatchLabel setTimeFormat:@"mm:ss"];
    //    [_stopWatchLabel setCountDownTime:10];//多少秒 （1分钟 == 60秒）
    //    [_stopWatchLabel start];
    
    // Initialization code
    
    
    [_chatBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        if (_myReceivingOrderCellWithBtnChat) {
            _myReceivingOrderCellWithBtnChat(_mySendOrderModel);
        }
    }];
    
}






- (void)setMySendOrderModel:(MySendOrderModel *)mySendOrderModel{
    _mySendOrderModel = mySendOrderModel;
    
    _nameLbl.text = mySendOrderModel.entry_name;
    _titleLab.text = [NSString stringWithFormat:@"发布时间 %@",[Utool comment_timeStamp2TimeFormatter:mySendOrderModel.inputtime]];
    
    _severContentLab.text = mySendOrderModel.title;
    
    _severTimeLab.text = [NSString stringWithFormat:@"%@-%@",
                          [Utool timeStamp2TimeFormatter:mySendOrderModel.service_stime],
                          [Utool timeStamp2TimeFormatter:mySendOrderModel.service_etime]];
    _severAdressLab.text = mySendOrderModel.service_city;
    _severPriceLab.text = [NSString stringWithFormat:@"¥%@",mySendOrderModel.service_price];
    
    [self bottomViewState:mySendOrderModel];
    
}


- (void)bottomViewState:(MySendOrderModel *)mySendOrderModel{
    
    _chatBtn.selected = mySendOrderModel.os == 1?YES:NO;
    
    if (mySendOrderModel.call_name.length ==0 ) {
        _chatBtn.hidden = YES;
    }else{
        _chatBtn.hidden = NO;
    }
    
    //  发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】【8 开始工作】
    switch (mySendOrderModel.bill_statu) {
        case 0:
        {
            [self topViewLabShowType:NO whihContent:@"  已撤销  "];
            
            _rightBtn.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.selected = NO;
            
            [_rightBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_QuXiaoDingDan) {
                    _myReceivingOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                }
            }];
            
        }
            break;
        case 1:
        {
            _rightBtn.hidden = YES;
            _leftBtn.hidden = YES;
            
            
            //  【1 待接单】   我的接单不会出现这种状态
            
        }
            break;
        case 2:
        {
            
            [self topViewLabShowType:NO whihContent:@"  已接单  "];
            
            if(mySendOrderModel.t_state == 0 || mySendOrderModel.t_state == 4){
                
                _leftBtn.hidden = NO;
                _rightBtn.hidden = NO;
                
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_myReceivingOrderCellWithBtnState_QuXiaoDingDan) {
                        _myReceivingOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                    }
                }];
                [_rightBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_myReceivingOrderCellWithBtnState_QueRenWanCheng) {
                        _myReceivingOrderCellWithBtnState_QueRenWanCheng(mySendOrderModel);
                    }
                }];
                
            }else {
                
                _leftBtn.hidden = YES;
                _rightBtn.hidden = NO;
                _rightBtn.selected = YES;
                [_rightBtn setTitle:@"  等待客户确认完成  " forState:UIControlStateSelected];
                _rightBtn.userInteractionEnabled = NO;
                
            }
        }
            break;
        case 3:
        {
            // 订单已完成
            
            _chatBtn.hidden = YES;
            [self deleateChatlistWithUserPhone:nil];
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _rightBtn.selected = NO;
            [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_Delete) {
                    _myReceivingOrderCellWithBtnState_Delete(mySendOrderModel,_indexPath);
                }
            }];
            
            if ([mySendOrderModel.is_user_eval intValue] == 0){
                [self topViewLabShowType:NO whihContent:@"已完成"];
                
                [_leftBtn setTitle:@"  评价  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_myReceivingOrderCellEvaluate_Btn) {
                        _myReceivingOrderCellEvaluate_Btn();
                    }
                }];
            }else{
                [self topViewLabShowType:NO whihContent:@"已评价"];
                [_leftBtn setTitle:@"  查看评价  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_myReceivingOrderCellSeeEvaluate_Btn) {
                        _myReceivingOrderCellSeeEvaluate_Btn();
                    }
                }];
            }
        }
            break;
        case 4:
        {
            
            [self topViewLabShowType:NO whihContent:@"已失效"];
            
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _rightBtn.selected = NO;
            
            [_rightBtn setTitle:@"  取消  " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                if (_myReceivingOrderCellWithBtnState_QuXiaoDingDan) {
                    _myReceivingOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                }
            }];
            
        }
            break;
        case 5:
        {
            [self topViewLabShowType:NO whihContent:@"已取消"];
            
            // 删除
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _rightBtn.selected = NO;
            
            [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_Delete) {
                    _myReceivingOrderCellWithBtnState_Delete(mySendOrderModel,_indexPath);
                }
            }];
            
        }
            break;
        case 6:
        {
            [self topViewLabShowType:NO whihContent:@"调价中"];
            
            // 取消订单 --> 工程师取消发单
            
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _rightBtn.selected = NO;
            
            [_leftBtn setTitle:@" 同意 " forState:UIControlStateNormal];
            [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_TongYi) {
                    _myReceivingOrderCellWithBtnState_TongYi(mySendOrderModel);
                }
            }];
            
            [_rightBtn setTitle:@" 不同意 " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_BuTongYi) {
                    _myReceivingOrderCellWithBtnState_BuTongYi(mySendOrderModel);
                }
            }];
            
        }
            break;
        case 7:// 补单
        {
            if (mySendOrderModel.pay_statu == 0) {
                [self topViewLabShowType:YES whihContent:@"待支付"];
                _leftBtn.hidden = NO;
                _rightBtn.hidden = NO;
                _rightBtn.selected = NO;
                
                [_leftBtn setTitle:@"  取消  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_myReceivingOrderCellWithBtnState_cancle) {
                        _myReceivingOrderCellWithBtnState_cancle(mySendOrderModel);
                    }
                }];
                [_rightBtn setTitle:@"  去支付  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_myReceivingOrderCellWithBtnState_GoPay) {
                        _myReceivingOrderCellWithBtnState_GoPay(mySendOrderModel);
                    }
                }];
                
            }else{
                
                [self topViewLabShowType:NO whihContent:@"补单"];
                _rightBtn.hidden = NO;
                _leftBtn.hidden = YES;
                _rightBtn.selected = NO;
                
                [_rightBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_myReceivingOrderCellWithBtnState_QueRenWanCheng) {
                        _myReceivingOrderCellWithBtnState_QueRenWanCheng(mySendOrderModel);
                    }
                }];
                
            }
        }
            break;
        case 8:
        {
            
            [self topViewLabShowType:NO whihContent:@"  已接单  "];
            
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _rightBtn.selected = NO;
            
            [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnState_QuXiaoDingDan) {
                    _myReceivingOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                }
            }];
            
            [_rightBtn setTitle:@"  开始工作  " forState:UIControlStateNormal];
            [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnKaishiGongzuo) {
                    _myReceivingOrderCellWithBtnKaishiGongzuo(mySendOrderModel);
                }
            }];
            
            //转移状态 1转移中 2已接受 0已拒绝
            if ([mySendOrderModel.move_state intValue] == 1){
                [self topViewLabShowType:NO whihContent:@"  转移待确定  "];
                if ([mySendOrderModel.bill_belong intValue] == 1){
                    _leftBtn.hidden = NO;
                    _leftBtn.selected = NO;
                    _rightBtn.hidden = NO;
                    _rightBtn.selected = NO;
                    
                    [_leftBtn setTitle:@"  拒绝转移  " forState:UIControlStateNormal];
                    [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        if (_myReceivingOrderCellWithBtnRefuseTransfer) {
                            _myReceivingOrderCellWithBtnRefuseTransfer(mySendOrderModel);
                        }
                    }];
                    [_rightBtn setTitle:@"  接受转移  " forState:UIControlStateNormal];
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        if (_myReceivingOrderCellWithBtnAgreeTransfer) {
                            _myReceivingOrderCellWithBtnAgreeTransfer(mySendOrderModel);
                        }
                    }];
                }else if ([mySendOrderModel.bill_belong intValue] == 2){
                    

                    _leftBtn.hidden = YES;
                    _rightBtn.hidden = YES;
                }
            }else if ([mySendOrderModel.move_state intValue] == 2){
                //转移状态 1转移中 2已接受 0已拒绝
                [self topViewLabShowType:NO whihContent:@"  来自转移  "];
                if ([mySendOrderModel.bill_belong intValue] == 1){
                    _leftBtn.hidden = YES;
                    _rightBtn.hidden = YES;
                    _chatBtn.hidden = YES;
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    
    

    
}

- (void)deleateChatlistWithUserPhone:(NSString *)userPhone{
    if (userPhone.length != 0) {
        [[EMClient sharedClient].chatManager deleteConversation:_mySendOrderModel.call_name deleteMessages:NO];
    }
}



/**
 顶部视图显示状态
 
 @param show    显示跑秒时间
 @param content 显示的内容
 */
- (void)topViewLabShowType:(BOOL )show whihContent:(NSString *)content{
    
    
    if (show) {
        
        _payState.text = content;
        _timesLab.hidden = NO;
        _payState.hidden = NO;
        
        _payStateW.hidden = YES;
        [_stopWatchLabel setCountDownTime:_mySendOrderModel.bill_end_time];//多少秒 （1分钟 == 60秒）
        [_stopWatchLabel start];
        
    }else{
        
        _payStateW.text = content;
        _payStateW.hidden = NO;
        _timesLab.hidden = YES;
        _payState.hidden = YES;
        
    }
    
}


//时间到了
-(void)timerLabel:(WB_Stopwatch*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    
}

//开始倒计时
-(void)timerLabel:(WB_Stopwatch*)timerlabel
       countingTo:(NSTimeInterval)time
        timertype:(WB_StopwatchLabelType)timerType {
    //    NSLog(@"time:%f",time);
    
}











- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
