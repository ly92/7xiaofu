//
//  ParentsViewController.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "ParentsViewController.h"
@interface ParentsViewController (){


}



@end

@implementation ParentsViewController


- (id)init {
    if (self = [super init]) {
    
 //        self.navigationController.navigationBar.translucent = NO;//设置导航栏半透明效果
//        
//
//        
//        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
//        {
//            //如果状态栏是不透明的，那么页面的布局默认是不会包含状态栏的，除非将这个属性设置成为YES
//            self.extendedLayoutIncludesOpaqueBars = NO;
//        }
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
           // 将edgesForExtendedLayout设置成UIRectEdgeNone，表明View是不要扩展到整个屏幕的。
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
//        if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)])
//        {
//            self.modalPresentationCapturesStatusBarAppearance = YES;
//        }
        if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        {
            /*
             这个属性用于如果页面是ScrollView或者UITableView，通常我们希望ScrollView或者UITableView内容显示是在UINavigation Bar下面。
             通过设置edgesForExtendedLayout = UIRectEdgeNone或者self.navigationController.navigationBar.translucent = NO;可以让view的布局从UINavigation Bar下面开始，不过一个副作用就是当页面滑动的时候，view是没有办法占据全屏的。
             self.automaticallyAdjustsScrollViewInsets == NO  就可以很好的完成这个需求
             
             */
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    
    [super awakeFromNib];

    //   2    在loadView之前的工作放在这里
}

- (void)viewDidLoad {
    //   3    注意，一个ViewController一个生命周期内这个函数只会调用一次
    [super viewDidLoad];
    
    [self navigationBarBGwithColor:[UIColor whiteColor] withTitleColor:[UIColor grayColor]];

//    self.view.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    


}


// 这个方法在子类中不要重写
-(void)viewDidAppear:(BOOL)animated{
    //   7  视图将要出现在屏幕上
    [super viewDidAppear:animated];

}


- (void)viewWillAppear:(BOOL)animated{
    //  4    view将要出现，每次View消失再出现都会调用
    [super viewWillAppear:animated];
   
}
-(void)viewWillLayoutSubviews{
    //  5     简要对子试图进行布局
    

}
-(void)viewDidLayoutSubviews{
    //  6   完成对子试图布局
    
}


- (void)viewWillDisappear:(BOOL)animated{
    //     8   View将要消失
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    //   9    View将要消失
    [super viewDidDisappear:animated];

}


- (void)navigationBarBGwithColor:(UIColor *)color withTitleColor:(UIColor *)titleColor {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if ( ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) ){
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
        }
    }
    else{
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:imge] atIndex:1];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:titleColor}];
    [UINavigationBar appearance].barTintColor=kBackgroundColor;
}

- (void)clearNavigationBarColoTitleColor:(UIColor*)color{

    [self navigationBarBGwithColor:[UIColor whiteColor] withTitleColor:color];
}

- (void)clearNavigationBarShadowImage{
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}












- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{// 10   这个函数通常也在生命周期的考虑范围内，当内存不足时候会调用，这时候应当进行适当的内存释放，不然IOS会强制关闭当前的APP
    [super didReceiveMemoryWarning];
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
