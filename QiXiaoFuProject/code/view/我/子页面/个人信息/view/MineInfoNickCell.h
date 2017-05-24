//
//  MineInfoNickCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoNickCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property(nonatomic, copy) void (^mineInfoNickCellBlock)(NSString * text);


@end
