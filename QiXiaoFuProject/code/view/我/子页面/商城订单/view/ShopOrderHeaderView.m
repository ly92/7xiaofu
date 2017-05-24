//
//  ShopOrderHeaderView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderHeaderView.h"
#import "WB_Stopwatch.h"


@interface ShopOrderHeaderView ()<WB_StopWatchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *state1Lab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) WB_Stopwatch * stopWatchLabel;;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;

@end

@implementation ShopOrderHeaderView

+ (ShopOrderHeaderView *)shopOrderHeaderView{
    ShopOrderHeaderView *item = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    
    return item;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        
//        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopOrderHeaderView" owner:self options:nil] lastObject];
//        
//        _stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:_timeLab andTimerType:WBTypeTimer];
//        _stopWatchLabel.delegate = self;
//        [_stopWatchLabel setTimeFormat:@"HH:mm:ss"];
//    }
//    return self;
//}
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super initWithCoder:coder];
//    if (self) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopOrderHeaderView" owner:self options:nil] lastObject];
//
//        _stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:_timeLab andTimerType:WBTypeTimer];
//        _stopWatchLabel.delegate = self;
//        [_stopWatchLabel setTimeFormat:@"HH:mm:ss"];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopOrderHeaderView" owner:self options:nil] lastObject];

        _stopWatchLabel = [[WB_Stopwatch alloc]initWithLabel:_timeLab andTimerType:WBTypeTimer];
        _stopWatchLabel.delegate = self;
        [_stopWatchLabel setTimeFormat:@"mm:ss"];
        
    }
    return self;
}


- (void)setShopOrderModel:(ShopOrderModel *)shopOrderModel{
//    _shopOrderModel = shopOrderModel;
    
    //   state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】【6 退货换货中】
    
     [self orderStateWithState_type:shopOrderModel.state_type withTime:shopOrderModel.order_end_time order_id:shopOrderModel.order_id pay_sn:shopOrderModel.pay_sn order_price: shopOrderModel.order_amount];
    
    _orderPriceLab.text = [NSString stringWithFormat:@"订单金额: %@",shopOrderModel.order_amount];
    
}


- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{
//    _orderDetaileModel = orderDetaileModel;
    
    _orderPriceLab.text = [NSString stringWithFormat:@"订单金额: %@",orderDetaileModel.order_price];
    
    [self orderStateWithState_type:orderDetaileModel.state_type withTime:orderDetaileModel.order_end_time order_id:_order_id pay_sn:orderDetaileModel.pay_sn order_price:orderDetaileModel.order_price];
}


- (void)orderStateWithState_type:(NSInteger )type withTime:(NSInteger )order_end_time order_id:(NSString *)order_id pay_sn:(NSString *)pay_sn order_price:(NSString * )order_price{
    
    
    if (type == 0) {
         _state1Lab.text = @"已退货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
    
    }else if (type == 1) {
        _stateLab.text = @"待支付";
        _stateLab.hidden = NO;
        _state1Lab.hidden = YES;
        _timeLab.hidden = NO;
        [_stopWatchLabel setCountDownTime:order_end_time];//多少秒 （1分钟 == 60秒）
        [_stopWatchLabel start];
        
        
    }else if (type == 2){
        _state1Lab.text = @"待发货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        
    }else if (type == 3){
        
        _state1Lab.text = @"待收货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        
    }else if (type == 4){
        _state1Lab.text = @"已收货";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
 
    }else if (type == 5){
        _state1Lab.text = @"已完成";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
        
    }else if (type == 6){
        _state1Lab.text = @"退换货中";
        _state1Lab.hidden = NO;
        _stateLab.hidden = YES;
        _timeLab.hidden = YES;
        
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
