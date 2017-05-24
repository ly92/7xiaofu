//
//  XWConstomNavBar.m
//  新闻
//
//  Created by user on 15/10/3.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "BaseConstomNavBar.h"

@implementation BaseConstomNavBar

-(instancetype)init
{
    self=[super init];
    if(self){
        [self setupFirst];
    }
    return self;
}

-(void)setupFirst
{
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(0, 0, kScreenWidth, 64);
    //底部添加一条线
    UIImageView *line=[[UIImageView alloc]init];
    line.backgroundColor=RGBA(20, 20, 20, 0.3);
    [self addSubview:line];
    line.frame=CGRectMake(0, self.frame.size.height-0.3, self.frame.size.width, 0.3);
}

@end
