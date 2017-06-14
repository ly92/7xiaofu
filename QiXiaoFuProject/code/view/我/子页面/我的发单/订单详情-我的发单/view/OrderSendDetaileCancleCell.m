//
//  OrderSendDetaileCancleCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/11/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderSendDetaileCancleCell.h"

@implementation OrderSendDetaileCancleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    // Initialization code
}

- (void)setOrderDetaileProModel:(OrderDetaileProModel *)orderDetaileProModel{
    _orderDetaileProModel = orderDetaileProModel;
    NSInteger bill_statu = orderDetaileProModel.bill_statu;
    //  发单状态【0 撤销】【1 待接单】【2 已接单】【3 已完成】【4 已过期 or 已失效】【5 已取消】【6 调价中】【7 补单】【8 开始工作】
    _leftLeftBtn.hidden = YES;
    switch (bill_statu) {
        case 0:
        {
            //            [self topViewLabShowType:NO whihContent:@"已撤销"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            
            [_cancleBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderSendDetaileCancle_Delete) {
                    _orderSendDetaileCancle_Delete();
                }
            }];
            
        }
            break;
        case 1:
        {
            
            //  【1 待接单】
            
            //                [self topViewLabShowType:YES whihContent:@"待接单"];
            
            
            if (orderDetaileProModel.pay_statu == 0) {// 未支付
                
                _leftBtn.hidden = NO;
                _cancleBtn.hidden = NO;
                
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_orderSendDetaileCancle_cancle) {
                        _orderSendDetaileCancle_cancle();
                    }
                }];
                
                [_cancleBtn setTitle:@"  去支付  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_GoPay) {
                        _orderSendDetaileCancle_GoPay();
                    }
                }];
                
                
            }else{
                
                // 已支付
                
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_orderSendDetaileCancle_cancle) {
                        _orderSendDetaileCancle_cancle();
                    }
                }];
                
                [_cancleBtn setTitle:@"  调价  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_Tiaojia) {
                        _orderSendDetaileCancle_Tiaojia(btn);
                    }
                }];
                
                
            }
            
            //调价中
            if ([orderDetaileProModel.is_change_price intValue] == 1){
                _cancleBtn.hidden = NO;
                _leftBtn.hidden = YES;
                [_cancleBtn setTitle:@"  等待工程师同意  " forState:UIControlStateNormal];
                _cancleBtn.userInteractionEnabled = NO;
            }
            
        }
            break;
        case 2:
        {
            
            //            [self topViewLabShowType:NO whihContent:@"已接单"];
            
            if(orderDetaileProModel.t_state == 0){
                
                _leftBtn.hidden = NO;
                _cancleBtn.hidden = NO;
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_cancle) {
                        _orderSendDetaileCancle_cancle();
                    }
                }];
                [_cancleBtn setTitle:@"  调价  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_Tiaojia) {
                        _orderSendDetaileCancle_Tiaojia(btn);
                    }
                    
                }];
            }
            else if(orderDetaileProModel.t_state ==4 ){
                
                _leftBtn.hidden = NO;
                _cancleBtn.hidden = NO;
                [_leftBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_cancle) {
                        _orderSendDetaileCancle_cancle();
                    }
                }];
                [_cancleBtn setTitle:@"  调价  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_Tiaojia) {
                        _orderSendDetaileCancle_Tiaojia(btn);
                    }
                    
                }];
                
            }
            else{
                
                _leftBtn.hidden = NO;
                _cancleBtn.hidden = NO;
                [_leftBtn setTitle:@"  未完成  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_WeiWanCheng) {
                        _orderSendDetaileCancle_WeiWanCheng();
                    }
                }];
                [_cancleBtn setTitle:@"  确认完成  " forState:UIControlStateNormal];
                [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_QueRenWanCheng) {
                        _orderSendDetaileCancle_QueRenWanCheng();
                    }
                }];
            }
            
            //调价中
            if ([orderDetaileProModel.is_change_price intValue] == 1){
                _cancleBtn.hidden = NO;
                _leftBtn.hidden = YES;
                [_cancleBtn setTitle:@"  等待工程师同意  " forState:UIControlStateNormal];
                _cancleBtn.userInteractionEnabled = NO;
            }
        }
            break;
        case 3:
        {
            // 订单已完成
            
            //                        [self topViewLabShowType:NO whihContent:@"已完成"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = NO;
            
            if ([orderDetaileProModel.is_eval intValue] == 0) {
                [_leftBtn setTitle:@"  评价  " forState:UIControlStateNormal];
                
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    
                    if (_orderSendDetaileCancle_Comment) {
                        _orderSendDetaileCancle_Comment();
                    }
                }];
                
            }else{
                [_leftBtn setTitle:@"  查看评价  " forState:UIControlStateNormal];
                [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_orderSendDetaileSee_Comment) {
                        _orderSendDetaileSee_Comment();
                    }
                    
                }];
            }
            
            
            [_cancleBtn setTitle:@"  删除  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                
                if (_orderSendDetaileCancle_Delete) {
                    _orderSendDetaileCancle_Delete();
                }
            }];
            
            //备件使用
            if (orderDetaileProModel.goods.count > 0){
                _leftLeftBtn.hidden = NO;
                [_leftLeftBtn setTitle:@"  所用备件  " forState:UIControlStateNormal];
                [_leftLeftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                    if (_orderSendDetaileUsedGoods_Btn) {
                        _orderSendDetaileUsedGoods_Btn();
                    }
                }];
            }else{
                _leftLeftBtn.hidden = YES;
            }
            
            
        }
            break;
        case 4:
        {
            
            //            [self topViewLabShowType:NO whihContent:@"已失效"];
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = NO;
            [_leftBtn setTitle:@"  撤销  " forState:UIControlStateNormal];
            [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                if (_orderSendDetaileCancle_CheHui) {
                    _orderSendDetaileCancle_CheHui();
                }
            }];
            [_cancleBtn setTitle:@"  重新发布  " forState:UIControlStateNormal];
            [_cancleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
                if (_orderSendDetaileCancle_ChongXinFaBu) {
                    _orderSendDetaileCancle_ChongXinFaBu();
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
                
                if (_orderSendDetaileCancle_Delete) {
                    _orderSendDetaileCancle_Delete();
                }
            }];
            
            
            
        }
            break;
        case 6:
        {
            // 调价中
            
            _cancleBtn.hidden = NO;
            _leftBtn.hidden = YES;
            [_cancleBtn setTitle:@"  等待工程师同意  " forState:UIControlStateNormal];
            _cancleBtn.userInteractionEnabled = NO;
            
        }
            break;
        case 7:// 补单
        {
            
        }
            break;
        default:
            break;
    }
    
}

//- (void)setBill_statu:(NSInteger )bill_statu{
//    
//    _bill_statu = bill_statu;
//    
//    
//    
//    
//}
//



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
