//
//  PurchaseShopStype2ViewController.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/6/29.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "PurchaseShopStype2ViewController.h"

@interface PurchaseShopStype2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *logisticsTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end

@implementation PurchaseShopStype2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sureBtn.layer.cornerRadius = 20;
    [self.logisticsTF becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureAction:(id)sender {
    
    NSString * content = self.logisticsTF.text;
    
    if(content.length == 0){
        
        [self showErrorText:@"请输入物流编码"];
        return;
    }
    [self showLoading ];
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"order_id"] = _order_id;
    params[@"fanhui_sn"] = content;
    params[@"type"] = self.refund_type;
    
    [MCNetTool postWithUrl:HttpShopAdd_refund_all2 params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self dismissLoading];
        [self showSuccessText:msg];
        if(_purchaseShopViewBlock){
            _purchaseShopViewBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSString *error) {
        [self dismissLoading];
        [self showErrorText:error];
    }];

    
}

@end
