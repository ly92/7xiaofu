//
//  EngineerDetaileImageCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EngineerDetaileImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, assign ) NSInteger row;


@end
