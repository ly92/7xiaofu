//
//  XCFTextField.h
//  XCFApp
//
//  Created by rkxt_ios on 15/12/4.
//  Copyright © 2015年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface MCTextField : UITextField

@property (nonatomic,assign) NSInteger subTag;

+ (MCTextField *)textFieldWithFrame:(CGRect)frame
                         placeholder:(NSString *)placeholder;









@end
