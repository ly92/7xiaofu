//
//  SendOrder1UpImageCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendOrder1UpImageCell : UITableViewCell

@property (nonatomic, strong) NSArray *imageArray;


@property (nonatomic,assign) NSInteger type;// 1 发单  2 重新发布


@property(nonatomic, copy) void (^sendOrder1UpImageCellBlock)(NSMutableArray * imageArray);


@end
