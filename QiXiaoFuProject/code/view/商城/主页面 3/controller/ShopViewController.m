//
//  ShopViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopViewController.h"
#import "MCBannerView.h"
#import "LeftTableViewCell.h"
#import "RightCollectionViewCell.h"
#import "ShopMainModel.h"
#import "ShopListModel.h"
#import "SubjectViewController.h"



@interface ShopViewController ()<MCBannerViewDataSource, MCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic)  UIView *bottomView;

@property (nonatomic, strong) MCBannerView *banner;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic ,strong) NSArray * class1_listArray;
@property (nonatomic ,strong) NSMutableArray *class_listArray;

@property (nonatomic, strong) UICollectionView *rightCollectionView;
//@property (nonatomic ,strong) NSMutableArray * shopListArray;




@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.fd_prefersNavigationBarHidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    _shopListArray = [NSMutableArray new];
    
    _class_listArray = [NSMutableArray new];

    [self banner];
    

    [self addNavTitleView];
    
//    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 170)];
//    headerView.backgroundColor = [UIColor orangeColor];
//    _tableView.tableHeaderView =headerView;

    _bottomView= [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - 170 - 49)];
    _bottomView.backgroundColor = [UIColor greenColor];
    _tableView.tableFooterView =_bottomView;

     [self categoryTableView];
    [self rightCollectionView];
    
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";
    params[@"gc_id"] = @"0";
    
    [MCNetTool postWithCacheUrl:HttpShopClass params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShopMainModel * shopMainModel = [ShopMainModel mj_objectWithKeyValues:requestDic];
        _bannerArray = shopMainModel.banner_list;
        
    // 全部产品 列表
        _class1_listArray =shopMainModel.class_list;
        
        [_banner reloadData];
        [_categoryTableView reloadData];
        
        
    } fail:^(NSString *error) {
        
    }];
    

    // Do any additional setup after loading the view from its nib.
}



- (void)loadShopListWithGc_id:(NSString *)gc_id{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";
    params[@"gc_id"] = gc_id;
    
    [MCNetTool postWithCacheUrl:HttpShopClass params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShopMainModel * shopMainModel = [ShopMainModel mj_objectWithKeyValues:requestDic];
        [_class_listArray setArray:shopMainModel.class_list];
        [_rightCollectionView reloadData];
        
    } fail:^(NSString *error) {
        
    }];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}


- (void)addNavTitleView{

    UITextField * searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 300, 34)];
    searchTextField.placeholder = @"输入商品品牌、名称、类别进行搜索";
    self.navigationItem.titleView = searchTextField;
    
    
    UIImageView * leftview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    leftview.image = [UIImage imageNamed:@"icon_search"];
    searchTextField.leftView = leftview;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;

}



#pragma mark - 初始化广告视图
- (MCBannerView *)banner{
    if (!_banner) {
        _banner = [[MCBannerView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,160)];
        _banner.dataSource = self;
        _banner.delegate = self;
        _banner.shouldLoop = YES;
        _banner.showFooter = NO;
        _banner.autoScroll = YES;
        _tableView.tableHeaderView =_banner;
    }
    return _banner;
}

#pragma mark - 初始化分类列表
- (UITableView *)categoryTableView{
    if (!_categoryTableView) {
        
        _categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3,_bottomView.height) style:UITableViewStylePlain];
        _categoryTableView.delegate = self;
        _categoryTableView.dataSource = self;
        _categoryTableView.scrollEnabled = YES;
        _categoryTableView.tableFooterView = [UIView new];
        [_categoryTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_bottomView addSubview:_categoryTableView];
    }
    return _categoryTableView;
}
#pragma mark - 初始化右侧视图
- (UICollectionView *)rightCollectionView{

    if (!_rightCollectionView) {
         UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
         flowayout.minimumInteritemSpacing = 0.f;
        flowayout.minimumLineSpacing = 0.5f;
         _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kScreenWidth/3, 0, kScreenWidth/3*2, _bottomView.frame.size.height) collectionViewLayout:flowayout];
         [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
        [_rightCollectionView setBackgroundColor:[UIColor clearColor]];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
         [_bottomView addSubview:_rightCollectionView];

    }

    return _rightCollectionView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _class1_listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    Class_List * class_list =_class1_listArray[indexPath.row];
    cell.tableview_textLabel.text =class_list.gc_name;
    cell.selectionStyle = 1;//设置Cell选中效果
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_rightCollectionView scrollRectToVisible:CGRectMake(0, 0, self.rightCollectionView.frame.size.width, self.rightCollectionView.frame.size.height) animated:YES];
    
    Class_List * class_list =_class1_listArray[indexPath.row];
    [self loadShopListWithGc_id:class_list.gc_id];
    
}


#pragma mark------UICollectionViewDataSource UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _class_listArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
   
    Class_List * class_list =_class_listArray[indexPath.row];
    [cell.collectionView_imageview setImageWithUrl:class_list.gc_image placeholder:nil];
    cell.collectionView_Label.text =class_list.gc_name;
    return cell;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth/3*2 - 30)/2, (kScreenWidth/3*2 - 30)/2);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Class_List * class_list =_class_listArray[indexPath.row];

    
    SubjectViewController * vc = [[SubjectViewController alloc]initWithNibName:@"SubjectViewController" bundle:nil];
    vc.gc_id =class_list.gc_id;
    vc.navigationItem.title = class_list.gc_name;
    [self.navigationController pushViewController:vc animated:YES];

    

}





#pragma mark - ZYBannerViewDataSource
// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(MCBannerView *)banner
{
    return _bannerArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(MCBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
        Banner_List * bannerModel = _bannerArray[index];
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithUrl:bannerModel.banner_image placeholder:nil];
    imageView.tag = 100;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(MCBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    DeLog(@"点击了第%ld个项目", (long)index);
 

    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:YES];

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
