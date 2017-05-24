//
//  CommentViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CommentViewController.h"
#import "MCTextView.h"
#import "LPLevelView.h"

@interface CommentViewController (){

    CGFloat _level;
}
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet MCTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"评价";
    
    _textView.placeholder = @"请输入评价内容";
    
    
    LPLevelView *lView = [LPLevelView new];
    lView.frame = CGRectMake(10, 150, (kScreenWidth - 20)/3*2, _starView.frame.size.height);
    lView.iconColor = [UIColor colorWithRed:0.97 green:0.78 blue:0.30 alpha:1.00];
    lView.iconSize = CGSizeMake(30, 30);
    lView.canScore = YES;
    lView.animated = YES;
    lView.level = 0;
    lView.levelInt = YES;
    [lView setScoreBlock:^(float level) {
        NSLog(@"打分：%f", level);
        
        _level = level;
        
    }];
    [_starView addSubview:lView];
    
    lView.centerY = 26;
    
    
    WEAKSELF
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)submitBtnAction:(id)sender {
    
    
    NSString * content = _textView.text;
    
    if (content.length == 0) {
        [self showErrorText:@"请输入评论内容"];
        return;
    }

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"id"] = _f_id;
    params[@"stars"] = @(_level);
    params[@"content"] = _textView.text;
    
    
    [MCNetTool postWithUrl:HttpMeAddEngEvaluation params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self showSuccessText:msg];
        
        
        if (_commentViewBlock) {
            _commentViewBlock();
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
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
