//
//  TransferOrderViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/12.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "TransferOrderViewController.h"
#import "AssociationViewController.h"
#import "AssociationViewControllerA.h"

@interface TransferOrderViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UILabel *receiverLbl;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;

@property (nonatomic, copy) NSString *receiver_id;
@property (nonatomic, copy) NSString *receiver_name;

@end

@implementation TransferOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transferBtn.layer.cornerRadius = 20;
    self.navigationItem.title = @"订单转移";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeHolderLbl.text = @"";
    self.placeHolderLbl.hidden = YES;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0){
        self.placeHolderLbl.text = @"请输入转移原因";
        self.placeHolderLbl.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


- (IBAction)chooseReceiver {
    UserInfoModel * user = [UserManager readModel];
    if ([user.member_level isEqualToString:@"A"]){
        AssociationViewControllerA * vc = [[AssociationViewControllerA alloc]initWithNibName:@"AssociationViewControllerA" bundle:nil];
        vc.isFromTrans = YES;
        vc.orderTransferBlock = ^(NSString *receiver_id, NSString *receiver_name) {
            self.receiverLbl.text = receiver_name;
            self.receiver_name = receiver_name;
            self.receiver_id = receiver_id;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AssociationViewController * vc = [[AssociationViewController alloc]initWithNibName:@"AssociationViewController" bundle:nil];
        vc.isFromTrans = YES;
        vc.orderTransferBlock = ^(NSString *receiver_id, NSString *receiver_name) {
            self.receiverLbl.text = receiver_name;
            self.receiver_name = receiver_name;
            self.receiver_id = receiver_id;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}


- (IBAction)transferAction {
    if (self.receiver_id.length == 0 || self.receiver_name.length == 0){
        [self showErrorText:@"请选择接收者"];
        return;
    }
    NSString *content = self.contentTF.text;
    if (content.length == 0){
        [self showErrorText:@"请输入转移原因"];
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"move_to_eng_id"] = self.receiver_id;//接受者的id
    params[@"id"] = self.orderId;//订单id
    params[@"move_to_eng_name"] = self.receiver_name;//接受者的昵称
    params[@"move_reason"] = content;
    [self showLoading];
    [MCNetTool postWithUrl:HttpTransferStartMove params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self dismissLoading];
        //转移成功后的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRANSFERSUCCESS" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [self showSuccessText:msg];
        
    } fail:^(NSString *error) {
        [self dismissLoading];
        [self showErrorText:error];
    }];
    
}

@end
