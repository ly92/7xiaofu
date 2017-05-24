//
//  FeedbackViewController.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "FeedbackViewController.h"
#import "MCTextView.h"
//#import "BangPhoneVC.h"


@interface FeedbackViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet MCTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submintBtn;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    
    
    _textView.layer.cornerRadius = 8;
    _textView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    _textView.placeholder = @"请输入大于10少于150字的评价";
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [[[UIColor grayColor]colorWithAlphaComponent:0.7] CGColor];
     _textView.completionBlock = ^(NSString * text){
    
        LxDBAnyVar(text);
        [self wordLimit:text];

    };
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(NSString *)text{
    if (text.length < 150) {
         self.textView.editable = YES;
    }
    else{
        self.textView.editable = NO;
     }
    return nil;
}



- (IBAction)submintBtnAction:(id)sender {
    
    
    NSString * text = _textView.text;
    
    if (text.length == 0 ) {
        [self showText:@"请输入您的宝贵意见"];
        return;
    }
    if (text.length < 10) {
        [self showText:@"请至少输入10个字的内容"];
        return;
    }
//    if (kPhone.length == 0) {
//         // 绑定手机号码
//        BangPhoneVC * bangPhoneViewController = [[BangPhoneVC alloc]initWithNibName:@"BangPhoneVC" bundle:nil];
//        [self.navigationController pushViewController:bangPhoneViewController animated:YES];
//         return;
//    }
//    
//    [MCNetTool postWithUrl:kFeedback params:kFeedbackParam(kUserId, kUserName, kPhone, text) hud:YES success:^(NSDictionary *requestDic, NSString *msg) {
//        [self showSuccessText:msg];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } fail:^(NSString *error) {
//        [self showFailureText:error];
//    }];
    
 
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
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
