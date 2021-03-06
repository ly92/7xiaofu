//
//  SendOrderProjectNameCell.m
//  QiXiaoFuProject
//
//  Created by 付彦彰 on 17/5/10.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SendOrderProjectNameCell.h"

@interface SendOrderProjectNameCell()<UITextFieldDelegate>

@end

@implementation SendOrderProjectNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
  
    return self;
}

//初始化UI视图
-(void)initUI{

    self.projectNameLabel=[[UILabel alloc] init];
//    self.projectNameLabel.text=@"项目名称";
    self.projectNameLabel.textColor=YIWANG_DARK_GRAY_COLOR;
    self.projectNameLabel.font=[UIFont systemFontOfSize:14];
    [self.projectNameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.projectNameLabel];
    [self.projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10); //关键约束
    }];
    
    self.projectNameTextField=[[UITextField alloc] init];
    self.projectNameTextField.delegate=self;
    self.projectNameTextField.font = [UIFont systemFontOfSize:14.0];
    self.projectNameTextField.placeholder=@"如：IBM P595故障处理";
    self.projectNameTextField.borderStyle=UITextBorderStyleNone;
    self.projectNameTextField.keyboardType=UIKeyboardTypeDefault;
    self.projectNameTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.projectNameTextField];
    [self.projectNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.projectNameLabel.mas_right).offset(20);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10); //关键约束
        make.right.mas_equalTo(-20);
    }];
    
}

#pragma mark --UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textAlignment = NSTextAlignmentLeft;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.textAlignment = NSTextAlignmentRight;
    if (self.textFieldBlock) {
        self.textFieldBlock(textField.text);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
//    if (theTextField == self.projectNameTextField) {
//        [theTextField resignFirstResponder];
//    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
