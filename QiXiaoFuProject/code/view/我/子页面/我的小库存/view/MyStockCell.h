//
//  MyStockCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStockModel.h"

@interface MyStockCell : UITableViewCell


@property (strong,nonatomic)NSIndexPath * indexPath;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeAdressBtn;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;

@property (strong, nonatomic) MyStockModel * myStockModel;


@end
