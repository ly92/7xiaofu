//
//  ShopPayAdressCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopPayAdressCell.h"

@interface ShopPayAdressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;
@property (weak, nonatomic) IBOutlet UIView *haveView;

@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UIButton *addAdressBtn;

@end


@implementation ShopPayAdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setShopCarClearingModel:(ShopCarClearingModel *)shopCarClearingModel{
     _shopCarClearingModel = shopCarClearingModel;
    
    
    Address_Info * adressInfo =shopCarClearingModel.address_info;
    
    if (adressInfo.address_id.length ==0) {
        
        _haveView.hidden = YES;
        _noView.hidden = NO;
        
    }else{
        _haveView.hidden = NO;
        _noView.hidden = YES;
        
        _nameLab.text = [NSString stringWithFormat:@"收货人: %@",shopCarClearingModel.address_info.true_name];
        _phoneLab.text = shopCarClearingModel.address_info.mob_phone;
        _adressLab.text = [NSString stringWithFormat:@"收货地址: %@%@",shopCarClearingModel.address_info.area_info,shopCarClearingModel.address_info.address];
    }
 
}


- (void)setAdressModel:(AdressModel *)adressModel{


    _adressModel = adressModel;
    
    
    if (adressModel.address_id.length ==0) {
        
        _haveView.hidden = YES;
        _noView.hidden = NO;
        
    }else{
        _haveView.hidden = NO;
        _noView.hidden = YES;
        
        _nameLab.text = [NSString stringWithFormat:@"收货人: %@",adressModel.true_name];
        _phoneLab.text = adressModel.mob_phone;
        _adressLab.text = [NSString stringWithFormat:@"收货地址: %@%@",adressModel.area_info,adressModel.address];
    }


}


- (void)setOrderDetaileModel:(OrderDetaileModel *)orderDetaileModel{

    _haveView.hidden = NO;
    _noView.hidden = YES;
    
    _nameLab.text = [NSString stringWithFormat:@"收货人: %@",orderDetaileModel.true_name];
    _phoneLab.text = orderDetaileModel.mob_phone;
    _adressLab.text = [NSString stringWithFormat:@"收货地址: %@",orderDetaileModel.address];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
