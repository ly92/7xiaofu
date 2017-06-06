//
//  MeHeadReusableView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/8/26.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeHeadReusableView : UICollectionReusableView

// 登录情况下使用该view
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLbl;

@property (weak, nonatomic) IBOutlet UIButton *headerImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// 已认证  selected   未认证  default
@property (weak, nonatomic) IBOutlet UIButton *aouthBtn;

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;

/**
 *  钱包
 */
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;

/**
 *  收藏
 */
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
/**
 *  购物车
 */
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
/**
 *  签到
 */
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

/**
 *  积分
 */
@property (weak, nonatomic) IBOutlet UIButton *creditsBtn;
/**
 *  福券
 */
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;


// 没有登录情况下  使用该view
@property (weak, nonatomic) IBOutlet UIView *noLoginView;
@property (weak, nonatomic) IBOutlet UIButton *logonBtn;



@end
