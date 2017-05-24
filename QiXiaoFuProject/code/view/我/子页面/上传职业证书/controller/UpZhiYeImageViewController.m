//
//  UpZhiYeImageViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "UpZhiYeImageViewController.h"
#import "MCTextView.h"
#import "UIViewController+XHPhoto.h"
#import "UIButton+SD.h"
#import "BlockUIAlertView.h"

@interface UpZhiYeImageViewController (){


    NSString * _imageUrl;

}
@property (weak, nonatomic) IBOutlet MCTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation UpZhiYeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"上传职业证书";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(trueItemAction:)];
    _textView.placeholder = @"请输入证书名称";
    
    
    if (_imageUrl) {
        [_btn imageWithUrlStr:_imageUrl phImage:[UIImage imageNamed:@"btn_camera"]];
        [_btn setBackgroundImage:nil forState:UIControlStateNormal];
     }
    
    
    if (_cer_id.length == 0) {
        _deleteBtn.hidden = YES;

    }else{
        _deleteBtn.hidden = NO;

    }
    
    
    _textView.text = _zhengshuname;
    [_btn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        [self.view endEditing:YES];
        
        [self showCanEdit:YES photo:^(UIImage *photo, NSData *imageData) {

            [_btn setImage:photo forState:UIControlStateNormal];


            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            
            [MCNetTool uploadDataWithURLStr:HttpMeUploadImage withDic:params imageKey:@"img" withData:imageData uploadProgress:^(float progress) {
                [self showProgress:progress];
            } success:^(NSDictionary *requestDic, NSString *msg) {
                
                [self showSuccessText:msg];
                _imageUrl =requestDic[@"img"];
                
                [_btn imageWithUrlStr:_imageUrl phImage:photo];

                
            } failure:^(NSString *error) {
                [self showErrorText:error];
            }];
            
        }];
        
        
    }];
    
    
    WEAKSELF
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)trueItemAction:(UIBarButtonItem *)item{

    NSString * content = _textView.text;
    
    if (content.length == 0) {
        [self showErrorText:@"请输入证书名称"];
        return;
    }
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"cer_image"] = _imageUrl;
    params[@"cer_name"] = content;
    params[@"depth"] = @(_depth);
    
    [MCNetTool postWithUrl:HttpMeUpdateMemberInfoCer params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        
        
        kTipAlert(@"证书上传成功\n我们将会在2-3个工作日完成审核");
        
 
        if (_upZhiYeImageViewControllerBlock) {
            _upZhiYeImageViewControllerBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    



}

- (IBAction)deleteBtnAction:(id)sender {
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"depth"] = _cer_id;
    
       [MCNetTool postWithUrl:HttpDelMemberInfoCer params:params success:^(NSDictionary *requestDic, NSString *msg) {
           [self showSuccessText:@"删除成功"];
        
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
