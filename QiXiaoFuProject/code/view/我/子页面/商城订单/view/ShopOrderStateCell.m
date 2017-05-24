//
//  ShopOrderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderStateCell.h"
#import "WB_Stopwatch.h"

@interface ShopOrderStateCell()<WB_StopWatchDelegate>


@property (strong, nonatomic) WB_Stopwatch * stopWatchLabel;;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *state1Lab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;


@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@end


@implementation ShopOrderStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:_timeLab andTimerType:WBTypeTimer];
    _stopWatchLabel.delegate = self;
    [_stopWatchLabel setTimeFormat:@"mm:ss"];
//    [_stopWatchLabel setCountDownTime:1000];//多少秒 （1分钟 == 60秒）
//    [_stopWatchLabel start];

    // Initialization code
}


- (void)setShopOrderModel:(ShopOrderModel *)shopOrderModel{
    _shopOrderModel = shopOrderModel;
    
    
//   state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】

    
    
    Order_List * order_List =shopOrderModel.order_list[_indexPath.row];
    [_iconImageView setImageWithUrl:order_List.goods_image placeholder:kDefaultImage_Z];
    _titleLab.text = order_List.goods_name;
    _numLab.text = [NSString stringWithFormat:@"数量 %@",order_List.goods_num];
    _pricelab.text = [NSString stringWithFormat:@"¥ %@",shopOrderModel.order_amount];
    
    [self orderStateWithState_type:shopOrderModel.state_type withTime:shopOrderModel.order_end_time order_id:shopOrderModel.order_id pay_sn:shopOrderModel.pay_sn order_price: shopOrderModel.order_amount order_sn:shopOrderModel.order_sn];
}

- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{
    _orderDetaileModel = orderDetaileModel;
    
    Goodss_List * goodss_List =orderDetaileModel.goods_list[_indexPath.row];
    [_iconImageView setImageWithUrl:goodss_List.goods_img placeholder:kDefaultImage_Z];
    _titleLab.text = goodss_List.goods_name;
    _numLab.text = [NSString stringWithFormat:@"数量 %@",goodss_List.goods_num];
    _pricelab.text = [NSString stringWithFormat:@"¥ %@",goodss_List.goods_pay_price];

    [self orderStateWithState_type:orderDetaileModel.state_type withTime:orderDetaileModel.order_end_time order_id:_order_id pay_sn:orderDetaileModel.pay_sn order_price:orderDetaileModel.order_price order_sn:_orderDetaileModel.order_sn];
}


- (void)orderStateWithState_type:(NSInteger )type withTime:(NSInteger )order_end_time order_id:(NSString *)order_id pay_sn:(NSString *)pay_sn order_price:(NSString * )order_price order_sn:(NSString *)order_sn{

    if (type == 0) {
    
        _state1Lab.text = @"已退货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  删除  " forState:UIControlStateNormal];
        
         [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellDeleateBlock) {
                _shopOrderCellDeleateBlock(order_id,_indexPath);
            }
        }];
        
        
        
        
    }else
    
    if (type == 1) {
        _stateLab.text = @"待支付";
        _stateLab.hidden = NO;
        _state1Lab.hidden = YES;
        _timeLab.hidden = NO;
        [_stopWatchLabel setCountDownTime:order_end_time];//多少秒 （1分钟 == 60秒）
        [_stopWatchLabel start];
        
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
        _state1Lab.text = @"待发货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  提醒发货  " forState:UIControlStateNormal];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellTiXingFaHuoBlock) {
                _shopOrderCellTiXingFaHuoBlock(order_sn,_indexPath);
            }
        }];
        
        
    }else if (type == 3){
        
        _state1Lab.text = @"待收货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
        [_rightBtn setTitle:@"  确认收货  " forState:UIControlStateNormal];
        [_rightBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            if (_shopOrderCellQueRenShouHuoBlock) {
                _shopOrderCellQueRenShouHuoBlock(order_id,_indexPath);
            }
        }];
        
    }else if (type == 4){
        
        _state1Lab.text = @"已收货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        
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

        
    }
    
}

//时间到了
-(void)timerLabel:(WB_Stopwatch*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    

}
//开始倒计时
-(void)timerLabel:(WB_Stopwatch*)timerlabel
       countingTo:(NSTimeInterval)time
        timertype:(WB_StopwatchLabelType)timerType {
    NSLog(@"time:%f",time);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
