//
//  SignInViewController.m
//  QiXiaoFuProject
//
//  Created by 李勇 on 2017/6/1.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UILabel *line4;
@property (weak, nonatomic) IBOutlet UILabel *line5;
@property (weak, nonatomic) IBOutlet UILabel *line6;

@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;
@property (weak, nonatomic) IBOutlet UILabel *lbl5;
@property (weak, nonatomic) IBOutlet UILabel *lbl6;
@property (weak, nonatomic) IBOutlet UILabel *lbl7;
@property (weak, nonatomic) IBOutlet UIView *subview;


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"签到";
    
    [self setupSubViewsLayouts];
}

- (void)setupSubViewsLayouts{
    self.signinBtn.layer.cornerRadius = 50;
    self.lbl1.layer.cornerRadius = 10;
    self.lbl2.layer.cornerRadius = 10;
    self.lbl3.layer.cornerRadius = 10;
    self.lbl4.layer.cornerRadius = 10;
    self.lbl5.layer.cornerRadius = 10;
    self.lbl6.layer.cornerRadius = 10;
    self.lbl7.layer.cornerRadius = 10;
    
    for (UIView *view in self.subview.subviews) {
        view.backgroundColor = [UIColor grayColor];
    }
    
}

- (void)setColorWithIndex:(NSInteger)index{
    
    for (int i = 0; i < index * 2 -1; i ++) {
        UIView *view = self.subview.subviews[i];
        view.backgroundColor = [UIColor orangeColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signAction {
    [self setColorWithIndex:5];
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
