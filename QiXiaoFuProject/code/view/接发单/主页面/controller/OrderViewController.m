//
//  OrderViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderViewController.h"
#import "EngineerCollectionView.h"
#import "CustomersCollectionView.h"
#import "YLSwitch.h"
#import "ProductListViewController.h"
#import "ReceivingOrderListViewController.h"
#import "EngineerListViewController.h"
#import "BlockUIAlertView.h"
#import "SendOrderViewController.h"
#import "PayViewController.h"
#import "RecommendEngineerListVC.h"
#import "CertificationViewController.h"
#import "OrderMainModel.h"
#import "ProductDetaileViewController.h"
#import "EngineerDetaileViewController.h"
#import "EngineerListViewController.h"
#import "ShopPaySuccViewController.h"

#import "MatchingEngineerListVC.h"

@interface OrderViewController ()<YLSwitchDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,strong) EngineerCollectionView * engineerCollectionView;
@property (nonatomic ,strong) CustomersCollectionView * customersCollectionView;
@property (nonatomic ,strong) YLSwitch * switchSegment;
@property (nonatomic, strong) OrderMainModel * orderMainModel;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"接发单首页";
//    NSArray * engineerTitles = @[@"Unix服务器",@"X86服务器",@"存储设备",@"网络交换设备",@"监控设备",@"虚拟化",@"桌面设备",@"数据库",@"安全",@"其他"];
//    NSArray * imageArray =@[@"home_icon_unix",@"home_icon_x86",@"home_icon_store",@"home_icon_web",@"home_icon_jiankong",@"home_icon_xunihua",@"home_icon_desk",@"home_icon_datebase",@"home_icon_safe",@"icon_others"];
 
    [self switchSegment];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    [self engineerCollectionView];
    [self customersCollectionView];


//    _engineerCollectionView.dataArray =engineerTitles;
//    _customersCollectionView.dataArray =engineerTitles;
//    _engineerCollectionView.imageArray =imageArray;
//    _customersCollectionView.imageArray =imageArray;

    [self initNavRighttItemWithType:0];
    
    WEAKSELF
    // 工程师
    _engineerCollectionView.didselectItemsEngineerCollectionViewBlock = ^(NSString * title,NSString * gc_id){
        ProductListViewController * vc= [[ProductListViewController alloc]initWithNibName:@"ProductListViewController" bundle:nil];
        vc.navigationItem.title = title;
        vc.gc_id = gc_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    _engineerCollectionView.didselectItemsEngineerCollectionViewHeader_t_id_Block = ^(NSString * t_id){
        
        // 项目详情
         ProductDetaileViewController * vc  = [[ProductDetaileViewController alloc]initWithNibName:@"ProductDetaileViewController" bundle:nil];
         vc.p_id =t_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };

    _engineerCollectionView.didselectItemsEngineerCollectionViewHeader_moreBtn_Block = ^(){
        // 项目列表
        RecommendEngineerListVC * vc= [[RecommendEngineerListVC alloc]initWithNibName:@"RecommendEngineerListVC" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };

    
    //  客户
    _customersCollectionView.didselectItemsCustomersCollectionViewBlock = ^(NSString * title,NSString * gc_id){
        
        EngineerListViewController * vc= [[EngineerListViewController alloc]initWithNibName:@"EngineerListViewController" bundle:nil];
         vc.navigationItem.title = title;
         vc.gc_id = gc_id;
         [weakSelf.navigationController pushViewController:vc animated:YES];

    };
    _customersCollectionView.didselectItemsCustomersCollectionViewHeader_t_id_Block = ^(NSString * t_id){
        // 工程师详情
        EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
        vc.member_id = t_id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
               
    };
    _customersCollectionView.didselectItemsCustomersCollectionViewHeader_moreBtn_Block = ^(){
        // 工程师列表
        EngineerListViewController * vc= [[EngineerListViewController alloc]initWithNibName:@"EngineerListViewController" bundle:nil];
        vc.navigationItem.title = @"小七推荐";
        vc.type =1 ;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };


    [self loadMainData];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    //
    [Utool verifyLogin:self LogonBlock:^{
        
    }];
    
    if (_orderMainModel == nil) {
        [self loadMainData];
    }
}



- (void)loadMainData{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    [MCNetTool postWithCacheUrl:HttpMain params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _orderMainModel = [OrderMainModel mj_objectWithKeyValues:requestDic];
        _engineerCollectionView.orderMainModel =_orderMainModel;
        _customersCollectionView.orderMainModel =_orderMainModel;
        _engineerCollectionView.dataArray =_orderMainModel.class_list;
        _customersCollectionView.dataArray =_orderMainModel.class_list;
        
    } fail:^(NSString *error) {
        
    }];




}

- (YLSwitch *)switchSegment{
    if (!_switchSegment) {
        _switchSegment = [[YLSwitch alloc] initWithFrame:CGRectMake(0, 0, 111, 30)];
        _switchSegment.delegate = self;
        _switchSegment.leftTitle = @"工程师";
        _switchSegment.rightTitle = @"客户";
         _switchSegment.bgColor = RGB(223, 81, 50);
        _switchSegment.thumbColor = [UIColor whiteColor];
        self.navigationItem.titleView  = _switchSegment;
      }
    return _switchSegment;
}

#pragma mark -- YLSwitchDelegate

- (void)switchState:(NSInteger)state title:(NSString *)title{
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * state, 0) animated:YES];
    [self initNavRighttItemWithType:state];
}

#pragma mark - 加载工程师视图
- (EngineerCollectionView *)engineerCollectionView{
    if (!_engineerCollectionView) {
        _engineerCollectionView = [EngineerCollectionView engineerCollectionView];
        _engineerCollectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64- 49);
        [_scrollView addSubview:_engineerCollectionView];
    }
    return _engineerCollectionView;
}
#pragma mark - 加载客户视图
- (CustomersCollectionView *)customersCollectionView{
    if (!_customersCollectionView) {
        _customersCollectionView = [CustomersCollectionView customersCollectionView];
        _customersCollectionView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64- 49);
        [_scrollView addSubview:_customersCollectionView];
    }
    return _customersCollectionView;
}


#pragma mark - 添加导航按钮-- 接单

- (void)initNavRighttItemWithType:(NSInteger )type{

    if(type == 0){
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"接单" target:self action:@selector(rightJieItemAction:)];
    
    }else{
        self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"发单" target:self action:@selector(rightFaItemAction:)];
;
    }
}

- (void)rightJieItemAction:(UIBarButtonItem *)item{

    [Utool verifyLoginAndCertification:self LogonBlock:^{
        
        ReceivingOrderListViewController * vc = [[ReceivingOrderListViewController alloc]initWithNibName:@"ReceivingOrderListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    } CertificationBlock:^{
        
        CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    
 
}
- (void)rightFaItemAction:(UIBarButtonItem *)item{
  
    [Utool verifyLoginAndCertification:self LogonBlock:^{
        
        SendOrderViewController * vc = [[SendOrderViewController alloc]initWithNibName:@"SendOrderViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    } CertificationBlock:^{
        
        CertificationViewController * vc = [[CertificationViewController alloc]initWithNibName:@"CertificationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width <= kScreenWidth) {
        return;
    }
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger ratio = round(offSetX / kScreenWidth);
    [_switchSegment jumpto:ratio];
    [self initNavRighttItemWithType:ratio];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
