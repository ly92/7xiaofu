//
//  FilterView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/1.
//  Copyright © 2016年 fhj. All rights reserved.
// 右侧弹出的过滤视图

#import <UIKit/UIKit.h>

@class FilterView;


@protocol FilterViewDelegate <NSObject>

- (void)contactsPickerViewControllerdismis:(FilterView *)controller ;

- (void)pickerViewControllerdismis:(NSDictionary *)dict ;



@end


@interface FilterView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *trueBtn;


// 服务类型
@property (nonatomic, strong) NSSet* selectedServiceTypeIds;// 用于传入默认选中的服务类型的数据
@property (nonatomic, strong) NSSet* disabledServiceTypeIds; // 用于存储服务类型

// 服务地点
@property (nonatomic, strong) NSSet* selectedServiceAdressIds;// 用于传入默认选中的服务地点的数据
@property (nonatomic, strong) NSSet* disabledServiceAdressIds; // 用于存储服务地点
@property (nonatomic, strong) id<FilterViewDelegate>delegate;


@property(nonatomic, copy) void (^filterViewBlock)(NSDictionary * dict);


@property(nonatomic, copy) void (^filterViewScrollBlock)();





@end
