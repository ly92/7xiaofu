//
//  SubjectNumberView.h
//  BeautifulFaceProject
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectNumberView : UIView

+ (SubjectNumberView *)footerView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *addSubToolView;
 
- (void)hidenView;


@property(nonatomic, copy) void (^subjectNumberViewBlock)(NSInteger count);


@end
