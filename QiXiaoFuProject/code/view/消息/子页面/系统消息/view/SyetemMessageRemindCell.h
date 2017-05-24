//
//  SyetemMessageRemindCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysTemMessageModel.h"

@interface SyetemMessageRemindCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *ignoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;

@property (strong, nonatomic) SysTemMessageModel *messageModel;


@property (strong, nonatomic) NSIndexPath *indexPath;


@end
