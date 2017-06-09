//
//  EngineerDetaileHeaderCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EngineerDetaileModel.h"

@interface EngineerDetaileHeaderCell : UITableViewCell
@property (nonatomic, strong) EngineerDetaileModel *engineerDetaileModel;
@property (nonatomic, copy) NSString *to_user_name;

@end
