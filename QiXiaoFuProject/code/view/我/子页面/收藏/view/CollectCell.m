//
//  CollectCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CollectCell.h"

@interface CollectCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *locBtn;

@end


@implementation CollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (showPrice){
        self.priceLab.hidden = NO;
    }else{
        self.priceLab.hidden = YES;
    }
}


- (void)setGood_list:(Goods_List *)good_list{

    [_iconImageView setImageWithUrl:good_list.goods_image_url placeholder:kDefaultImage_Z];
    _titleLab.text = good_list.goods_name;
    _priceLab.text = [NSString stringWithFormat:@"¥ %@",good_list.goods_price];
    
    if(good_list.area_name.length != 0){
        [_locBtn setTitle:good_list.area_name forState:UIControlStateNormal];
        _locBtn.hidden = NO;
     }else{
        _locBtn.hidden = YES;
     }
}


- (void)setCollectGoodModel:(CollectGoodModel *)collectGoodModel{


    [_iconImageView setImageWithUrl:collectGoodModel.goods_image_url placeholder:kDefaultImage_Z];
    _titleLab.text = collectGoodModel.goods_name;
    _priceLab.text = [NSString stringWithFormat:@"¥ %@",collectGoodModel.goods_price];
//    [_locBtn setTitle:collectGoodModel.area_name forState:UIControlStateNormal];


}



@end
