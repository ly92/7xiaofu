//
//  ChooseSeviceDomainCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowaddbillModel.h"

@interface ChooseSeviceDomainCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@property (nonatomic, strong) Service_Sector12* user;
@property (nonatomic) BOOL disabled;


@end
