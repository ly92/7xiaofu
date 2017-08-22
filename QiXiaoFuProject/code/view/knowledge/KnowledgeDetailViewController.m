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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)priseAction {
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"post_id"] = [self.dict objectForKey:@"post_id"];
    
    [MCNetTool postWithUrl:@"tp.php/Home/RepositoryType/upvote" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    [self.iconImgV setImageWithUrl:[dict objectForKey:@"user_avatar"] placeholder:kDefaultImage_header];
    self.nameLbl.text = [dict objectForKey:@"nik_name"];
    self.titleLbl.text = [dict objectForKey:@"post_title"];
    NSString *content = [dict objectForKey:@"post_content"];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kScreenWidth-16, MAXFLOAT)];
    self.contentLbl.text = content;
    
    self.scrollContentVH.constant = size.height + 160;
    NSDate *time = [NSDate dateFromString:[dict objectForKey:@"input_time"]];
    if ([time isToday]){
        if ([time hoursBeforeDate:[NSDate date]] > 0){
            self.timeLbl.text = [NSString stringWithFormat:@"%ld小时前",(long)[time hoursBeforeDate:[NSDate date]]];
        }else if ([time minutesBeforeDate:[NSDate date]] > 0){
            self.timeLbl.text = [NSString stringWithFormat:@"%ld分钟前",(long)[time minutesBeforeDate:[NSDate date]]];
        }else{
            self.timeLbl.text = @"刚刚";
        }
    }else if ([time isYesterday]){
        self.timeLbl.text =  [NSString stringWithFormat:@"昨天 %@",[Utool messageIndex_timeStamp2TimeFormatter:[dict objectForKey:@"input_time"]]];
    }else{
        self.timeLbl.text = [Utool timeStampPointTimeFormatter:[dict objectForKey:@"input_time"]];
    }

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
