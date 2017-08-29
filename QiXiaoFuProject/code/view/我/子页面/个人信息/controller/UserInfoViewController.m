//
//  UserInfoViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/29.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "UserInfoViewController.h"
#import "MineInfoCell.h"
#import "UIViewController+XHPhoto.h"
#import "UserInfoFooterView.h"
#import "UserInfoUpImageCell.h"
#import "MineInfoNickCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ChooseSeviceDomainViewController.h"
#import "User.h"
#import "NSArray+Utils.h"
#import "UserInfoModel1.h"
#import "STPickerDate.h"
#import "ChooseBrandViewController.h"
#import "UpZhiYeImageViewController.h"
#import "CommentListViewController.h"
#import "CertificationViewController.h"
#import "BlockUIAlertView.h"
#import "LocalData.h"
#import "NSString+Utils.h"
#import "UILabel+ContentSize.h"


@interface UserInfoViewController ()
{
    
    NSArray * _selectedDomainsIds;// 已选择的服务领域
    
    
    NSString * _avatar;// 头像
    NSString * _nickName;// 昵称
    NSString * _working_time;// 从业时间【时间戳】
    NSString * _service_sector;// 技术领域 【多个用逗号,分隔】【单个写ID即可】
    NSString * _service_brand;// 技术品牌 【多个用逗号,分隔】【单个写ID即可】
    NSString * _cer_images;// 从业资格证书

    
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (strong, nonatomic) NSArray *titles;

@property (nonatomic, strong) UserInfoModel1 *userInfoModel1;

@property (weak, nonatomic) IBOutlet UIView *reminderView;
@property (weak, nonatomic) IBOutlet UIView *remindSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindSubViewH;
@property (weak, nonatomic) IBOutlet UILabel *remindLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remindLblH;


@property (nonatomic, strong) NSArray *classArray;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"reminder_icon" highImage:@"reminder_icon" target:self action:@selector(reminderAction)];
    
    _titles = @[@"头像",@"昵称",@"实名认证",@"从业时间",@"职业资格证书",@"技术领域",@"擅长品牌",@"个人邀请码",@"评论列表"];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MineInfoCell" bundle:nil] forCellReuseIdentifier:@"MineInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UserInfoUpImageCell" bundle:nil] forCellReuseIdentifier:@"UserInfoUpImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MineInfoNickCell" bundle:nil] forCellReuseIdentifier:@"MineInfoNickCell"];

    self.remindSubView.layer.cornerRadius = 5;
    [self.remindLbl caculatedSize];
    
    if (kScreenWidth == 320){
        self.remindLblH.constant = 220;
    }else if (kScreenWidth == 375){
        self.remindLblH.constant = 190;
    }else{
        self.remindLblH.constant = 170;
    }
    self.remindSubViewH.constant = self.remindLblH.constant + 30 + 21 + 60;
    
    
    _tableView.tableFooterView = [UIView new];
    
//    UserInfoFooterView * userInfoFooterView = [UserInfoFooterView userInfoFooterView];
//    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
//    [footerView addSubview:userInfoFooterView];
//    userInfoFooterView.frame = footerView.bounds;
//    _tableView.tableFooterView = footerView;
//
    [self getClass];
     // Do any additional setup after loading the view from its nib.
}

//显示活着隐藏提示视图
- (IBAction)reminderAction {

    if (self.reminderView.hidden){
        self.reminderView.hidden = NO;
        self.reminderView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1);
        [UIView animateWithDuration:0.3f animations:^{
            self.reminderView.layer.transform = CATransform3DMakeScale(1, 1, 1);
            self.reminderView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.reminderView.layer.transform = CATransform3DMakeScale(2, 2, 2);
            self.reminderView.alpha = 0;
        } completion:^(BOOL finished) {
            self.reminderView.hidden = YES;
        }];
    }
  
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self loadMineDataInfo];


}




- (void)getClass{

    [MCNetTool postWithUrl:HttpMainGetClass params:nil success:^(NSDictionary *requestDic, NSString *msg) {
        
        
        _classArray = [Service_Sector12 mj_objectArrayWithKeyValuesArray:requestDic];
        
        
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];


}




#pragma mark - 获取用户信息
- (void)loadMineDataInfo{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;

    [MCNetTool postWithUrl:HttpMeShowMemberInfo params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _userInfoModel1 = [UserInfoModel1 mj_objectWithKeyValues:requestDic];
        
        
        if ([_userInfoModel1.member_level isEqualToString:@"DA"]){
            _titles = @[@"头像",@"昵称",@"实名认证",@"从业时间",@"职业资格证书",@"技术领域",@"擅长品牌",@"评论列表"];
        }
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
}

#pragma mark - 修改用户头像

/**
 修改用户头像

 @param imageData 图片二进制流
 */
- (void)changeHeaderImageWithImageData:(NSData *)imageData{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    //获取时间戳
    NSTimeInterval timeStamp =[[NSDate date] timeIntervalSince1970];
    NSString *token_time = [NSString stringWithFormat:@"%.f",timeStamp*1000];
    //拼接token
    NSString *token =[[NSString stringWithFormat:@"qixiaofu0ab3b4n55nca%@",token_time] MD5];
    params[@"token_time"] = token_time;
    params[@"token"] = token;
    
    [MCNetTool uploadDataWithURLStr:HttpMeChangeHeaderImage withDic:params imageKey:@"imgFile" withData:imageData uploadProgress:^(float progress) {
        [self showProgress:progress];
    } success:^(NSDictionary *requestDic, NSString *msg) {
        [self showSuccessText:msg];
        _avatar =requestDic[@"img"];
        
        [self loadMineDataInfo];
        
    } failure:^(NSString *error) {
        [self showErrorText:error];
    }];
 }



- (void)changeUserInfo{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    if(_nickName.length != 0){
        params[@"nik_name"] = _nickName;//昵称
    }
    if(_working_time.length != 0){
        params[@"working_time"] = _working_time;//从业时间 【时间戳】
    }
    if(_service_sector.length != 0){
        params[@"service_sector"] = _service_sector;//技术领域 【多个用逗号,分隔】【单个写ID即可】
    }
    if(_service_brand.length != 0){
        params[@"service_brand"] = _service_brand;// 技术品牌 【多个用逗号,分隔】【单个写ID即可】
    }
    if(_cer_images.length != 0){
        params[@"cer_images"] = _cer_images;// 从业资格证书
    }
    [MCNetTool postWithUrl:HttpMeUpdateMemberInfo params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self showSuccessText:@"保存成功"];
        
        //记录技术领域
        [LocalData setUpService_sector:_service_sector];
        
        [self loadMineDataInfo];
        
        [self.view endEditing:YES];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
     }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MineInfoCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoCell"];
         [cell.iconImageView setImageWithUrl:_userInfoModel1.member_avatar placeholder:kDefaultImage_header];
        
        return cell;
    }else if (indexPath.row == 1) {
         MineInfoNickCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoNickCell"];
        cell.titleLab.text =_titles[indexPath.row ];
        cell.textFiled.placeholder = @"请输入昵称";
        if (_userInfoModel1.member_nik_name.length !=0) {
            cell.textFiled.text = _userInfoModel1.member_nik_name;
        }
        cell.mineInfoNickCellBlock = ^(NSString * text){
            _nickName = text;
            [self changeUserInfo];
        };
        return cell;
         
    }else if (indexPath.row == 2) {
        MineInfoNickCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoNickCell"];
        cell.titleLab.text =_titles[indexPath.row ];
        if ([_userInfoModel1.is_real intValue] == 1){
            cell.textFiled.text = @"已认证";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage new]];
        }else{
            cell.textFiled.text = @"未认证";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textFiled.enabled = NO;
        return cell;
        
    }else if (indexPath.row == 3) {
        MineInfoNickCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoNickCell"];
        cell.titleLab.text =_titles[indexPath.row ];
        cell.textFiled.placeholder = @"请输入从业时间";
        cell.textFiled.userInteractionEnabled = NO;
        if (_userInfoModel1.working_time.length !=0 && ![_userInfoModel1.working_time isEqualToString:@"0"]) {
            cell.textFiled.text = [Utool timeStamp4TimeFormatter:_userInfoModel1.working_time];
        }
        return cell;
        
    }else if (indexPath.row == 4) {
        UserInfoUpImageCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"UserInfoUpImageCell"];
        cell.userInfoModel1 = _userInfoModel1;
        cell.userInfoUpImageCell =^(NSInteger depth,NSString * imageUrl,NSString * zhengshuname,NSString * cer_id){
        
            UpZhiYeImageViewController * vc = [[UpZhiYeImageViewController alloc]initWithNibName:@"UpZhiYeImageViewController" bundle:nil];
            vc.depth = depth;
            vc.imageUrl = imageUrl;
            vc.zhengshuname = zhengshuname;
            vc.cer_id = cer_id;
            vc.upZhiYeImageViewControllerBlock = ^(){
                [self loadMineDataInfo];
             };
            [self.navigationController pushViewController:vc animated:YES];
        
        };
        
        
        return cell;
        
    }else if(indexPath.row == 5){
    
        MineInfoNickCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoNickCell"];
        cell.titleLab.text =_titles[indexPath.row ];
        cell.textFiled.enabled = NO;
        cell.textFiled.placeholder = @"";
         NSMutableArray * titles =[NSMutableArray new];
         [_userInfoModel1.service_sector enumerateObjectsUsingBlock:^( Service_Sector234 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:user.gc_name];
         }];
         cell.textFiled.text = [titles string];
          return cell;

      
    }else if(indexPath.row == 6){
        
        MineInfoNickCell *   cell =[tableView dequeueReusableCellWithIdentifier:@"MineInfoNickCell"];
        cell.titleLab.text =_titles[indexPath.row ];
        cell.textFiled.enabled = NO;
        cell.textFiled.placeholder = @"";
//        NSMutableArray * titles =[NSMutableArray new];
//        [_userInfoModel1.service_sector enumerateObjectsUsingBlock:^( Service_Sector234 *  user , NSUInteger idx, BOOL * _Nonnull stop) {
//            [titles addObject:user.gc_name];
//        }];
        cell.textFiled.text = _userInfoModel1.service_brand;
        return cell;
        
        
    }
    else{
    
    
        UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text =_titles[indexPath.row ];
        
        if(indexPath.row == 7 && self.titles.count == 9){
            cell.detailTextLabel.text = _userInfoModel1.iv_code;
        }else{
            cell.detailTextLabel.text = @"";
        }
        
        return cell;
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return  70;
    }
    if (indexPath.row == 4) {
        return  (kScreenWidth - 0 - 60) / 5 + 20 + 43+ 20;
    }
    return  50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row ==0){
        [self showCanEdit:YES photo:^(UIImage *photo,NSData * imageData) {
            MineInfoCell *   cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.iconImageView.image = photo;
            
            [self changeHeaderImageWithImageData:imageData];
            
        }];
    }
    if(indexPath.row == 2){
        [Utool verifyLoginAndCertification:self LogonBlock:^{
//            BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"\n已实名认证\n" cancelButtonTitle:@"确定" clickButton:^(NSInteger buttonIndex) {
//                
//                            } otherButtonTitles:nil];
//            [alert show];
            
        } CertificationBlock:^{
            CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
    }
    if(indexPath.row == 3){
        STPickerDate *pickerDate = [[STPickerDate alloc]initWithRow:1];
        
        pickerDate.pickerDate3Block = ^(NSInteger year,NSInteger month,NSInteger day,NSString * time){
            _working_time =  [Utool timestampForDateFromString:time withFormat:@"yyyy.MM.dd HH:mm"];
            MineInfoNickCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textFiled.text =  [NSString stringWithFormat:@"%ld年",year];
            
            [self changeUserInfo];
        };
        
        [pickerDate show];
        
    }
    if (indexPath.row == 5) {
        
        ChooseSeviceDomainViewController * vc = [[ChooseSeviceDomainViewController alloc]initWithNibName:@"ChooseSeviceDomainViewController" bundle:nil];
        vc.domains = _classArray;
        vc.isFromPersonalInfo = YES;
//        vc.selectedContactIds = [self contactIdsForContacts:_userInfoModel1.service_sector];
        vc.domainsChooseSeviceDomainViewBlock = ^(NSArray * somains){
            NSMutableArray * titles = [NSMutableArray array];
            NSMutableArray * ids = [NSMutableArray array];
            for (NSDictionary *dict in somains) {
                NSMutableArray * subTitles = [NSMutableArray array];
                if ([dict.allKeys containsObject:@"model"]){
                    Service_Sector12 *sector12 = [dict objectForKey:@"model"];
                    [ids addObject:sector12.gc_id];
                    
                    if ([dict.allKeys containsObject:@"list"]){
                        NSArray *array = [dict objectForKey:@"list"];
                        for (Service_Sector22 *sector22 in array) {
                            [ids addObject:sector22.gc_id];
                            [subTitles addObject:sector22.gc_name];
                        }
                    }
                    if (subTitles.count > 0){
                        NSString *str = [NSString stringWithFormat:@"%@(%@)",sector12.gc_name,[subTitles componentsJoinedByString:@","]];
                        [titles addObject:str];
                    }else{
                        [titles addObject:sector12.gc_name];
                    }
                }
            }
            
            _service_sector = [ids componentsJoinedByString:@","];
//
            [self changeUserInfo];

        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 6) {
        
        ChooseBrandViewController * vc = [[ChooseBrandViewController alloc]initWithNibName:@"ChooseBrandViewController" bundle:nil];
        vc.service_brand = _userInfoModel1.service_brand;
        vc.chooseBrandViewBlock = ^(NSString * text){
            
            _service_brand = text;
            
            [self changeUserInfo];
            
        };
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    if(indexPath.row == 8 || (self.titles.count == 8 && indexPath.row == 7)){
        CommentListViewController * vc   =[[CommentListViewController alloc]initWithNibName:@"CommentListViewController" bundle:nil];
        vc.member_id = _userInfoModel1.member_id;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

/**
 *  处理已经选择的服务领域
 *
 *  @param contacts 已经选择的服务领域的数组
 *
 */
- (NSSet *)contactIdsForContacts:(NSArray *)contacts {
    NSMutableSet *contactIdSet = [NSMutableSet set];
    for (Service_Sector12 *contact in contacts) {
        [contactIdSet addObject:contact.gc_id];
    }
    return contactIdSet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}


-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
