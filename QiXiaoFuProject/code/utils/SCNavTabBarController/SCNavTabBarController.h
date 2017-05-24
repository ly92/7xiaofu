
// 可以左右滑动的容器视图（类似网易首页效果）
// 应用在接单列表 发单列表  商品列表

#import <UIKit/UIKit.h>
#import "ShopOrderViewController.h"
#import "MySendOrderViewController.h"
#import "MyReceivingOrderViewController.h"

@class SCNavTabBar;

@interface SCNavTabBarController : UIViewController

//滑动切换两个选项卡时候的切换
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO

//scrollView的回弹
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO

@property (nonatomic, strong)NSArray *subViewControllers;

//背景色
@property (nonatomic, strong)UIColor  *navTabBarColor;
//滑动指示器的颜色
@property (nonatomic, strong)UIColor  *navTabBarLineColor;



/**

 @param titleArr  标题数组
 @param contentClass 容器内装的控制器(都是同一类型的控制器的情况)
 */
-(instancetype)initWithTitleArr:(NSArray *)titleArr andClass:(Class)contentClass;


/**
 
 @param titleArr  标题数组
 @param contentArr 容器内装的控制器数组(多类型的控制器的情况)
 */
-(instancetype)initWithTitleArr:(NSArray *)titleArr andContentArr:(NSArray *)contentClassArr;


/**
   scrollView里面盛放的控制器数据不会一样

 @param dataKeyArr 用来区分scrollView里面盛放的控制器数据的数组 例如 state_type 1为待付款 2为待发货
 */
-(void)setRequestDataKeyArr:(NSArray *)dataKeyArr;


#pragma mark --SCNavTabBarDelegate
//可以让进入的页面不是第一个，指定一个特定的偏移
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;
@end


