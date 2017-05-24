//
//  AboutViewController.m
//  PrettyFactoryProject
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AboutViewController.h"
#import "AppManager.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versonLab;

@property (weak, nonatomic) IBOutlet UILabel *descLab;


 @end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";


    _versonLab.text = [NSString stringWithFormat:@"七小服_v%@",[[AppManager sharedManager] getCurrentVerison]];
    
    _descLab.text = @"copyright©七小服(北京)网络科技有限公司";
    
    // Do any additional setup after loading the view from its nib.
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
