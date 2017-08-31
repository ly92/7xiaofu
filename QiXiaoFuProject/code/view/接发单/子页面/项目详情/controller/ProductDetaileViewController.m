//
//  ProductDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ProductDetaileViewController.h"
#import "ProductDetaileHeaderCell.h"
#import "ProductDetaileCell.h"
#import "ProductDetail1TableViewCell.h"
#import "ProductDetaileFooterView.h"
#import "BlockUIAlertView.h"
#import "OrderDetailViewController.h"
#import "ProductDetaileModel.h"
#import "CertificationViewController.h"
#import "OrderDetailImageCell.h"
#import "CommentListViewController.h"


static NSString * const kSeverName = @"项目名称";
static NSString * const kSeverLY = @"服务领域";
static NSString * const kSeverPP = @"品牌型号";
static NSString * const kSeverNumber = @"数量单位";
static NSString * const kSeverXS = @"服务形式";
static NSString * const kSeverLX = @"服务类型";
static NSString * const kSeverTime = @"预约服务时间";
static NSString * const kSeverQY = @"服务区域";
//static NSString * const kSeverOtherQY = @"其他服务领域";
static NSString * const kSeverMark = @"备注  ";
static NSString * const kSeverPrice = @"服务价格";




@interface ProductDetaileViewController (){


    UIImage * _shareImage;// 分享的图片
    
    NSInteger  _sectionNum;// 用于区分  是否有图片


}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) ProductDetaileModel *productDetaileModel;
@property (nonatomic, strong) ProductDetaileFooterView *footerView;


@property (nonatomic, strong) UIButton * chatBtn;


@end

@implementation ProductDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"项目详情";
    
    
    _sectionNum = 0;
    
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_share" highImage:@"icon_share" target:self action:@selector(shareItemAction:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"查看评价" target:self action:@selector(customerEvaluation)];
    
    _titles = @[kSeverName,kSeverLY,kSeverPP,kSeverNumber,kSeverXS,kSeverLX,kSeverTime,kSeverQY,kSeverMark,kSeverPrice];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值

    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetaileCell" bundle:nil] forCellReuseIdentifier:@"ProductDetaileCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetail1TableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductDetail1TableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderDetailImageCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailImageCell"];

    
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _footerView = [ProductDetaileFooterView productDetaileFooterView];
    _footerView.frame = footView.bounds;
    [footView addSubview:_footerView];
    
    [_footerView.recevingOrderBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
         [Utool verifyLogin:self LogonBlock:^{
             [self receivingOrderRequest];
        }];
 
    }];
    
    _tableView.tableFooterView = footView;
    
     [self loadOrderDetaile];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (_p_id.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//查看对客户的评价
- (void)customerEvaluation{
    //10.216.2.11/tp.php/Home/Index/clientCommentList?token_time=1495890416122&token=947cab2a352912d08485f2a7049fe4f9&curpage=1&member_id=990
    CommentListViewController * vc   =[[CommentListViewController alloc]initWithNibName:@"CommentListViewController" bundle:nil];
    vc.member_id = _productDetaileModel.bill_user_id;
    vc.type = 1;
    vc.isCustomer = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//查看是否已报名
- (void)checkEnroll{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"bill_id"] = _p_id;
    
    [MCNetTool postWithCacheUrl:@"tp.php/Home/Member/isenroll" params:params success:^(NSDictionary *requestDic, NSString *msg) {
        if ([requestDic[@"state"] integerValue] == 1) {
            _footerView.hidden = YES;
        }else{
            _footerView.hidden = NO;
        }
    } fail:^(NSString *error) {
    }];

}

#pragma mark - 加载项目详情
- (void)loadOrderDetaile{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"id"] = _p_id;
    
    
    [self showLoading];
    [MCNetTool postWithCacheUrl:HttpMainProductDetalie params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _productDetaileModel = [ProductDetaileModel mj_objectWithKeyValues:requestDic];
        
        
        if (_productDetaileModel.image.count == 0) {
            _sectionNum = 0;
        }else{
            _sectionNum = 1;
        }
        
        [UIImage loadImageWithUrl:_productDetaileModel.bill_user_avatar returnImage:^(UIImage *image) {
            _shareImage = image;
        }];
        
        
        if (_productDetaileModel.button_type == 0) {
            _footerView.hidden = YES;
        }else{
            //检查是否已报名
            [self checkEnroll];
        }
        
        [self dismissLoading];
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];


}





#pragma mark - 接单请求
- (void)receivingOrderRequest{

    //询问是否确定报名
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"\n确定报名\n" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"bill_id"] = _p_id;
            params[@"bill_user_id"] = _productDetaileModel.bill_user_id;
            params[@"enroll_mobile"] = kPhone;
            
            [MCNetTool postWithUrl:HttpMainEnrollBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"报名成功！"];
                //刷新数据
                //检查是否已报名
                [self checkEnroll];
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"确定"];
    [alert show];
    
    /*
     *
     *接单-暂时隐藏该功能
     *
     *
    //询问是否确定接单
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"\n确定接单\n" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"id"] = _p_id;
            
            
            [MCNetTool postWithUrl:HttpMainTakeBill params:params success:^(NSDictionary *requestDic, NSString *msg) {
                
                NSInteger state = [requestDic[@"state"] integerValue];
                
                NSString * pro_id = requestDic[@"bill_id"];
                
                // 【1】 接单成功 【2 项目已被抢走】【3 不能接自己发布的项目】【4 没有进行实名认证】【5 订单生成失败，后台逻辑错误】
                
                if ( state == 1) {
                    
                    [self receivingOrderSucc:pro_id];
                    _p_id = @"";
                    
                }else if (state ==2){
                    
                    [self receivingOrderFailure];
                    
                    
                }else if (state ==3){
                    
                    [self showErrorText:@"不能接自己发布的项目"];
                    
                }else if (state ==4){
                    
                    [self goCertification];
                    
                }else if (state ==5){
                    [self showErrorText:@"接单失败"];
                }
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
    } otherButtonTitles:@"确定"];
    [alert show];
    
    */


}

#pragma mark - 接单成功
- (void)receivingOrderSucc:(NSString *)pro_id{

    
    // 接单成功  重新请求项目详情，改变项目的状态
    [self loadOrderDetaile];

    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"接单成功" message:@"\n恭喜你接单成功,现在要去查看订单吗?\n" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
        
            OrderDetailViewController * vc = [[OrderDetailViewController alloc]initWithNibName:@"OrderDetailViewController" bundle:nil];
             vc.pro_id =pro_id;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
        
            [self .navigationController popViewControllerAnimated:YES];
        
        }
        
        
    } otherButtonTitles:@"查看"];
    [alert show];


}
#pragma mark - 接单失败
- (void)receivingOrderFailure{
    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"接单失败" message:@"\n不好意思,订单被别人抢走了,再去转转吧\n" cancelButtonTitle:nil clickButton:^(NSInteger buttonIndex) {
        
        
    } otherButtonTitles:@"我知道了"];
    [alert show];

    
}

- (void)goCertification{

    
    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您尚未进行实名认证,认证之后才能接单,要立即去认证吗?" cancelButtonTitle:@"先等等" clickButton:^(NSInteger buttonIndex) {
        
        if(buttonIndex == 1){
            
            CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

        }
        
    } otherButtonTitles:@"去认证"];
    [alert show];


}


#pragma mark - 分享
- (void)shareItemAction:(UIBarButtonItem *)item{
    
    [self shareWithUMengWithVC:self withImage:nil withID:nil
                     withTitle:@"七小服"
                      withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];

}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    if (section==2) {
        return _sectionNum;
    }
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section ==0){
        ProductDetaileHeaderCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetaileHeaderCell"];
        [cell.iconImageView setImageWithUrl:_productDetaileModel.bill_user_avatar placeholder:kDefaultImage_header];
        cell.timeLab.text = [Utool comment_timeStamp2TimeFormatter:_productDetaileModel.inputtime];
        cell.nameLab.text = _productDetaileModel.bill_user_name;
        if (_productDetaileModel.bill_statu ==0) {
            [cell.stateBtn setTitle:@"撤销" forState:UIControlStateNormal];
        }else if (_productDetaileModel.bill_statu ==1) {
            if (_footerView.hidden){
                [cell.stateBtn setTitle:@"已报名" forState:UIControlStateNormal];
            }else{
                [cell.stateBtn setTitle:@"报名中" forState:UIControlStateNormal];
            }
        }else if (_productDetaileModel.bill_statu ==2) {
            [cell.stateBtn setTitle:@"已接单" forState:UIControlStateNormal];
        }else if (_productDetaileModel.bill_statu ==3) {
            [cell.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
        }else if (_productDetaileModel.bill_statu ==4) {
            [cell.stateBtn setTitle:@"已过期" forState:UIControlStateNormal];
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        NSString * title = _titles[indexPath.row];
        
        if (title.length <= 4) {
            ProductDetaileCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetaileCell"];
            cell.titleLab.text = title;
            
            if ([title isEqualToString:kSeverName]) {
                cell.contentLab.text = _productDetaileModel.entry_name;
            }
            if ([title isEqualToString:kSeverLY]) {
                cell.contentLab.text = _productDetaileModel.service_sector;
            }
            if ([title isEqualToString:kSeverPP]) {
                cell.contentLab.text = [NSString stringWithFormat:@"%@",_productDetaileModel.service_brand];
            }
            if ([title isEqualToString:kSeverNumber]) {
                
                cell.titleLab.text = @"数量/单位";
                cell.contentLab.text = [NSString stringWithFormat:@"%@",_productDetaileModel.number];
            }
            if ([title isEqualToString:kSeverXS]) {
                cell.contentLab.text = _productDetaileModel.service_form;
            }
            if ([title isEqualToString:kSeverLX]) {
                cell.contentLab.text = _productDetaileModel.service_type;
            }
            if ([title isEqualToString:kSeverQY]) {
                cell.contentLab.text = _productDetaileModel.service_address;
            }
            if ([title isEqualToString:kSeverMark]) {
                cell.contentLab.text =_productDetaileModel.bill_desc.length==0?@"    ":_productDetaileModel.bill_desc;
            }
            if ([title isEqualToString:kSeverPrice]) {
                cell.contentLab.text = [NSString stringWithFormat:@"¥ %@",_productDetaileModel.service_price];
            }
            return cell;
        }else{
            
            ProductDetail1TableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ProductDetail1TableViewCell"];
            cell.titleLab.text = _titles[indexPath.row];

//            if ([title isEqualToString:kSeverOtherQY]) {
//                cell.contentLab.text =_productDetaileModel.other_service_sector.length==0?@"    ":_productDetaileModel.other_service_sector;
//            }
             if ([title isEqualToString:kSeverTime]) {
                cell.contentLab.text = [NSString stringWithFormat:@"%@ - %@",[Utool timeStamp2TimeFormatter:_productDetaileModel.service_stime],[Utool timeStamp2TimeFormatter:_productDetaileModel.service_etime]];
            }
            return cell;
        }
    }
    if (indexPath.section == 2) {
          OrderDetailImageCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailImageCell"];
          cell.imageArray =_productDetaileModel.image;
        return cell;
     }
    
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
        return  80;
    }
    if (indexPath.section == 2) {
        return 120;
    }
    return UITableViewAutomaticDimension;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
     }
    return 0.001f;
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
