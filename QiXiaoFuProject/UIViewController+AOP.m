//
//  UIViewController+AOP.m
//  QiXiaoFuProject
//
//  Created by mac on 16/11/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/runtime.h>


@implementation UIViewController (AOP)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        swizzleMethod(class, @selector(viewDidLoad), @selector(aop_viewDidLoad));
        swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
    });
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)   {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (void)aop_viewDidAppear:(BOOL)animated {
    [self aop_viewDidAppear:animated];
    
    
}

-(void)aop_viewWillAppear:(BOOL)animated {
    [self aop_viewWillAppear:animated];
    
    NSArray * vcs = self.navigationController.viewControllers;
    // 当前应用名称
    NSString *appCurName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    __block NSString * titleString = appCurName;
    [vcs enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        titleString = [NSString stringWithFormat:@"%@ -> %@",titleString,obj.navigationItem.title];
    }];
    
    [MobClick beginLogPageView:titleString];//("PageOne"为页面名称，可自定义)

    
}
-(void)aop_viewWillDisappear:(BOOL)animated {
    [self aop_viewWillDisappear:animated];
 
    NSArray * vcs = self.navigationController.viewControllers;
    // 当前应用名称
 
    NSString *appCurName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    __block NSString * titleString = appCurName;
    [vcs enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        titleString = [NSString stringWithFormat:@"%@ -> %@",titleString,obj.navigationItem.title];
    }];
    
    [MobClick endLogPageView:titleString];//("PageOne"为页面名称，可自定义)

    
}
- (void)aop_viewDidLoad {
    [self aop_viewDidLoad];
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self;
        nav.navigationBar.translucent = NO;
        nav.navigationBar.barTintColor = [UIColor blueColor];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        NSDictionary *titleAtt = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [[UINavigationBar appearance] setTitleTextAttributes:titleAtt];
        [[UIBarButtonItem appearance]
         setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
         forBarMetrics:UIBarMetricsDefault];
    }
    //    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}



@end
