//
//  ShopPaySuccViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopPaySuccViewController.h"
#import "OrderDetaileViewController.h"

@interface ShopPaySuccViewController ()

@end

@implementation ShopPaySuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"支付成功";
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)backShopMainBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)goShopOrderDetaileBtnAction:(id)sender {
    
    OrderDetaileViewController * vc  = [[OrderDetaileViewController alloc]initWithNibName:@"OrderDetaileViewController" bundle:nil];
    vc.order_id = _order_id;
    [self.navigationController pushViewController:vc animated:YES];

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
