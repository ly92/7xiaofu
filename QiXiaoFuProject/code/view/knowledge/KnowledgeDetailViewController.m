//
//  KnowledgeDetailViewController.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/22.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "KnowledgeDetailViewController.h"

@interface KnowledgeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentVH;

@end

@implementation KnowledgeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconImgV.layer.cornerRadius = 20;
    [self loadDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)priseAction {
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"post_id"] = self.postId;
    
    [MCNetTool postWithUrl:@"tp.php/Home/RepositoryType/upvote" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        self.praiseBtn.enabled = NO;
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}

- (void)loadDetailData{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"post_id"] = self.postId;
    
    [MCNetTool postWithUrl:@"tp.php/Home/RepositoryType/postinfo" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self.iconImgV setImageWithUrl:[requestDic objectForKey:@"user_avatar"] placeholder:kDefaultImage_header];
        self.nameLbl.text = [requestDic objectForKey:@"nik_name"];
        self.titleLbl.text = [requestDic objectForKey:@"post_title"];
        NSString *content = [requestDic objectForKey:@"post_content"];
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kScreenWidth-16, MAXFLOAT)];
        self.contentLbl.text = content;
        
        self.scrollContentVH.constant = size.height + 180;
        NSDate *time = [NSDate dateFromString:[requestDic objectForKey:@"input_time"]];
        if ([time isToday]){
            if ([time hoursBeforeDate:[NSDate date]] > 0){
                self.timeLbl.text = [NSString stringWithFormat:@"%ld小时前",(long)[time hoursBeforeDate:[NSDate date]]];
            }else if ([time minutesBeforeDate:[NSDate date]] > 0){
                self.timeLbl.text = [NSString stringWithFormat:@"%ld分钟前",(long)[time minutesBeforeDate:[NSDate date]]];
            }else{
                self.timeLbl.text = @"刚刚";
            }
        }else if ([time isYesterday]){
            self.timeLbl.text =  [NSString stringWithFormat:@"昨天 %@",[Utool messageIndex_timeStamp2TimeFormatter:[requestDic objectForKey:@"input_time"]]];
        }else{
            self.timeLbl.text = [Utool timeStampPointTimeFormatter:[requestDic objectForKey:@"input_time"]];
        }
        
        if ([[requestDic objectForKey:@"upvote_state"] integerValue] == 1){
            self.praiseBtn.enabled = NO;
        }
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
    
    

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
