//
//  SearchViewControler.h
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchViewControler : BaseViewController

@property (nonatomic, assign) NSInteger type;// 1 项目列表  2 商城

@property(nonatomic, copy) void (^searchViewBlock)(NSString * searchKey);



@end
