//
//  EditAdressMarkCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCTextView.h"

@interface EditAdressMarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet MCTextView *textView;


@property(nonatomic, copy) void (^editAdressMarkCellBlock)(NSString  * content);


@end
