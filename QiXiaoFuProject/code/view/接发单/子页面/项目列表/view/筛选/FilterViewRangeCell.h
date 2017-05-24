//
//  AXPriceRangeCell.h
//  AXBaseMall
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewRangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *priceText1;
@property (weak, nonatomic) IBOutlet UITextField *priceText2;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;


@property(nonatomic, copy) void (^aXPriceRange1CellBlock)(NSString * price);

@property(nonatomic, copy) void (^aXPriceRange2CellBlock)(NSString * price);

@end



