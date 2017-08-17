//
//  EnrollEngineerCell.h
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/17.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnrollEngineerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@property(nonatomic, copy) void (^selectedEngineerBlock)();//选择工程师

@end
