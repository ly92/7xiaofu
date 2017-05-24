//
//  ShopOrderFooterView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderFooterView.h"

@interface ShopOrderFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end



@implementation ShopOrderFooterView

+ (ShopOrderFooterView *)shopOrderFooterView{
    ShopOrderFooterView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    return item;
}




- (void)setShopOrderModel:(ShopOrderModel *)shopOrderModel{
    _shopOrderModel = shopOrderModel;
    
    
    //   state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】
    [self orderStateWithState_type:shopOrderModel.state_type withTime:shopOrderModel.order_end_time order_id:shopOrderModel.order_id pay_sn:shopOrderModel.pay_sn order_price: shopOrderModel.order_amount order_sn:shopOrderModel.order_sn];
}


- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{
    _orderDetaileModel = orderDetaileModel;
    
    [self orderStateWithState_type:orderDetaileModel.state_type withTime:orderDetaileModel.order_end_time order_id:_order_id pay_sn:orderDetaileModel.pay_sn order_price:orderDetaileModel.order_price order_sn:orderDetaileModel.order_sn] ;
}


- (void)orderStateWithState_type:(NSInteger )type withTime:(NSInteger )order_end_time order_id:(NSString *)order_id pay_sn:(NSString *)pay_sn order_price:(NSString * )order_price order_sn:(NSString *)order_sn {
    
    
    
    if (type == 0){
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
        
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellDeleateBlock) {
                _shopOrderCellDeleateBlock(order_id,_indexPath);
            }
        }];
        
        
    }else if (type == 1) {
 
         _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
        [_leftBtn setTitle:@"  取消  " forState:UIControlStateNormal];
        [_rightBtn setTitle:@"    支付    " forState:UIControlStateNormal];
        
        [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellCancleBlock) {
                _shopOrderCellCancleBlock(order_id,_indexPath);
            }
        }];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellPayBlock) {
                _shopOrderCellPayBlock(order_id,pay_sn,order_price,_indexPath);
            }
        }];
        
    }else if (type == 2){
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  提醒发货  " forState:UIControlStateNormal];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellTiXingFaHuoBlock) {
                _shopOrderCellTiXingFaHuoBlock(order_sn,_indexPath);
            }
        }];
        
    }else if (type == 3){
        
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  确认收货  " forState:UIControlStateNormal];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellQueRenShouHuoBlock) {
                _shopOrderCellQueRenShouHuoBlock(order_id,_indexPath);
            }
        }];
        
    }else if (type == 4){
        
        
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
        [_leftBtn setTitle:@"  删除  " forState:UIControlStateNormal];
        [_rightBtn setTitle:@"  退换货  " forState:UIControlStateNormal];
        
        [_leftBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellDeleateBlock) {
                _shopOrderCellDeleateBlock(order_id,_indexPath);
            }
        }];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellTuiHuanHuoBlock) {
                _shopOrderCellTuiHuanHuoBlock(order_id,_indexPath);
            }
        }];
        
        
    }else if (type == 5){
        
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
        
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellDeleateBlock) {
                _shopOrderCellDeleateBlock(order_id,_indexPath);
            }
        }];
        
    }else if (type == 6){
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
         [_rightBtn setTitle:@"  等待商家处理  " forState:UIControlStateNormal];
        
    }
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
