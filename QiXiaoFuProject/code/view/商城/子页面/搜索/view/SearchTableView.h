//
//  SearchTableView.h
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableView : UITableView
+ (SearchTableView *)contentTableView;
// 数据源
@property (nonatomic, strong) NSArray *dataArray;


@property(nonatomic, copy) void (^searchTableViewBlock)(NSString * key);



@end
