//
//  ShopOrderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopOrderCell.h"
#import "WB_Stopwatch.h"

@interface ShopOrderCell()<WB_StopWatchDelegate>


@property (strong, nonatomic) WB_Stopwatch * stopWatchLabel;;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *pricelab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;




@end


@implementation ShopOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    


    // Initialization code
}


- (void)setShopOrderModel:(ShopOrderModel *)shopOrderModel{
    _shopOrderModel = shopOrderModel;
    
    
//   state_type;//订单状态 【空字符串 所有订单】【1，待付款】【2，已支付】【3，待收货】【4，待评价】【5，已完成】【21，发货前取消订单】

    Order_List * order_List =shopOrderModel.order_list[_indexPath.row];
    [_iconImageView setImageWithUrl:order_List.goods_image placeholder:kDefaultImage_Z];
    _titleLab.text = order_List.goods_name;
    _numLab.text = [NSString stringWithFormat:@"x%@",order_List.goods_num];
    _pricelab.text = [NSString stringWithFormat:@"¥ %@",order_List.goods_price];
    
}


- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{
    _orderDetaileModel = orderDetaileModel;
    
    Goodss_List * goodss_List =orderDetaileModel.goods_list[_indexPath.row];
    [_iconImageView setImageWithUrl:goodss_List.goods_img placeholder:kDefaultImage_Z];
    _titleLab.text = goodss_List.goods_name;
    _numLab.text = [NSString stringWithFormat:@"x%@",goodss_List.goods_num];
    _pricelab.text = [NSString stringWithFormat:@"¥ %@",goodss_List.goods_pay_price];

    
}










- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
