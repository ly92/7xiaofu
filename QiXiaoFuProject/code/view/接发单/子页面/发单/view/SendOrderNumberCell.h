//
//  SendOrderNumberCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderNumberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextField *numTextField;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, copy) void (^numTextFieldBlock)(NSString * number);


@property(nonatomic, copy) void (^textFieldBlock)(NSString * text);



@end
