//
//  CommentReplyViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CommentReplyViewController.h"
#import "MCTextView.h"


@interface CommentReplyViewController ()
@property (weak, nonatomic) IBOutlet MCTextView *textView;

@end

@implementation CommentReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem .title = @"评论";
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"确认" target:self action:@selector(tureItemAction:)];
    self.navigationItem.leftBarButtonItem= [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancleItemAction:)];

    _textView.placeholder =@"请输入评论内容";
    
    [_textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)tureItemAction:(UIBarButtonItem *)item{

    if (_textView.text.length == 0) {
        [self showErrorText:@"请输入评论内容"];
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"parent_id"] = _parent_id;
     params[@"content"] = _textView.text;
    
    
    [MCNetTool postWithUrl:HttpMainAddReply params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self showSuccessText:msg];
        
        if (_commentReplyViewBlock) {
            _commentReplyViewBlock();
        }
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    

    
    

}

- (void)cancleItemAction:(UIBarButtonItem *)item{
    

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
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
