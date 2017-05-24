//
//  AdressCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AdressCell.h"

@interface AdressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;



@end


@implementation AdressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    // Initialization code
}

- (void)setAdressModel:(AdressModel *)adressModel{

    _adressModel = adressModel;
    
    _nameLab.text = adressModel.true_name;
    _phonelab.text = adressModel.mob_phone;
    _adressLab.text = adressModel.address;
    
    if (adressModel.is_default == 1) {
        _defaultAdressBtn.selected = YES;
         _defaultAdressBtn.userInteractionEnabled = NO;

    } else {
        _defaultAdressBtn.selected = NO;
        _defaultAdressBtn.userInteractionEnabled = YES;
     }

}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _defaultAdressBtn.tag =indexPath.section;
    _deleteBtn.tag =indexPath.section;
    _editBtn.tag =indexPath.section;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


/*
 
 

 */
