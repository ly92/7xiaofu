//
//  PickerViewCell.h
//  CollectionViewSelect
//
//  Created by admin on 15/10/19.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FilterCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (nonatomic, strong) User* user;
@property (nonatomic) BOOL disabled;

@end


