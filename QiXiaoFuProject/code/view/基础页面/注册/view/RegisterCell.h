//
//  RegisterCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyButton.h"

@interface RegisterCell : UITableViewCell

@property (nonatomic, copy) NSString *account;
@property (weak, nonatomic) IBOutlet VerifyButton *verifyBtn;

@property(nonatomic, copy) void (^registerCellBlock)(NSString  * verify,BOOL pass);

@property(nonatomic, copy) void (^registerCodeCellBlock)();


@end
