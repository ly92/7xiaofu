//
//  LoginPassCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTextField.h"

@interface LoginPassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet MCTextField *passTextField;
@property(nonatomic, copy) void (^loginPassCellBlock)(NSString  * password,BOOL pass);


@end
