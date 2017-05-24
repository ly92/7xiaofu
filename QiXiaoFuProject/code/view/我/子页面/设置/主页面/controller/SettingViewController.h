//
//  SettingViewController.h
//  BeautifulFaceProject
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController
@property (nonatomic, assign) NSInteger state;  // state =1  是有密码，state=0无密码

@property (nonatomic, assign) NSInteger is_real;  // is_real 是否实名认证【0 否 1 是】

@property (nonatomic, copy) NSString * userHeader;  //用户头像 -- 用于环信头像
@property (nonatomic, copy) NSString * userName;  //用户昵称 -- 用于环信头像


@end
