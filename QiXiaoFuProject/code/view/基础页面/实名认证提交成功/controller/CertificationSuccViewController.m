//
//  CertificationSuccViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CertificationSuccViewController.h"

@interface CertificationSuccViewController ()

@end

@implementation CertificationSuccViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交成功";
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backMainBtnAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
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
