//
//  XieYiViewController.m
//  八爪鱼
//
//  Created by 冯洪建 on 16/1/2.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "XieYiViewController.h"

@interface XieYiViewController ()<UIWebViewDelegate>
{
    
    
}

@property (strong, nonatomic) UIWebView *serWebView;

@property (assign, nonatomic) NSString *url;


@end

@implementation XieYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  type;// 1 注册协议 2 操作手册  3 加入我们  4查看物流信息 5 关于我们
    
    if (_type == 1) {
        _url = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpXieyi];
    }
    
    if (_type == 2) {
        _url = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpMeHelp_body];
    }
    if (_type == 3) {
        _url = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpMeJoinWe ];
    }
    
    if (_type == 4) {
        _url = [NSString stringWithFormat:@"%@%@%@",HttpCommonURL,HttpShopLogisticsInfo,_orderId];
    }
    
    if (_type == 5) {
        _url = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpMeAboutWe];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self createSerTopAndCenterView];
    
}



- (void)createSerTopAndCenterView{
    
    _serWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - 64)];
    _serWebView.delegate = self;
    self.serWebView.scalesPageToFit = YES;
    self.serWebView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打 
    [self.view addSubview:_serWebView];
    
    NSURL * url=[NSURL URLWithString:_url];
    [_serWebView loadRequest:[NSURLRequest requestWithURL:url]];
        
}


//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    
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
