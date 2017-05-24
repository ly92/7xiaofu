//
//  OrderDetaileCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileCell.h"

@interface OrderDetaileCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPayLab;



@end


@implementation OrderDetaileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{
    
 
    _orderNumLab.text =orderDetaileModel.order_sn;
    _orderTimeLab.text =[Utool systemMessage_timeStamp2TimeFormatter:orderDetaileModel.add_time];
    _orderPayLab.text =orderDetaileModel.payment_name;

    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
