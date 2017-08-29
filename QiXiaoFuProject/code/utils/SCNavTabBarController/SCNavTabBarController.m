
// 顶部导航栏
// 视图




#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"
#import "SendOrderViewController.h"
#import "CertificationViewController.h"
#import "ReplacementOrderViewController.h"


#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)


@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate>
{
    NSInteger       _currentIndex;
    NSMutableArray  *_titles;
    NSMutableArray  *_mutableDataArr;
    
    SCNavTabBar     *_navTabBar;
    UIScrollView    *_mainView;
}



@end

@implementation SCNavTabBarController

#pragma mark -- 利用标题 和 类名 初始化
-(instancetype)initWithTitleArr:(NSArray *)titleArr andClass:(Class)contentClass{
    if (self=[super init]) {
        
        
        [self initControlWithTitelArr:titleArr andClass:contentClass];
        [self viewConfig];
    }
    
    return self;

}
#pragma mark -- 利用标题 和 内容控制器数组 初始化
-(instancetype)initWithTitleArr:(NSArray *)titleArr andContentArr:(NSArray *)contentClassArr{
 
    if (self=[super init]) {
        
        
        [self initControlWithTitelArr:titleArr andContentArr:contentClassArr];
        [self viewConfig];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};

}


//导航栏右侧按钮  1我的发单  2我的接单
- (void)customerItemActionType:(int)index{
    if (index == 1){
        self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"发单" target:self action:@selector(sendOrder)];
    }else if (index == 2){
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"补单" target:self action:@selector(receiveOrder)];
    }
}

- (void)receiveOrder{
     UserInfoModel * user = [UserManager readModel];
    if ([user.member_level isEqualToString:@"A"] || [user.member_level isEqualToString:@"DA"]){
        [self showErrorText:@"当前用户为A用户，不可补单！"];
        return;
    }
    ReplacementOrderViewController * vc  = [[ReplacementOrderViewController alloc]initWithNibName:@"ReplacementOrderViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendOrder{
    [Utool verifyLoginAndCertification:self LogonBlock:^{
        
        SendOrderViewController * vc = [[SendOrderViewController alloc]initWithNibName:@"SendOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    } CertificationBlock:^{
        
        CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];

}


#pragma mark --用来区分子控制器里数据的数组
-(void)setRequestDataKeyArr:(NSArray *)dataKeyArr{

    _mutableDataArr =[NSMutableArray arrayWithArray:dataKeyArr];
    if (_subViewControllers) {
        for (int i=0; i<_subViewControllers.count; i++) {
            
            
            if ([_subViewControllers[i] isKindOfClass:[ShopOrderViewController class]]) {//商城订单
                
                ShopOrderViewController *shopOrderVC = _subViewControllers[i];
                
               shopOrderVC.shoppingOrderStatus= ((NSNumber *)_mutableDataArr[i]).integerValue;
                
            }else if ([_subViewControllers[i] isKindOfClass:[MySendOrderViewController class]]){//我的发单
              
                [self customerItemActionType:1];
                
                MySendOrderViewController *sendOrderVC=_subViewControllers[i];
                
                sendOrderVC.sendOrderStatus =((NSNumber *)_mutableDataArr[i]).integerValue;
            
            }else if ([_subViewControllers[i] isKindOfClass:[MyReceivingOrderViewController  class]]){//我的接单
                [self customerItemActionType:2];
                MyReceivingOrderViewController *receiveOrderVC=_subViewControllers[i];
                
                receiveOrderVC.receiveOrderStatus =((NSNumber *)_mutableDataArr[i]).integerValue;
                
            }
            
        }
    }

}



//单一内容控制器的情况
-(void)initControlWithTitelArr:(NSArray *)titleArr andClass:(Class)contentClass{

  
    NSMutableArray *viewArray = [NSMutableArray array];

    for(int i = 0; i < titleArr.count; i++)
    {
       // 视图控制器装箱
       id instanceObject =  [[contentClass alloc] init];
        [viewArray addObject:instanceObject];
    }
    
    _subViewControllers = [NSArray array];
    _subViewControllers = viewArray;
    
//    _currentIndex = 1;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
   
    _titles = titleArr.mutableCopy;
}

//多内容控制器的情况
-(void)initControlWithTitelArr:(NSArray *)titleArr andContentArr:(NSArray *)contentArr{
    
    _subViewControllers = [NSArray array];
    _subViewControllers = contentArr;
    
    //    _currentIndex = 1;
    
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    
    _titles = titleArr.mutableCopy;
}

- (void)viewConfig
{
    [self tabBarAndScrollViewInit];
    
    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, _mainView.bounds.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)tabBarAndScrollViewInit
{
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 44)];
    _navTabBar.backgroundColor = [UIColor whiteColor];
    _navTabBar.delegate = self;
    _navTabBar.lineColor = [UIColor redColor];
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 从导航栏底部开始布局 减去导航栏的高度 减去navTabBar的高度
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44-64)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    linev.backgroundColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha:1];
    [self.view addSubview:linev];
    

}

#pragma mark -- 重写setter方法
-(void)setNavTabBarColor:(UIColor *)navTabBarColor{

    _navTabBarColor = navTabBarColor;
    
    _navTabBar.backgroundColor=navTabBarColor;
}

-(void)setNavTabBarLineColor:(UIColor *)navTabBarLineColor{

    _navTabBarLineColor = navTabBarLineColor;
    
    _navTabBar.lineColor = navTabBarLineColor;
}

-(void)setMainViewBounces:(BOOL)mainViewBounces{

    _mainViewBounces = mainViewBounces;
    
    _mainView.bounces = mainViewBounces;
}


#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    //setter方法做了处理
    _navTabBar.currentItemIndex = _currentIndex;

    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainView.frame.size.height);
    //一个控制器实例的视图只会被添加一次
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

#pragma mark scrollView已经停止减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{


}

#pragma mark --SCNavTabBarDelegate

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SCNavTabBarControllerItemDidChanged" object:nil];
    
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
    }else{
        [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:NO];
    }
}



@end

