//
//  CertificationViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "CertificationViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "CertificationCell.h"
#import "CertificationFooterView.h"
#import "UIViewController+XHPhoto.h"
#import "CertificationSuccViewController.h"
#import "NSString+Utils.h"
#import "CertificationModel.h"
#import "UIButton+WebCache.h"

@interface CertificationViewController (){

    NSString * _name;
    NSString * _idCard;
    
    NSString * _real_img1;
    NSString * _real_img2;
    
    
}
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) CertificationModel *certificationModel;
@property (nonatomic, strong) CertificationFooterView * footerView;
@end

@implementation CertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    
    [_tableView registerNib:[UINib nibWithNibName:@"CertificationCell" bundle:nil] forCellReuseIdentifier:@"CertificationCell"];
    
    
    UIView * footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    footer.backgroundColor = [UIColor clearColor];
    CertificationFooterView * footerView = [CertificationFooterView certificationFooterView];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 300);
    [footer addSubview:footerView];
    _footerView = footerView;
    _tableView.tableFooterView = footer;;
    
    if (_is_real == 1) {
        footerView.submitBtn.enabled = NO;
        footerView.tailBtn.enabled = NO;
        footerView.frontBtn.enabled = NO;
        [footerView.submitBtn setTitle:@"已实名认证" forState:UIControlStateDisabled];
        
    }
    
    
    

    [footerView.submitBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        [self updateMyRealRequest];
    }];
    //上传图片的按钮
    [footerView.frontBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
    
        
        [self showCanEdit:YES photo:^(UIImage *photo,NSData * imageData) {
            
 
            [footerView.frontBtn setBackgroundImage:photo forState:UIControlStateNormal];
            
            
            [self uploadImageData:imageData isFan:NO];
            
        }];
        
    }];
    [footerView.tailBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        [self showCanEdit:YES photo:^(UIImage *photo,NSData * imageData) {
            
            [footerView.tailBtn setBackgroundImage:photo forState:UIControlStateNormal];
            [self uploadImageData:imageData isFan:YES];

        }];
        
    }];
    
    
    [self loadMyRealInfo];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)cancelAction:(UIBarButtonItem *)item{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - 加载身份认证信息
- (void)loadMyRealInfo{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
 
    [MCNetTool postWithCacheUrl:HttpMeShowMyReal params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _certificationModel = [CertificationModel mj_objectWithKeyValues:requestDic];
        
        
         _name = _certificationModel.member_truename;
         _idCard = _certificationModel.id_card;
        _real_img1 = _certificationModel.real_img1;
         _real_img2= _certificationModel.real_img2;
        
        
        [_footerView.frontBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_certificationModel.real_img1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_uploadcamera"]];
        [_footerView.tailBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_certificationModel.real_img2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btn_uploadcamera"]];
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}




#pragma mark - 提交用户身份信息
- (void)updateMyRealRequest{

    if (_name.length == 0) {
        [self showErrorText:@"请输入姓名"];
        return;
    }

    if (![_idCard checkUserIdCard]) {
        [self showErrorText:@"请输入正确的身份证号"];
        return;
    }
    if (_real_img1.length == 0) {
        [self showErrorText:@"请上传身份证正面图片"];
        return;
    }
    if (_real_img2.length == 0) {
        [self showErrorText:@"请上传身份证反面图片"];
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"member_truename"] = _name;
    params[@"id_card"] = _idCard;
    params[@"real_img1"] = _real_img1;
    params[@"real_img2"] = _real_img2;
    
    
    [MCNetTool postWithUrl:HttpMeUpdateMyReal params:params success:^(NSDictionary *requestDic, NSString *msg) {

        CertificationSuccViewController * vc = [[CertificationSuccViewController alloc]initWithNibName:@"CertificationSuccViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];

        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}
#pragma mark - 上传图片
- (void)uploadImageData:(NSData *)imageData isFan:(BOOL )isfan{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    [self showLoading];
    
    [MCNetTool uploadDataWithURLStr:HttpMeUploadImage withDic:params imageKey:@"img" withData:imageData uploadProgress:^(float progress) {
        [self showProgress:progress];
    } success:^(NSDictionary *requestDic, NSString *msg) {
        
        
        [self dismissLoading];
        
        if (isfan) {
            _real_img2 =requestDic[@"img"];
        }else{
            _real_img1 =requestDic[@"img"];
        }
        
    } failure:^(NSString *error) {
        [self showErrorText:error];
    }];


}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CertificationCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CertificationCell"];
        cell.contentTextField.placeholder = @"请输入真实姓名";
        cell.type = 1;
        
        if (_is_real == 1) {
            cell.contentTextField.enabled = NO;
        }else{
            cell.contentTextField.enabled = YES;
        }
        

        if (_certificationModel.member_truename.length != 0) {
            cell.contentTextField.text =_certificationModel.member_truename;
        }
        cell.certificationCellBlock = ^(NSString * content ,BOOL pass){
            
            _name = content;
            
        };
        return cell;
    }
    if (indexPath.row == 1) {
        CertificationCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CertificationCell"];
        cell.type = 2;
        
        if (_is_real == 1) {
            cell.contentTextField.enabled = NO;
        }else{
            cell.contentTextField.enabled = YES;
        }

        cell.contentTextField.placeholder = @"请输入身份证号码";
        cell.contentTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if (_certificationModel.id_card.length != 0) {
            cell.contentTextField.text =_certificationModel.id_card;
        }
        cell.certificationCellBlock = ^(NSString * content ,BOOL pass){
            _idCard = content;
            
        };
        return cell;
    }
    
    
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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
