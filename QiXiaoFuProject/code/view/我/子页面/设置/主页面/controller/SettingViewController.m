//
//  SettingViewController.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SettingViewController.h"
//#import "ForgetPassVC.h"
#import "FeedbackViewController.h"
//#import "SettingPassViewController.h"
#import "MCCacheTool.h"
//#import "AppManager.h"
#import "SettingFooterView.h"
#import <StoreKit/StoreKit.h>
#import "AboutViewController.h"
#import "XieYiViewController.h"
#import "SettingPayPassWordViewController.h"
#import "ChangePassViewController.h"
#import "ChatViewController.h"
#import "BlockUIAlertView.h"
#import "CertificationViewController.h"
#import "JPUSHService.h"
#import "EaseModHelper.h"
#import "AppManager.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "SendOrder1ViewController.h"



static NSString * kCecheKey = @"清除缓存";
static NSString * kShareKey = @"推荐给好友";
static NSString * kSettingPayPassWordKey = @"设置支付密码";
static NSString * kChengePayPassWordKey = @"修改支付密码";
static NSString * kChengePassWordKey = @"修改登录密码";
static NSString * kPushState = @"是否接收推送消息";


@interface SettingViewController ()<UIActionSheetDelegate,SKStoreProductViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titles;
@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UITextView *helpTextView;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    

    NSArray * sections0Array;
    
    if (kUserId.length == 0) {
        sections0Array =@[kCecheKey,kShareKey];
    }else{
        sections0Array =@[_state==1?kChengePayPassWordKey:kSettingPayPassWordKey,kChengePassWordKey,kCecheKey,kShareKey/*,kPushState*/];
    }
//    NSArray * sections1Array =@[@"软件版本",@"关于我们",@"给我五星评价"];
//    NSArray * sections1Array =@[@"关于我们",@"给我五星评价"];
    NSArray * sections1Array =@[@"关于我们",@"版本",@"给我五星评价"];
//    NSArray * sections2Array =@[@"意见反馈",@"联系客服",@"加入我们",@"用户协议",@"操作手册"];
//    NSArray * sections2Array =@[@"联系客服",@"加入我们",@"用户协议",@"操作手册"];
    NSArray * sections2Array =@[@"用户协议",@"操作手册",@"意见反馈",@"帮助中心"];

    _titles = @[sections0Array,sections1Array,sections2Array];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    
    if (kUserId.length != 0) {

        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        footerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
         SettingFooterView * settingFooterView = [SettingFooterView settingFooterView];
        settingFooterView.frame = CGRectMake(0, 0.5, kScreenWidth, 49);
        [footerView addSubview:settingFooterView];
        _tableView.tableFooterView = footerView;
        
         [settingFooterView.exitBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
             UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出", nil];
             sheet.tag = 1;
             [sheet showInView:[UIApplication sharedApplication].windows[0]];
        }];
    
    }
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    //用于极光单推的方式2 别名： alias
    
}

#pragma mark - UIActionSheetDelegate
/**
 *  退出账号
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
        UserInfoModel * modle= [UserManager readModel];
        modle.userid =@"";
//        modle.phone =@"";
        modle.store_id =@"";
        modle.store_name =@"";
        modle.password =@"";
        modle.userIcon =@"";
        modle.userName =@"";
        modle.pushState =@"";
        [UserManager archiverModel:modle ];
        
         [JPUSHService setAlias:@"tuichudenglu" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [MobClick profileSignOff];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            DeLog(@"退出成功");
        }
        
        if(kUserId.length == 0){
            //检查是否登录
            LoginViewController * lvc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            BaseNavigationController * nvc = [[BaseNavigationController alloc]initWithRootViewController:lvc];
            [self presentViewController:nvc animated:YES completion:^{
            }];
            
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_titles[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SettingCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =_titles[indexPath.section][indexPath.row];

   
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = YIWANG_LIGHT_GRAY_COLOR;
//        [[AppManager sharedManager] getCurrentVerison]
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[AppManager sharedManager] getCurrentVerison]];
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = kThemeColor;
        NSString * cacheSize = [MCCacheTool cacheSize];
        cell.detailTextLabel.text = cacheSize;
    }
    
    if(indexPath.section == 0 && indexPath.row == 4){
        cell.accessoryType= UITableViewCellAccessoryNone;

        UISwitch * swi = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [swi addTarget:self action:@selector(swiChangeValueAction:) forControlEvents:UIControlEventValueChanged];
        swi.centerY = 25.0f;
//        swi.x = kScreenWidth - 10 - 40;
        swi.right = kScreenWidth - 10;
        [cell addSubview:swi];
    
    }
    
    return cell;
}

- (void)swiChangeValueAction:(UISwitch *)swi{
     if(swi.on){
         
         
        [JPUSHService setAlias:kPhone callbackSelector:nil object:self];
         
         
         
     }else{
         [JPUSHService setAlias:@"tuichudenglu" callbackSelector:nil object:self];
     }
    
    
    
 }



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * key = _titles[indexPath.section][indexPath.row];

    if (indexPath.section == 0) {

        /**
         static NSString * kCecheKey = @"清除缓存";
         static NSString * kShareKey = @"推荐给好友";
         static NSString * kSettingPayPassWordKey = @"设置支付密码";
         static NSString * kChengePayPassWordKey = @"修改平台支付密码";
         static NSString * kChengePassWordKey = @"修改登录密码";
         */
        
        if (kUserId.length == 0) {
            if (indexPath.row == 0){
                UITableViewCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
                
                [self showText:@"清除缓存中"];
                
                [MCCacheTool deleateCache:^{
                    [self showSuccessText:@"清除成功"];
                    NSString * cacheSize = [MCCacheTool cacheSize];
                    cell.detailTextLabel.text = cacheSize;
                }];
            }else if (indexPath.row == 1){
                [self shareWithUMengWithVC:self withImage:nil withID:nil
                                 withTitle:@"七小服"
                                  withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];
            }
        }else{
            if (indexPath.row == 0){
                if (_state == 1){
                    SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
                    vc.title =kChengePayPassWordKey;
                    vc.isSetNewPassWord = YES;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
                    vc.title =kSettingPayPassWordKey;
                    vc.isSetNewPassWord = NO;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (indexPath.row == 1){
                [Utool verifyLogin:self LogonBlock:^{
                    
                    if ([_is_real intValue] == 0) {
                        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您尚未进行实名认证,认证之后才能接单,要立即去认证吗?" cancelButtonTitle:@"先等等" clickButton:^(NSInteger buttonIndex) {
                            
                            if(buttonIndex == 1){
                                
                                CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            
                        } otherButtonTitles:@"去认证"];
                        [alert show];
                        
                    }else{
                    
                        ChangePassViewController * vc = [[ChangePassViewController alloc]initWithNibName:@"ChangePassViewController" bundle:nil ];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            
            }else if (indexPath.row == 2){
                UITableViewCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
                
                [self showText:@"清除缓存中"];
                
                [MCCacheTool deleateCache:^{
                    [self showSuccessText:@"清除成功"];
                    NSString * cacheSize = [MCCacheTool cacheSize];
                    cell.detailTextLabel.text = cacheSize;
                }];
            }else if (indexPath.row == 3){
                [self shareWithUMengWithVC:self withImage:nil withID:nil
                                 withTitle:@"七小服"
                                  withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];
            }
        }
        
        /*
        if ([key isEqualToString:kCecheKey]) {
            UITableViewCell * cell  = [tableView cellForRowAtIndexPath:indexPath];
            
            [self showText:@"清除缓存中"];
            
            [MCCacheTool deleateCache:^{
                [self showSuccessText:@"清除成功"];
                NSString * cacheSize = [MCCacheTool cacheSize];
                cell.detailTextLabel.text = cacheSize;
            }];
        }
        if ([key isEqualToString:kShareKey]) {
            [self shareWithUMengWithVC:self withImage:nil withID:nil
                             withTitle:@"七小服"
                              withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];
        }
        
        if ([key isEqualToString:kSettingPayPassWordKey]) {
            
            SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
            vc.title =kSettingPayPassWordKey;
            vc.isSetNewPassWord = NO;
             [self.navigationController pushViewController:vc animated:YES];

        }
        
        if ([key isEqualToString:kChengePayPassWordKey]) {
//            kTipAlert( @"修改平台支付密码");
            SettingPayPassWordViewController * vc = [[SettingPayPassWordViewController alloc]initWithNibName:@"SettingPayPassWordViewController" bundle:nil];
            vc.title =kChengePayPassWordKey;
            vc.isSetNewPassWord = YES;

            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([key isEqualToString:kChengePassWordKey]) {
            
            
            [Utool verifyLogin:self LogonBlock:^{
                
                if (_is_real == 0) {
                    BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"您尚未进行实名认证,认证之后才能接单,要立即去认证吗?" cancelButtonTitle:@"先等等" clickButton:^(NSInteger buttonIndex) {
                        
                        if(buttonIndex == 1){
                            
                            CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } otherButtonTitles:@"去认证"];
                    [alert show];
                    
                }else{
                    
                    ChangePassViewController * vc = [[ChangePassViewController alloc]initWithNibName:@"ChangePassViewController" bundle:nil ];
                    [self.navigationController pushViewController:vc animated:YES];
                 }
              }];
          }
        */
     }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            XieYiViewController * vc =[[XieYiViewController alloc]init];
            vc.title =key;
            vc.type = 5;
            [self.navigationController pushViewController:vc animated:YES];
//            AboutViewController * aboutVC = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil ];
//            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        if (indexPath.row == 1){
            // 版本号
            
        }
        
        if (indexPath.row == 2) {
            [self evaluate];
        }
    }
    if (indexPath.section == 2) {
        
        
        
//        if (indexPath.row == 0) {
//            [Utool verifyLogin:self LogonBlock:^{
//                FeedbackViewController * feedbackViewController = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
//                feedbackViewController.title =key;
//                [self.navigationController pushViewController:feedbackViewController animated:YES];
//            }];
//        }
//        if (indexPath.row == 0) {
//            
//            
//            [Utool verifyLogin:self LogonBlock:^{
//                
//            ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:@"kefu1" friendUsername:@"客服"
//            friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage]
//            user:kPhone
//            userName:kUserName
//            userIcon:kUserIcon];
//                chatController.title = @"客服";
//                chatController.friendIcon = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage];
//                chatController.userIcon = kUserIcon;
//                [self.navigationController pushViewController:chatController animated:YES];
//                
//                
//            }];
//
//     
//        }
//        if (indexPath.row == 1) {
//            XieYiViewController * vc =[[XieYiViewController alloc]init];
//            vc.title =key;
//            vc.type = 3;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
        if (indexPath.row == 0) {
            XieYiViewController * vc =[[XieYiViewController alloc]init];
            vc.title =key;
            vc.type = 1;
             [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            XieYiViewController * vc =[[XieYiViewController alloc]init];
            vc.title =key;
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2) {
            //意见反馈
            SendOrder1ViewController * vc = [[SendOrder1ViewController alloc]initWithNibName:@"SendOrder1ViewController" bundle:nil ];
            vc.isFeedBack = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 3) {
            //帮助中心
            self.helpTextView.contentOffset = CGPointMake(0, 0);
            self.helpView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1);
            self.helpView.hidden = NO;
            
            [UIView animateWithDuration:1.0 animations:^{
                self.helpView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                self.helpView.alpha = 1;
            } completion:^(BOOL finished) {
               
           }];
            
            
        }

    }
    
}

#pragma  mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:1.0 animations:^{
        self.helpView.layer.transform = CATransform3DMakeScale(2, 2, 2);
        self.helpView.alpha = 0;
    } completion:^(BOOL finished) {
        self.helpView.hidden = YES;
    }];

    return NO;
}


- (void)evaluate{
    //初始化控制器
    SKStoreProductViewController * storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier :@"1171281585"} completionBlock:^(BOOL result, NSError * error) {
         //block回调
         if(error){
             DeLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}
//取消按钮监听

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 ) {
        return 10.0;
     }
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
