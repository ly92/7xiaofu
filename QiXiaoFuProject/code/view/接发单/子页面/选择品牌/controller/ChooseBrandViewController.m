//
//  ChooseBrandViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseBrandViewController.h"
#import "MCTextView.h"

@interface ChooseBrandViewController ()
@property (weak, nonatomic) IBOutlet MCTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *vgView;

@end

@implementation ChooseBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"品牌型号";
    
    
    [_vgView setBorder:[[UIColor grayColor] colorWithAlphaComponent:0.3] width:0.5];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(addBrandItem:)];
    _textView.placeholder = @"请输入品牌型号。品牌型号之间以空格作为区分";
    
    _textView.text = _service_brand;
//    [_textView becomeFirstResponder];

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 确定按钮
- (void)addBrandItem:(UIBarButtonItem *)item{

    if (_textView.text.length == 0) {
        [self showErrorText:@"请输入内容"];
        return;
    }
    
    
    if (_chooseBrandViewBlock) {
        _chooseBrandViewBlock(_textView.text);
    }
     [self.navigationController popViewControllerAnimated:YES];
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
