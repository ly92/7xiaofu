//
//  EngineerTureOrderFinishCheckCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EngineerTureOrderFinishCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;


@property(nonatomic, copy) void (^checkBtnCellBlobk)(NSInteger type);// type 1  未使用 2 使用了


@end
