//
//  MySendOrderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MySendOrderCell.h"
#import "WB_Stopwatch.h"
#import "ChatViewController.h"


@interface MySendOrderCell()<WB_StopWatchDelegate>{


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



@implementation MySendOrderCell

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
        
        if (_mySendOrderCellWithBtnChat) {
            _mySendOrderCellWithBtnChat(_mySendOrderModel);
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
    
        
        /*  我的发单  */
        
        //  发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】【8 开始工作】
        switch (mySendOrderModel.bill_statu) {
            case 0:
            {
                
                [self topViewLabShowType:NO whihContent:@"已撤销"];
                _rightBtn.hidden = NO;
                _leftBtn.hidden = YES;
                [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_mySendOrderCellWithBtnState_Delete) {
                        _mySendOrderCellWithBtnState_Delete(mySendOrderModel,_indexPath);
                    }
                }];
            }
                break;
            case 1:
            {
                //   【1 待接单】
                _chatBtn.hidden = YES;
                [self deleateChatlistWithUserPhone:nil];

                if (mySendOrderModel.pay_statu == 0) {// 未支付
                    
                    [self topViewLabShowType:YES whihContent:@"待支付"];
                    _leftBtn.hidden = NO;
                    _rightBtn.hidden = NO;

                    [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                    [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        if (_mySendOrderCellWithBtnState_cancle) {
                            _mySendOrderCellWithBtnState_cancle(mySendOrderModel);
                        }
                    }];
                    
                    [_rightBtn setTitle:@"  去支付  " forState:UIControlStateNormal];
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_GoPay) {
                            _mySendOrderCellWithBtnState_GoPay(mySendOrderModel);
                        }
                    }];
                                   
                }else{
                    
                // 已支付
                    
                    [self topViewLabShowType:NO whihContent:@"待接单"];
                    
                    //  取消订单
                    
                    _leftBtn.hidden = YES;
                    _rightBtn.hidden = NO;
                    [_rightBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                    
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_QuXiaoDingDan) {
                            _mySendOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                        }
                    }];
                    
                }
                
                
            }
                break;
            case 2:
            {
                
                [self topViewLabShowType:NO whihContent:@"已接单"];
                
                
                
                //  工程师完成状态【0 未完成】【1 已完成】
                if(mySendOrderModel.t_state ==0 ){
                
                    _leftBtn.hidden = YES;
                    _rightBtn.hidden = NO;
                    [_rightBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                    
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_QuXiaoDingDan) {
                            _mySendOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                        }
                    }];

                }else if(mySendOrderModel.t_state ==4 ){
                    
                    
                    _leftBtn.hidden = YES;
                    _rightBtn.hidden = NO;
                    [_rightBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                    
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_QuXiaoDingDan) {
                            _mySendOrderCellWithBtnState_QuXiaoDingDan(mySendOrderModel);
                        }
                    }];
                    
                    
                } else if(mySendOrderModel.t_state == 1){
                
                    //   确认完成
                    _leftBtn.hidden = NO;
                    _rightBtn.hidden = NO;
                    [_leftBtn setTitle:@"  未完成  " forState:UIControlStateNormal];
                    [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_orderSendDetaileCancle_WeiWanCheng) {
                            _orderSendDetaileCancle_WeiWanCheng(mySendOrderModel);
                        }
                    }];
                    
                    
                    [_rightBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                    [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_QueRenWanCheng) {
                            _mySendOrderCellWithBtnState_QueRenWanCheng(mySendOrderModel);
                        }
                    }];
                
                }

                
            }
                break;
            case 3:
            {
                // 订单已完成
                
                

                _rightBtn.hidden = NO;
                _leftBtn.hidden = NO;
                
                _chatBtn.hidden = YES;
                [self deleateChatlistWithUserPhone:nil];

                
                if ([mySendOrderModel.is_eval intValue] == 0) {
                    [self topViewLabShowType:NO whihContent:@"已完成"];
                    [_leftBtn setTitle:@"  评价  " forState:UIControlStateNormal];
                    [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_Comment) {
                            _mySendOrderCellWithBtnState_Comment(mySendOrderModel);
                        }
                    }];

                }else{
                    [self topViewLabShowType:NO whihContent:@"已评价"];
                    [_leftBtn setTitle:@"  查看评价  " forState:UIControlStateNormal];
                    [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                        
                        if (_mySendOrderCellWithBtnState_SeeComment) {
                            _mySendOrderCellWithBtnState_SeeComment(mySendOrderModel);
                        }
                    }];

                 }

                
                [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_mySendOrderCellWithBtnState_Delete) {
                        _mySendOrderCellWithBtnState_Delete(mySendOrderModel,_indexPath);
                    }
                }];
                
             
            }
                break;
            case 4:
            {
                
                [self topViewLabShowType:NO whihContent:@"已失效"];
                
                
                // 撤回   重新发布
                 _rightBtn.hidden = NO;
                _leftBtn.hidden = NO;
                [_leftBtn setTitle:@"  撤销  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_mySendOrderCellWithBtnState_CheHui) {
                        _mySendOrderCellWithBtnState_CheHui(mySendOrderModel);
                    }
                    
                }];
                
                 [_rightBtn setTitle:@"  重新发布  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_mySendOrderCellWithBtnState_ChongXinFaBu) {
                        _mySendOrderCellWithBtnState_ChongXinFaBu(mySendOrderModel);
                    }
                }];
     
            }
                break;
            case 5:
            {
                [self topViewLabShowType:NO whihContent:@"已取消"];
                
                
                // 删除
                _rightBtn.hidden = NO;
                _leftBtn.hidden = YES;
                _chatBtn.hidden = YES;
                [self deleateChatlistWithUserPhone:nil];

                [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
                [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_mySendOrderCellWithBtnState_Delete) {
                        _mySendOrderCellWithBtnState_Delete(mySendOrderModel,_indexPath);
                    }
                }];
            
            }
                break;
            case 6:
            {
                [self topViewLabShowType:NO whihContent:@"调价中"];
                
                _rightBtn.hidden = NO;
                _leftBtn.hidden = YES;
                [_rightBtn setTitle:@"  等待工程师同意  " forState:UIControlStateNormal];
                _rightBtn.userInteractionEnabled = NO;
             
                
                // 取消订单 --> 工程师取消发单
                
            }
                break;
            case 7:// 补单
            {
                
                _chatBtn.hidden = YES;
                // 我的发单不会出现  补单状态
                [self deleateChatlistWithUserPhone:nil];
                
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
