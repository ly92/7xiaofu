//
//  XCFTextField.m
//  XCFApp
//
//  Created by rkxt_ios on 15/12/4.
//  Copyright © 2015年 ST. All rights reserved.
//

#import "MCTextField.h"


@interface MCTextField ()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;
@end

@implementation MCTextField



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.password = @"";
    
    __weak MCTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification
                                                                                  object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                                                      if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
                                                                                          weakSelf.text = @"";
                                                                                          [weakSelf insertText:weakSelf.password];
                                                                                      }
                                                                                  }];
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification
                                                                                object:nil queue:nil usingBlock:^(NSNotification *note) {
                                                                                    if (weakSelf == note.object) {
                                                                                        weakSelf.password = weakSelf.text;
                                                                                        [weakSelf insertText:weakSelf.password];
                                                                                     }
                                                                                }];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    BOOL isFirstResponder = self.isFirstResponder;
//    [self resignFirstResponder];
    [super setSecureTextEntry:secureTextEntry];
    if (isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}


//  禁用 长按菜单  （copy 粘贴 等）
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if ([UIMenuController sharedMenuController]) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


+ (MCTextField *)textFieldWithFrame:(CGRect)frame
                         placeholder:(NSString *)placeholder
{
    MCTextField *textField = [[MCTextField alloc]initWithFrame:frame];
    [textField setPlaceholder:placeholder];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setFont:[UIFont systemFontOfSize:15]];
//    [textField setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
     return textField;
}
@end
