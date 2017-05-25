//
//  MeViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
#import "AdressListController.h"
#import "MeCell.h"
#import "PDCollectionViewFlowLayout.h"
#import "MeHeadReusableView.h"
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

@interface MeViewController () <UICollectionViewDataSource, UICollectionViewDelegate,PDCollectionViewFlowLayoutDelegate>{

    
}
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) UserInfoModel1 *userInfoModel1;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    icon_settings
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_settings" highImage:@"icon_settings" target:self action:@selector(settingItemAction:)];
//    _titles =@[@"我的发单",@"我的接单",@"商城订单",@"小库存",@"联系客服",@"收货地址",@"关联用户",@"我要补单",@"推荐给好友"];
    _titles =@[@"我的发单",@"我的接单",@"空闲时间",@"商城订单",@"小库存",@"收货地址",@"关联用户",@"联系客服",@"我要补单"];
//    _images =@[@"me_img_fadan",@"me_img_jiedan",@"me_img_order",@"me_img_stock",@"me_img_service",@"me_img_address",@"me_img_users",@"me_img_budan",@"me_img_share"];
    _images =@[@"me_img_fadan",@"me_img_jiedan",@"me_img_order",@"me_img_order",@"me_img_stock",@"me_img_address",@"me_img_users",@"me_img_service",@"me_img_order"];

    [self.view addSubview:[self collectionView]];

    if (kUserId.length != 0) {
        [self loadMineDataInfo];
    }
    
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
        [UserManager archiverModel:user];
        
        [_collectionView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
}


#pragma mark - getter & setter
- (UICollectionView *)collectionView{

    if (!_collectionView) {
        
        PDCollectionViewFlowLayout * layout = [[PDCollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        //    layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.columnCount = 3;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kBackgroundColor;
//        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        
//        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellWithReuseIdentifier:@"MeCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MeHeadReusableView" bundle:nil] forSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"MeHeadReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionFooter withReuseIdentifier:@"EngineerFooterReusableView"];
//
    }



    return _collectionView;
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [_collectionView reloadData];
    
    if (kUserId.length != 0) {
        [self loadMineDataInfo];
    }

    
    
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
#pragma mark - MUCollectionViewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (kScreenWidth-0)/3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth,156);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CZCollectionElementKindSectionHeader])
    {
        MeHeadReusableView * engineerHeaderReusableView =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MeHeadReusableView" forIndexPath:indexPath];
        engineerHeaderReusableView.backgroundColor = [UIColor whiteColor];
        
        
        if (kUserId.length == 0) {
            engineerHeaderReusableView.loginView.hidden = YES;
            engineerHeaderReusableView.noLoginView.hidden = NO;
        }else{
            engineerHeaderReusableView.loginView.hidden = NO;
            engineerHeaderReusableView.noLoginView.hidden = YES;
        }
        if (_userInfoModel1.is_real  == 1) {

            engineerHeaderReusableView.aouthBtn.selected = NO;
            engineerHeaderReusableView.aouthBtn.backgroundColor = [UIColor whiteColor];
            [engineerHeaderReusableView.aouthBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
            [engineerHeaderReusableView.aouthBtn setBackgroundImage:[UIImage imageNamed:@"me_btn_nameidf"]  forState:UIControlStateNormal];
            [engineerHeaderReusableView.aouthBtn setTitle:@"已实名认证" forState:UIControlStateNormal];

            
            
        }else {
         
            engineerHeaderReusableView.aouthBtn.selected = YES;
            
            engineerHeaderReusableView.aouthBtn.backgroundColor = kThemeColor;
            [engineerHeaderReusableView.aouthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [engineerHeaderReusableView.aouthBtn setBackgroundImage:[UIImage imageNamed:@"tag_red"]  forState:UIControlStateSelected];
            [engineerHeaderReusableView.aouthBtn setTitle:@"去实名认证" forState:UIControlStateSelected];
            
        }
        engineerHeaderReusableView.nameLab.hidden = NO;
        
        NSString * nick_name = _userInfoModel1.member_nik_name;
        LxDBAnyVar(nick_name);

         if(nick_name.length != 0){
            engineerHeaderReusableView.nameLab.text = nick_name;
         }
         else{
             engineerHeaderReusableView.nameLab.text = @"请设置昵称";
         }
        
        
        [engineerHeaderReusableView.headerImageBtn sd_setImageWithURL:[NSURL URLWithString:_userInfoModel1.member_avatar] forState:UIControlStateNormal placeholderImage:kDefaultImage_header];

        
        // 点击头像放大
        [engineerHeaderReusableView.headerImageBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            AvatarBrowser *browser = [[AvatarBrowser alloc] initWithImage:btn.imageView.image view:btn];
            [browser show];
            
        }];
        
         [engineerHeaderReusableView.aouthBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
             
             [Utool verifyLogin:self LogonBlock:^{
                 CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
                 vc.is_real =_userInfoModel1.is_real;
                 [self.navigationController pushViewController:vc animated:YES];
              }];
          }];
        // 用户没有登录 点击去登录
        [engineerHeaderReusableView.logonBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            BaseNavigationController * nvc = [[BaseNavigationController alloc]initWithRootViewController:lvc];
            [self presentViewController:nvc animated:YES completion:^{
            }];
        }];
        
        // 进入个人信息
        [engineerHeaderReusableView.arrowBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {

            [Utool verifyLogin:self LogonBlock:^{
                UserInfoViewController * vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
         }];
        // 进入钱包
        [engineerHeaderReusableView.moneyBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            [Utool verifyLogin:self LogonBlock:^{
                WalletViewController * vc = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];

            }];
          }];
        // 进入购物车
        [engineerHeaderReusableView.shoppingCarBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            [Utool verifyLogin:self LogonBlock:^{
                ShopCarViewController * vc = [[ShopCarViewController alloc]initWithNibName:@"ShopCarViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }];

           
            
        }];
        // 进入收藏
        [engineerHeaderReusableView.collectBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
            
            [Utool verifyLogin:self LogonBlock:^{
                CollectViewController * vc = [[CollectViewController alloc]initWithNibName:@"CollectViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }];

      
            
        }];
        
        return engineerHeaderReusableView;
    }
    else if ([kind isEqualToString:CZCollectionElementKindSectionFooter])
    {
        UICollectionReusableView * engineerFooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EngineerFooterReusableView" forIndexPath:indexPath];
        engineerFooterReusableView.backgroundColor = [UIColor whiteColor];
        return engineerFooterReusableView;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeCell" forIndexPath:indexPath];
    [cell.titleBtn setTitle:_titles[indexPath.row] forState:UIControlStateNormal];
    [cell.titleBtn setImage:[UIImage imageNamed:_images[indexPath.row]] forState:UIControlStateNormal];
    CGFloat space = 20.0;
    [cell.titleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop
                                    imageTitleSpace:space];
    cell.titleBtn.tag = indexPath.row;
    [cell.titleBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        if(btn.tag == 8){
            
            [self viewcontrollerJump2VCWithindex:btn.tag];
        }else{
            
            [Utool verifyLogin:self LogonBlock:^{
                 [self viewcontrollerJump2VCWithindex:btn.tag];
             }];
         }
     }];
    

    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeLog(@"indexPath section: %ld  row:%ld", (long)indexPath.section, (long)indexPath.row);

    
}

- (void)viewcontrollerJump2VCWithindex:(NSInteger )index{
    

    if (index == 0) {
        SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"待接单",@"已接单",@"已完成",@"已取消",@"调价中"]  andClass:[MySendOrderViewController class]];
        vc.navigationItem.title = @"我的发单";
        //设置数据的key
        [vc setRequestDataKeyArr:@[@1,@2,@3,@5,@6]];
        
//        MySendOrderViewController * vc = [[MySendOrderViewController alloc]initWithNibName:@"MySendOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {
        SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"已接单",@"已完成",@"已取消",@"调价中"]  andClass:[MyReceivingOrderViewController class]];
        vc.navigationItem.title = @"我的接单";
        //设置数据的key
        [vc setRequestDataKeyArr:@[@2,@3,@5,@6]];
        
//        MyReceivingOrderViewController * vc = [[MyReceivingOrderViewController alloc]initWithNibName:@"MyReceivingOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {
        //空闲时间
        SpaceTimeViewController *spaceTimeVC = [[SpaceTimeViewController alloc] init];
        [self.navigationController pushViewController:spaceTimeVC animated:YES];
    }
    if (index == 3) {
        SCNavTabBarController * vc = [[SCNavTabBarController alloc]initWithTitleArr:@[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"已取消"]  andClass:[ShopOrderViewController class]];
        vc.navigationItem.title = @"我的接单";
        
        //设置数据的key
        [vc setRequestDataKeyArr:@[@100,@1,@2,@3,@4,@0]];
        
        
        vc.navigationItem.title=@"商城订单";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 4) {
        MyStockViewController * vc = [[MyStockViewController alloc]initWithNibName:@"MyStockViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (index == 5) {
        AdressListController * vc = [[AdressListController alloc]initWithNibName:@"AdressListController" bundle:nil];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 6) {
        AssociationViewController * vc = [[AssociationViewController alloc]initWithNibName:@"AssociationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 7) {
        //        SendOrderViewController * vc = [[SendOrderViewController alloc]initWithNibName:@"SendOrderViewController" bundle:nil];
        //        [self.navigationController pushViewController:vc animated:YES];
        
        ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:@"kefu1" friendUsername:@"客服"
                                                                                       friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage]
                                                                                                 user:kPhone
                                                                                             userName:kUserName
                                                                                             userIcon:kUserIcon];
        
        chatController.title = @"客服";
        chatController.friendIcon = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage];
        chatController.userIcon = kUserIcon;
        [self.navigationController pushViewController:chatController animated:YES];
        
        
    }
    if (index == 8) {
        ReplacementOrderViewController * vc  = [[ReplacementOrderViewController alloc]initWithNibName:@"ReplacementOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    if (index == 8) {
//        [self shareWithUMengWithVC:self withImage:nil withID:nil
//                         withTitle:@"七小服"
//                          withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];
//    }
}




#pragma mark - 添加设置按钮

- (void)settingItemAction:(UIBarButtonItem *)item{
    SettingViewController * vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    vc.state = _userInfoModel1.is_paypwd;
    vc.is_real =_userInfoModel1.is_real;
    vc.userHeader = _userInfoModel1.member_avatar;
    [self.navigationController pushViewController:vc animated:YES];
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
