//
//  BaseNavigationController.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseNavigationBar.h"
#import "UIViewController+BSNavigationExtension.h"

// 打开边界多少距离才出发pop
#define DISTANCE_TO_POP 80

@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//
//  // 替换为自定义的导航栏(用于修改导航栏左右按钮的位置)
    [self setValue:[[BaseNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    
    self.interactivePopGestureRecognizer.enabled = YES;
//

//    UINavigationBar *navBar=[UINavigationBar appearance];
//    //2.设置导航栏字体的颜色
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSShadowAttributeName:[NSValue valueWithUIOffset:UIOffsetZero]}];
//    [navBar setBarTintColor:[UIColor whiteColor]];
//    navBar.tintColor = [UIColor blackColor];
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
//    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
    
}


//- (void)navigationBarBGwithColor:(UIColor *)color withTitleColor:(UIColor *)titleColor {
//    
//    CGRect rect = CGRectMake(0, 0, 1, 1);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,[color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage * imge = [[UIImage alloc] init];
//    imge = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    if ( ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) ){
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
//            [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
//        }
//    }
//    else{
//        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:imge] atIndex:1];
//    }
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:titleColor}];
//}
//
//- (void)clearNavigationBarColoTitleColor:(UIColor*)color{
//    
//    [self navigationBarBGwithColor:[UIColor whiteColor] withTitleColor:color];
//}
//
//- (void)clearNavigationBarShadowImage{
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//}










- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) //设置该条件是避免跟tableview的删除，筛选界面展开的左滑事件有冲突
    {
        return NO;
    }
    
    return YES;
}


#pragma mark - event response 事件相应


#pragma mark - private methods 私有方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count > 0) {
        // 1.自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;

        //设置导航栏的返回按钮
        UIImage *backButtonImage =viewController.bs_navigationController.backButtonImage;
        if (!backButtonImage) {
            backButtonImage = [UIImage imageNamed:@"btn_back"];
        }
        backButtonImage = [backButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
        viewController.navigationItem.leftBarButtonItem = backButton;
     }

    [super pushViewController:viewController animated:animated];
//    //开启iOS7的滑动返回效果
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.delegate = nil;
//    }
}



- (void)didTapBackButton {
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
