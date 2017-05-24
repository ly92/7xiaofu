//
//  BaseNavigationBar.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "BaseNavigationBar.h"

@implementation BaseNavigationBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //  在这里改变 导航栏 左右按钮的位置
    for (UIButton *button in self.subviews) {
        if (![button isKindOfClass:[UIButton class]]) continue;
        
        if (button.centerX < self.frame.size.width * 0.5) { // 左边的按钮
            button.x = 5;
        }
//        else if (button.centerX > self.width * 0.5) { // 右边的按钮
//            button.x = self.width - button.width;
//        }
    }
}

@end
