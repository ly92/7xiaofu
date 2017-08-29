//
//  PersonalViewController.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/7/19.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingViewController.h"
#import "AdressListController.h"
#import "MeCell.h"
#import "PDCollectionViewFlowLayout.h"
#import "ShopCarViewController.h"
#import "CollectViewController.h"

#import "UserInfoViewController.h"
#import "MySendOrderViewController.h"
#import "MyReceivingOrderViewController.h"
#import "ShopOrderViewController.h"
#import "MyStockViewController.h"
#import "WalletViewController.h"
#import "AdressListController.h"
#import "AssociationViewController.h"
#import "BaseNavigationController.h"
#import "AvatarBrowser.h"
#import "LoginViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CertificationViewController.h"
#import "SendOrderViewController.h"
#import "ReplacementOrderViewController.h"
#import "UserInfoModel1.h"
#import "UIButton+WebCache.h"
#import "ChatViewController.h"
#import "SCNavTabBarController.h"
#import "SpaceTimeViewController.h"
#import "AssociationViewControllerA.h"

#import "SignInViewController2.h"
#import "SignInViewController.h"
#import "CouponViewController.h"
#import "CreditsViewController.h"
#import "CreditsViewController2.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ConversationListController.h"

@interface PersonalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *aouthBtn;
@property (weak, nonatomic) IBOutlet UILabel *invoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *signLbl;
@property (weak, nonatomic) IBOutlet UILabel *creditsLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponLbl;
@property (weak, nonatomic) IBOutlet UILabel *walletLbl;
@property (weak, nonatomic) IBOutlet UILabel *billLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderLbl;
@property (weak, nonatomic) IBOutlet UIView *creditsView;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;


@property (nonatomic, strong) UserInfoModel1 *userInfoModel1;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.iconImgV.layer.cornerRadius = 32.5;
    [self.signView addTapAction:@selector(signAction) forTarget:self];
    [self.creditsView addTapAction:@selector(creditsAction) forTarget:self];
    [self.couponView addTapAction:@selector(couponAction) forTarget:self];
    [self.iconImgV addTapAction:@selector(iconClickAction) forTarget:self];
    
    self.messageLbl.layer.cornerRadius = 9;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (kUserId.length != 0) {
        [self loadMineDataInfo];
        [self loadSystemMessageData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
//消息
- (IBAction)settingAction {
    ConversationListController *messageViewController = [[ConversationListController alloc]init];
    [self.navigationController pushViewController:messageViewController animated:YES];
}
//个人信息
- (IBAction)personalDetailAction {
    UserInfoViewController * vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signAction{
    
    SignInViewController2 *signinVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignInViewController2"];
    [self.navigationController pushViewController:signinVC animated:YES];
    
//    SignInViewController *signinVC = [[SignInViewController alloc] init];
//    [self.navigationController pushViewController:signinVC animated:YES];
}
- (void)creditsAction{
    
    CreditsViewController2 *creditsVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditsViewController2"];
    [self.navigationController pushViewController:creditsVC animated:YES];
    
//    CreditsViewController *creditsVC = [[CreditsViewController alloc] init];
//    [self.navigationController pushViewController:creditsVC animated:YES];
}
- (void)couponAction{
    CouponViewController *couponVC = [[CouponViewController alloc] init];
    [self.navigationController pushViewController:couponVC animated:YES];
}
- (void)iconClickAction{
    AvatarBrowser *browser = [[AvatarBrowser alloc] initWithImage:self.iconImgV.image view:self.iconImgV];
    [browser show];
}


#pragma mark - 获取用户信息
- (void)loadMineDataInfo{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    [MCNetTool postWithUrl:HttpMeShowMemberInfo params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _userInfoModel1 = [UserInfoModel1 mj_objectWithKeyValues:requestDic];
        
        UserInfoModel * user = [UserManager readModel];
        user.userIcon = _userInfoModel1.member_avatar;
        user.userName = _userInfoModel1.member_nik_name;
        user.is_real =_userInfoModel1.is_real;
        user.count_bill = _userInfoModel1.count_bill;
        user.count_bill_integral = _userInfoModel1.count_bill_integral;
        user.member_level = _userInfoModel1.member_level;
        if ([user.is_real intValue] == 1){
            [self addIntegral:@"2"];
        }
        if ([user.count_bill intValue] == 1 && [user.count_bill_integral intValue] == 0){
            [self addIntegral:@"3"];
        }
        
        [UserManager archiverModel:user];
        [self setUpUIData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
}

//如果实名认证则请求添加积分
- (void)addIntegral:(NSString *)type{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"type"] = type;//1:注册 2:实名认证 3:完成第一个订单加分
    
    [MCNetTool postWithUrl:HttpAddRedits params:params success:^(NSDictionary *requestDic, NSString *msg) {
    } fail:^(NSString *error) {
    }];
}


//设置页面数据
- (void)setUpUIData{
    
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel1.member_avatar] placeholderImage:kDefaultImage_header];
    if ([self.userInfoModel1.is_real intValue] == 1){
        [self.aouthBtn setTitle:@"已实名认证" forState:UIControlStateNormal];
    }else{
        [self.aouthBtn setTitle:@"请实名认证" forState:UIControlStateNormal];
    }
    if ([self.userInfoModel1.member_nik_name yw_notNull]){
        self.nameLbl.text = self.userInfoModel1.member_nik_name;
    }else{
        self.nameLbl.text = @"请设置昵称";
    }
    self.invoteLbl.text = [NSString stringWithFormat:@"邀请码:%@",self.userInfoModel1.iv_code];
    
    self.signLbl.text = self.userInfoModel1.sign_day;
    self.creditsLbl.text = self.userInfoModel1.jifen;
    self.couponLbl.text = self.userInfoModel1.ticket;
    self.walletLbl.text = [NSString stringWithFormat:@"%@元",self.userInfoModel1.balance];
    self.billLbl.text = [NSString stringWithFormat:@"%@单",self.userInfoModel1.send_count_bill];
    self.orderLbl.text = [NSString stringWithFormat:@"%@单",self.userInfoModel1.take_count_bill];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 1:{
            //钱包
            WalletViewController * vc = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            //购物车
            ShopCarViewController * vc = [[ShopCarViewController alloc]initWithNibName:@"ShopCarViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            //收藏
            CollectViewController * vc = [[CollectViewController alloc]initWithNibName:@"CollectViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            //我的发单
            SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"报名中",@"已接单",@"已完成",@"已取消",@"已失效"]  andClass:[MySendOrderViewController class]];
            vc.navigationItem.title = @"我的发单";
            //设置数据的key
            [vc setRequestDataKeyArr:@[@111,@2,@3,@5,@4]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            //我的接单
            SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"报名中",@"已接单",@"已完成",@"已取消",@"调价中",@"补单"]  andClass:[MyReceivingOrderViewController class]];
            vc.navigationItem.title = @"我的接单";
            //设置数据的key
            [vc setRequestDataKeyArr:@[@111,@2,@3,@5,@6,@7]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            //空闲时间
            SpaceTimeViewController *spaceTimeVC = [[SpaceTimeViewController alloc] init];
            [self.navigationController pushViewController:spaceTimeVC animated:YES];
        }
            break;
        case 7:{
            //商城订单
            SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"退换货",@"已取消"]  andClass:[ShopOrderViewController class]];
            //设置数据的key
            [vc setRequestDataKeyArr:@[@100,@1,@2,@3,@4,@6,@0]];
            
            vc.navigationItem.title=@"商城订单";
            
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 8:{
            //我要补单
            UserInfoModel * user = [UserManager readModel];
            if ([user.member_level isEqualToString:@"A"]){
                [self showErrorText:@"当前用户为A用户，不可补单！"];
                return;
            }
            ReplacementOrderViewController * vc  = [[ReplacementOrderViewController alloc]initWithNibName:@"ReplacementOrderViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:{
            //小库存
            MyStockViewController * vc = [[MyStockViewController alloc]initWithNibName:@"MyStockViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:{
            //联系客服
            ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:@"kefu1" friendUsername:@"客服"
                                                                                           friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage]];
            
            chatController.title = @"客服";
            chatController.friendIcon = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage];
            chatController.userIcon = kUserIcon;
            [self.navigationController pushViewController:chatController animated:YES];

        }
            break;
        case 11:{
            //关联用户
            if ([_userInfoModel1.member_level isEqualToString:@"A"]){
                AssociationViewControllerA * vc = [[AssociationViewControllerA alloc]initWithNibName:@"AssociationViewControllerA" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                AssociationViewController * vc = [[AssociationViewController alloc]initWithNibName:@"AssociationViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
            break;

        case 12:{
            //设置
            SettingViewController * vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
            vc.state = _userInfoModel1.is_paypwd;
            vc.is_real =_userInfoModel1.is_real;
            vc.userHeader = _userInfoModel1.member_avatar;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }

}


#pragma mark - 获取系统消息数据
-(void)loadSystemMessageData{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userid"] = kUserId;
    params[@"op"] = @"message_list";
    params[@"act"] = @"member_index";
    params[@"store_id"] = @"1";
    [MCNetTool postWithUrl:HttpApi params:params success:^(NSDictionary *requestDic, NSString *msg) {
        NSArray *listArr =(NSArray *)requestDic;
        
        if (listArr.count > 0) {
            NSDictionary *systemMessageDict = listArr[0];
            NSArray *array = [systemMessageDict objectForKey:@"countnum_all_count"];
            if (array.count > 0){
                for (NSDictionary *dict in array) {
                    if ([[dict objectForKey:@"msg_type"] intValue] == 0){
                        if ([[dict objectForKey:@"countnum"] intValue] > 0){
                            self.messageLbl.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"countnum"]];
                            self.messageLbl.hidden = NO;
                        }else{
                            self.messageLbl.hidden = YES;
                        }
                    }
                }
            }
        }
        
        
    } fail:^(NSString *error) {
        
        [PDHud showErrorWithStatus:error];
    }];
}



@end
