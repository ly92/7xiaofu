//
//  OrderDetaileCancleCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileCancleCell.h"

@implementation OrderDetaileCancleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setBill_statu:(NSInteger )bill_statu{

    _bill_statu = bill_statu;

    _leftLeftBtn.hidden = YES;
    
    //  发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】
    switch (bill_statu) {
        case 0:
        {
//            [self topViewLabShowType:NO whihContent:@"已撤销"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            
            [_cancleBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderDetaileCancle_QuXiaoDingDan) {
                    _orderDetaileCancle_QuXiaoDingDan();
                }
            }];

        }
            break;
        case 1:
        {
            
            //  【1 待接单】   我的接单不会出现这种状态
            
        }
            break;
        case 2:
        {
            
//            [self topViewLabShowType:NO whihContent:@"已接单"];
            
            
            
            
            if (_t_state == 0 || _t_state == 4) {
                _leftBtn.hidden = NO;
                _cancleBtn.hidden = NO;
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderDetaileCancle_QuXiaoDingDan) {
                        _orderDetaileCancle_QuXiaoDingDan();
                    }
                }];
                
     
                [_cancleBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderDetaileCancle_QueRenWanCheng) {
                        _orderDetaileCancle_QueRenWanCheng();
                    }
                }];
                

            }
            else{
            
                _leftBtn.hidden = YES;
                _cancleBtn.hidden = NO;
                _cancleBtn.enabled = NO;
                [_cancleBtn setTitle:@"  等待客户确认完成  " forState:UIControlStateNormal];
                _cancleBtn.userInteractionEnabled = NO;
            }

            
        }
            break;
        case 3:
        {
            // 订单已完成
            
//            [self topViewLabShowType:NO whihContent:@"已完成"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            [_cancleBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderDetaileCancle_Delete) {
                    _orderDetaileCancle_Delete();
                }
            }];
            
            
        }
            break;
        case 4:
        {
            
//            [self topViewLabShowType:NO whihContent:@"已失效"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            [_cancleBtn setTitle:@"  取消  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                if (_orderDetaileCancle_QuXiaoDingDan) {
                    _orderDetaileCancle_QuXiaoDingDan();
                }
            }];
      
            
            
        }
            break;
        case 5:
        {
//            [self topViewLabShowType:NO whihContent:@"已取消"];
            
            // 删除
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            [_cancleBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderDetaileCancle_Delete) {
                    _orderDetaileCancle_Delete();
                }
            }];
  
            
            
        }
            break;
        case 6:
        {
//            [self topViewLabShowType:NO whihContent:@"调价中"];
            
            
            // 取消订单 --> 工程师取消发单
            
//            _leftBtn.hidden = NO;
//            [_leftBtn setTitle:@"  同意  " forState:UIControlStateNormal];
//            [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
//                
//                if (_orderDetaileCancle_TongYi) {
//                    _orderDetaileCancle_TongYi();
//                }
//            }];
//     
//            
//            
//            _cancleBtn.hidden = NO;
//            [_cancleBtn setTitle:@"不同意" forState:UIControlStateNormal];
//            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
//                
//                if (_orderDetaileCancle_BuTongYi) {
//                    _orderDetaileCancle_BuTongYi();
//                }
//            }];
            
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            [_cancleBtn setTitle:@"  等待工程师同意  " forState:UIControlStateNormal];
            _cancleBtn.userInteractionEnabled = NO;

            
        }
            break;
        case 7:// 补单
        {
            
            if (_pay_statu == 0) {
//                [self topViewLabShowType:YES whihContent:@"待支付"];
                [_leftBtn setTitle:@"  取消  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_orderDetaileCancle_cancle) {
                        _orderDetaileCancle_cancle();
                    }
                }];
                
                [_cancleBtn setTitle:@"  去支付  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderDetaileCancle_GoPay) {
                        _orderDetaileCancle_GoPay();
                    }
                }];
                
            }else{
                
//                [self topViewLabShowType:NO whihContent:@"补单"];
                
                _cancleBtn.hidden = NO;
                _leftBtn.hidden = YES;
                [_cancleBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderDetaileCancle_QueRenWanCheng) {
                        _orderDetaileCancle_QueRenWanCheng();
                    }
                }];
            }
        }
            break;
            
        case 8:
        {
            
            _leftBtn.hidden = NO;
            _cancleBtn.hidden = NO;
            _leftLeftBtn.hidden = NO;
            
            
            [_leftLeftBtn setTitle:@"  转移订单  " forState:UIControlStateNormal];
            [_leftLeftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderDetaileTransfer_Btn) {
                    _orderDetaileTransfer_Btn();
                }
            }];

            
            [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderDetaileCancle_QuXiaoDingDan) {
                    _orderDetaileCancle_QuXiaoDingDan();
                }
            }];
            
            [_cancleBtn setTitle:@"  开始工作  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_myReceivingOrderCellWithBtnKaishiGongzuo) {
                    _myReceivingOrderCellWithBtnKaishiGongzuo();
                }
            }];
            
            
            
        }
            break;

        default:
            break;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
