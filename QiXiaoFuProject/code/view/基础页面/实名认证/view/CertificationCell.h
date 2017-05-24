//
//  CertificationCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@property (assign,nonatomic)NSInteger type; // type 1  姓名  2  身份证号码

@property(nonatomic, copy) void (^certificationCellBlock)(NSString  * content,BOOL pass);

@end
