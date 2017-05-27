//
//  BaseViewController.m
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "BaseViewController.h"
#import "CLAnimationView.h"
#import "ShareModel.h"
#import "SVProgressHUD.h"
#import "UIApplication+category.h"

@interface BaseViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation BaseViewController
- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
//    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
//    [self.view addGestureRecognizer:_tapRecognizer];
//    _endEditingWhenTap = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatLogon:) name:@"repeatLogon" object:nil];

    
    
    
}



- (void)repeatLogon:(id)noti{

    [Utool verifyLogin:self LogonBlock:^{
        
    }];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
//    NSArray * vcs = self.navigationController.viewControllers;
//   __block NSString * titleString;
//    [vcs enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        titleString = [NSString stringWithFormat:@"%@ -> %@",titleString,obj.navigationItem.title];
//    }];
//    
//    [MobClick beginLogPageView:titleString];//("PageOne"为页面名称，可自定义)
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    NSArray * vcs = self.navigationController.viewControllers;
//    __block NSString * titleString;
//    [vcs enumerateObjectsUsingBlock:^(UIViewController * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        titleString = [NSString stringWithFormat:@"%@ -> %@",titleString,obj.navigationItem.title];
//    }];
//    [MobClick endLogPageView:titleString];//("PageOne"为页面名称，可自定义)
    [self.view endEditing:YES];
    
    //隐藏所有的SVProgressHUD
    [SVProgressHUD dismiss];

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
 }




#pragma mark - setter

- (void)setEndEditingWhenTap:(BOOL)endEditingWhenTap
{
    if (_endEditingWhenTap != endEditingWhenTap) {
        _endEditingWhenTap = endEditingWhenTap;
        
        if (_endEditingWhenTap) {
            [self.view addGestureRecognizer:self.tapRecognizer];
        }
        else{
            [self.view removeGestureRecognizer:self.tapRecognizer];
        }
    }
}

#pragma mark - action

- (void)tapViewAction:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}


-(void)shareWithUMengWithVC:(UIViewController *)vc withImage:(UIImage *)image withID:(NSString *)detaileId  withTitle:(NSString *)title withDesc:(NSString *)desc withShareUrl:(NSString *)shareUrl withType:(NSInteger)type{
    

//    NSArray *titleArray = @[@"朋友圈",@"微信好友",@"手机QQ",@"QQ空间",@"新浪微博"];
    NSArray *titleArray = @[@"",@"",@"",@"",@""];

    NSArray *imageArr = @[@"share_icon_wechat",@"share_icon_circle",@"share_icon_qq",@"share_icon_qzone",@"share_icon_sina",];
    
    CLAnimationView *animationView = [[CLAnimationView alloc]initWithTitleArray:titleArray picarray:imageArr];
    [animationView selectedWithIndex:^(NSInteger index,id shareType) {
        DeLog(@"你选择的index ＝＝ %ld",(long)index);
        
        
        UIImage * shareImage = [UIImage imageNamed:@"icon"];
        
        if (image) {
            shareImage = image;
        }
        
        
        [ShareModel shareUMengWithVC:vc withPlatform:index-1 withTitle:title withShareTxt:desc withImage:shareImage withID:detaileId withType:type withUrl:shareUrl success:^(NSDictionary *requestDic) {
            
        } failure:^(NSString *error) {
            
            
        }];
     }];
    [animationView CLBtnBlock:^(UIButton *btn) {
        
        DeLog(@"你点了选择/取消按钮");
    }];
    [animationView show];

    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     
     NSCache * cache =   [[NSCache alloc]init];
    [cache removeAllObjects];
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
