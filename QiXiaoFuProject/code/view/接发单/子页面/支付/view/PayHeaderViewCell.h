//
//  PayHeaderViewCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayHeaderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *severContentLab;
@property (weak, nonatomic) IBOutlet UILabel *severTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *severAdressLab;

@property (weak, nonatomic) IBOutlet UILabel *severPriceLab;

@property (weak, nonatomic) IBOutlet UILabel *zhidingPriceLab;
@end
