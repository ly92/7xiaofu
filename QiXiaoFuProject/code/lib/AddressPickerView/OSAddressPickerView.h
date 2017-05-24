//
//  OSAddressPickerView.h
//  AddressPicker
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 筒子家族. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^AdressBlock)(NSString *province, NSString *city, NSString *district);

@interface OSAddressPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,copy) AdressBlock block;

+ (id)shareInstance;
- (void)showBottomView;

@end



/*
 
 
 1.  #import "OSAddressPickerView.h"

 2.      OSAddressPickerView *_pickerview;

 
 3    pickerview = [OSAddressPickerView shareInstance];
     [_pickerview showBottomView];
     [self.view addSubview:_pickerview];
     _pickerview.block = ^(NSString *province,NSString *city,NSString *district)
     {
            NSString * adress = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];

     };
 
 */