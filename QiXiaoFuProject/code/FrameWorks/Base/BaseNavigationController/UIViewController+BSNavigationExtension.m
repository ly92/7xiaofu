//
//  UIViewController+BSNavigationExtension.m
//  ScreenShotBack
//
//  Created by mac on 16/5/11.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "UIViewController+BSNavigationExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (BSNavigationExtension)
- (BaseNavigationController *)bs_navigationController{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setBs_navigationController:(BaseNavigationController *)bs_navigationController{
    objc_setAssociatedObject(self, @selector(bs_navigationController), bs_navigationController, OBJC_ASSOCIATION_RETAIN);
}

@end
