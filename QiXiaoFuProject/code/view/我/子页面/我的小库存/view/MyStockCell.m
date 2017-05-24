//
//  MyStockCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MyStockCell.h"

@interface MyStockCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *serialLab;



@end


@implementation MyStockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
  
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;

    _cancelBtn.tag = _indexPath.section;
    _changeAdressBtn.tag = _indexPath.section;

}


- (void)setMyStockModel:(MyStockModel *)myStockModel{

    [_iconimageView setImageWithUrl:myStockModel.goods_image placeholder:kDefaultImage_Z];
    _nameLab.text = myStockModel.goods_name;
    _serialLab.text = myStockModel.goods_sn;
    [_adressBtn setTitle:[NSString stringWithFormat:@" %@",myStockModel.area_name] forState:UIControlStateNormal];
    _numLab.text = [NSString stringWithFormat:@"数量 %@",myStockModel.goods_num];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
