//
//  ShopPayInfoCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopPayInfoCell.h"
#import "PPNumberButton.h"

@interface ShopPayInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *goodsCountLab;


@property (weak, nonatomic) IBOutlet UIView *addSubView;
@property (nonatomic, strong)  PPNumberButton *numberButton;
@end



@implementation ShopPayInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _addSubView.backgroundColor = [UIColor clearColor];
    
//    _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
//    _numberButton.input = YES;
//    _numberButton.shakeAnimation = NO;
//    [_numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"increase_normal@2x"] decreaseImage:[UIImage imageNamed:@"decrease_normal@2x"]];
//    
//    WEAKSELF
//    _numberButton.numberBlock = ^(NSString *num){
//        DeLog(@"%@",num);
//        
//        [weakSelf editShopCarGoodsCount:num];
//        
//    };
//    
//    [_addSubView addSubview:_numberButton];

    
    // Initialization code
}

- (void)setCart_List:(Cart_List *)cart_List{
    
    
    _cart_List = cart_List;
    
    self.titleLab.text = cart_List.goods_name	;
    
    self.priceLab.text = [NSString stringWithFormat:@"¥ %@",cart_List.goods_price];
    
    [self.iconImageView setImageWithUrl:cart_List.goods_image_url placeholder:kDefaultImage_Z];
 
//    _numberButton.currentNumber = [NSString stringWithFormat:@"%@",@(cart_List.goods_num)];
    
    
    _goodsCountLab.text = [NSString stringWithFormat:@"数量 x %@",@(cart_List.goods_num)];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end






