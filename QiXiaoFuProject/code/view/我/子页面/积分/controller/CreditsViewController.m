//
//  CreditsViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/1.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *showRuleBtn;
@property (weak, nonatomic) IBOutlet UITextView *ruleTextView;
@property (weak, nonatomic) IBOutlet UILabel *reditsLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleViewH;

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的积分";
    
    [self loadReditsList];
    
    [_tableView headerAddMJRefresh:^{
        
        [self loadReditsList];
    }];
    
}


- (void)loadReditsList{
//    NSMutableDictionary * params = [NSMutableDictionary new];
//    params[@"userid"] = kUserId;
//    [MCNetTool postWithUrl:HttpMeMyUniAcc1 params:params success:^(NSDictionary *requestDic, NSString *msg) {
//        
//        [_tableView reloadData];
//        [_tableView headerEndRefresh];
//        
//    } fail:^(NSString *error) {
//        
//        [self showErrorText:error];
//        [_tableView headerEndRefresh];
//        
//    }];
    
}




#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditsTableViewCell"];

    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CreditsTableViewCell"];
    }
    
    cell.textLabel.text = @"签到送积分";
    cell.detailTextLabel.text = @"+5";
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.ruleViewH.constant = 45;
    self.showRuleBtn.selected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRuleAction {
    if (self.showRuleBtn.selected){
        self.ruleViewH.constant = 45;
    }else{
        self.ruleViewH.constant = 200;
    }
    self.showRuleBtn.selected = !self.showRuleBtn.selected;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self showRuleAction];
    return NO;
}



@end
