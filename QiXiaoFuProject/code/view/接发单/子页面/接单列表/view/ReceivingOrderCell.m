//
//  ReceivingOrderCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ReceivingOrderCell.h"



@interface ReceivingOrderCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *severContentLab;
@property (weak, nonatomic) IBOutlet UILabel *severTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *severAdressLab;
@property (weak, nonatomic) IBOutlet UILabel *severPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@end


@implementation ReceivingOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
//    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius=10;
    _bgView.clipsToBounds = YES;
    
    
    _iconImageView.layer.cornerRadius=14;
    _iconImageView.clipsToBounds = YES;
    // Initialization code
}


- (void)setProductModel:(ProductModel *)productModel{
    
    
    [_iconImageView setImageWithUrl:productModel.bill_user_avatar placeholder:kDefaultImage_header];
    
    _nameLab.text =productModel.bill_user_name;
    _timeLab.text = [Utool comment_timeStamp2TimeFormatter:productModel.inputtime];
    
    if (productModel.is_top==1) {
        _topBtn.hidden = NO;
    }else{
        _topBtn.hidden = YES;
    }
    _severContentLab.text = productModel.title;
    _severTimeLab.text =[NSString stringWithFormat:@"%@ - %@", [Utool timeStamp2TimeFormatter:productModel.service_stime], [Utool timeStamp2TimeFormatter:productModel.service_etime]];
    _severPriceLab.text = [NSString stringWithFormat:@"¥ %@",productModel.service_price];
    _severAdressLab.text =productModel.service_city;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
