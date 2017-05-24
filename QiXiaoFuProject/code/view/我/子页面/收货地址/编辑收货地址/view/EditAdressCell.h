//
//  EditAdressCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAdressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong,nonatomic) NSIndexPath * indexPath;


@property(nonatomic, copy) void (^editAdressCellBlock)(NSString  * content,BOOL pass);


@end
