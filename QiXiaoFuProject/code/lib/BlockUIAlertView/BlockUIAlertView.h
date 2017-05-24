//
//  BlockUIAlertView.h
//  ywqc
//
//  Created by Jin XuDong on 13-5-31.
//  Copyright (c) 2013年 紫平方. All rights reserved.
//  带block的alertview

#import <UIKit/UIKit.h>

typedef void(^AlertsBlock)(NSInteger buttonIndex);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)AlertsBlock alertBlock;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertsBlock)_alertBlock
  otherButtonTitles:(NSString *)otherButtonTitles;




@end
