//
//  UserInfoUpImageCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel1.h"
@interface UserInfoUpImageCell : UITableViewCell

@property (nonatomic, strong) UserInfoModel1 * userInfoModel1;


@property(nonatomic, copy) void (^userInfoUpImageCell)(NSInteger depth,NSString * imageUrl,NSString * zhengshuname,NSString * cer_id );


@end
