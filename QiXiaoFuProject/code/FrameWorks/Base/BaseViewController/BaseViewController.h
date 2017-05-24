//
//  BaseViewController.h
//  TomtaoProject
//
//  Created by MiniC on 15/7/16.
//  Copyright (c) 2015年 hongjian_feng. All rights reserved.
//

#import "ParentsViewController.h"

@interface BaseViewController : ParentsViewController

//default YES;
@property (nonatomic) BOOL endEditingWhenTap;



-(void)shareWithUMengWithVC:(UIViewController *)vc withImage:(UIImage *)image withID:(NSString *)detaileId  withTitle:(NSString *)title withDesc:(NSString *)desc withShareUrl:(NSString *)shareUrl withType:(NSInteger)type;

@end
