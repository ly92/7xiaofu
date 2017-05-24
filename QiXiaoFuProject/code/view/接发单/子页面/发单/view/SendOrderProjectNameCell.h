//
//  SendOrderProjectNameCell.h
//  QiXiaoFuProject
//
//  Created by 付彦彰 on 17/5/10.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrderProjectNameCell : UITableViewCell

@property(nonatomic, strong)UILabel *projectNameLabel;

@property(nonatomic, strong)UITextField *projectNameTextField;

//输入框完成选择的回调
@property(nonatomic, copy)void(^textFieldBlock)(NSString *text);

@end
