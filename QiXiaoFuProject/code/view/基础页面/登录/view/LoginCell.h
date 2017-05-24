//
//  LoginCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property(nonatomic, copy) void (^loginCellBlock)(NSString  * account,BOOL pass);



@end
