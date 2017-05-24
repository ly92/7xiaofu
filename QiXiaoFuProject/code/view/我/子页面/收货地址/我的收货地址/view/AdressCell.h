//
//  AdressCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/20.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressModel.h"

@interface AdressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *defaultAdressBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@property (strong, nonatomic)AdressModel * adressModel;

@property (strong, nonatomic)NSIndexPath * indexPath;



@end
