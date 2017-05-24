//
//  ShopFilterView.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopFilterView;


@protocol ShopFilterViewDelegate <NSObject>

- (void)contactsPickerViewControllerdismis:(ShopFilterView *)controller ;

- (void)pickerViewControllerdismis:(NSDictionary *)dict ;



@end



@interface ShopFilterView : UIView


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *trueBtn;

// 服务类型
@property (nonatomic, strong) NSSet* selectedServiceTypeIds;// 用于传入默认选中的服务类型的数据
@property (nonatomic, strong) NSSet* disabledServiceTypeIds; // 用于存储服务类型

// 服务地点
@property (nonatomic, strong) NSSet* selectedServiceAdressIds;// 用于传入默认选中的服务地点的数据
@property (nonatomic, strong) NSSet* disabledServiceAdressIds; // 用于存储服务地点
@property (nonatomic, strong) id<ShopFilterViewDelegate>delegate;


@property (nonatomic, strong) NSArray *dataArray;// 商品筛选地区



@property(nonatomic, copy) void (^shopFilterViewBlock)(NSArray * idArray);


@end
