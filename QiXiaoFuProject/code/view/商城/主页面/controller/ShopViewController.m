//
//  ShopViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 fhj. All rights reserved.
//  FIXME: 左侧列表第一个是全部 剩下的是列表  点击请求数据 如果切换过快 列表切全部 列表数据返回慢，全部数据返回快，会导致显示的是列表数据，因为走了一遍全部回调，再走一遍列表回调,需要加入PDHud

#import "ShopViewController.h"
#import "MCBannerView.h"
#import "LeftTableViewCell.h"
#import "RightCollectionViewCell.h"
#import "ShopMainModel.h"
#import "ShopListModel.h"
#import "SubjectViewController.h"
#import "YWWebScrollView.h"
#import "SearchViewControler.h"
#import "SearchResultViewControler.h"
#import "ShopDetaileViewController.h"
#import "CollectCell.h"


@interface ShopViewController ()<MCBannerViewDataSource, MCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    BOOL _isAllGoods;
    NSString * _gc_id;
    
}
@property (weak, nonatomic) IBOutlet UIView *bannerVire;

@property (strong, nonatomic)  UIButton *searchBtn;


@property (nonatomic, strong) MCBannerView *banner;
@property (nonatomic, strong) NSArray *bannerArray;

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@property (weak, nonatomic) IBOutlet UITableView *suspendTableView;

@property (nonatomic ,strong) NSArray * class1_listArray; //左侧列表数组
@property (nonatomic ,strong) NSMutableArray *class2_listArray;//悬浮列表数据
@property (nonatomic ,strong) NSMutableArray *class_listArray;//右侧列表数据

@property (nonatomic ,assign) NSInteger page;

@property (weak, nonatomic) IBOutlet UICollectionView *rightCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UIButton *bottomAlphaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suspendTableTopDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewRightDis;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suspengTableH;

@property (nonatomic, assign) CGFloat tableRowH;



@end

@implementation ShopViewController

- (NSMutableArray *)class_listArray{
    if(!_class_listArray){
        _class_listArray = [NSMutableArray array];
    }
    return _class_listArray;
}
- (NSMutableArray *)class2_listArray{
    if(!_class2_listArray){
        _class2_listArray = [NSMutableArray array];
    }
    return _class2_listArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _page = 1;
    _isAllGoods = YES;
    
    self.tableRowH = 55;
    
    [self banner];
    
    [self.categoryTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.suspendTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
    [self.rightCollectionView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellWithReuseIdentifier:@"CollectCell"];
    
    
    [self loadAllgoodsDataArray];//加载左侧列表和轮播数据
    
    self.page = 1;
    _gc_id = @"0";
    [self loadAllShopList];// 加载左侧全部商品对应的右侧列表数据
    
    [self addRefsh];// 刷新控件
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame =CGRectMake(0, 0, kScreenWidth - 40, 34);
    [_searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [_searchBtn setTitle:@"输入商品品牌、名称、类别进行搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_searchBtn setBackgroundImage:[UIImage imageNamed:@"searchbox"] forState:UIControlStateNormal];
    self.navigationItem.titleView = _searchBtn;
    
    [self searchBoxAction];// 搜索
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.scrollviewRightDis.constant = kScreenWidth - 90;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hideSuspendTable];
}


- (IBAction)hideSuspendTable {
    self.scrollviewRightDis.constant = kScreenWidth - 90;
    self.suspendTableView.hidden = YES;
    self.bottomAlphaView.hidden = YES;
}

- (void)showSuspendTable {
    self.scrollviewRightDis.constant = 0;
    self.suspendTableView.hidden = NO;
    self.bottomAlphaView.hidden = NO;
}

#pragma mark - 搜索

- (void)searchBoxAction{
    
    [_searchBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        SearchViewControler * vc = [[SearchViewControler alloc]init];
        vc.type = 2;
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.searchViewBlock = ^(NSString * searchKey){
            
            SearchResultViewControler * vc = [[SearchResultViewControler alloc]initWithNibName:@"SearchResultViewControler" bundle:nil];
            vc.gc_id =@"0";
            vc.keyword = searchKey;
            vc.navigationItem.title = searchKey;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        [self presentViewController:nvc animated:YES completion:^{
            
        }];
        
        
    }];
    
}



#pragma mark - 刷新
- (void)addRefsh{
    
    
    [_rightCollectionView headerAddMJRefresh:^{
        [self.class_listArray removeAllObjects];
        self.page = 1;
        [self loadAllShopList];
    }];
    
    
    [_rightCollectionView footerAddMJRefresh:^{
            [self loadAllShopList];
    }];
    

}

#pragma mark - 获取悬浮列表数据

- (void)loadShopListWithGc_id:(NSString *)gc_id{
    
    [self.class2_listArray removeAllObjects];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";
    params[@"gc_id"] = gc_id;
    //显示菊花
    [PDHud show];
    [MCNetTool postWithCacheUrl:HttpShopClass params:params success:^(NSDictionary *requestDic, NSString *msg) {
        //隐藏菊花
        [PDHud dismiss];
        
        _isAllGoods = NO;
        
        ShopMainModel * shopMainModel = [ShopMainModel mj_objectWithKeyValues:requestDic];
        [_class2_listArray setArray:shopMainModel.class_list];
        
        if (shopMainModel.class_list.count == 0){
            [self hideSuspendTable];
            self.suspengTableH.constant = 0;
        }else{
            [self showSuspendTable];
            if (self.tableRowH * shopMainModel.class_list.count > 220){
                self.suspengTableH.constant = 220;
            }else{
                self.suspengTableH.constant = self.tableRowH * shopMainModel.class_list.count;
            }
            
        }
        
        [self.suspendTableView reloadData];
    } fail:^(NSString *error) {
        //隐藏菊花
        [PDHud dismiss];
    }];
    
}



#pragma mark - 加载左侧列表和轮播数据

- (void)loadAllgoodsDataArray{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";
    params[@"gc_id"] = @"0";
    
    [MCNetTool postWithCacheUrl:HttpShopClass params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShopMainModel * shopMainModel = [ShopMainModel mj_objectWithKeyValues:requestDic];
        
        //轮播图数据
        _bannerArray = shopMainModel.banner_list;
        
        // 左侧列表数据
        _class1_listArray = shopMainModel.class_list;
        
        [_banner reloadData];
        
        if ((self.tableRowH * self.class1_listArray.count + 220) > kScreenHeight - 170 - 45){
            self.bottomViewH.constant = self.tableRowH * self.class1_listArray.count + 220;
        }else{
            self.bottomViewH.constant = kScreenHeight - 170 - 45;
        }
        
        
        [_categoryTableView reloadData];
        
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_categoryTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    } fail:^(NSString *error) {
        
    }];
    
}

#pragma mark - 初始化广告视图
- (MCBannerView *)banner{
    if (!_banner) {
        _banner = [[MCBannerView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,160)];
        _banner.dataSource = self;
        _banner.delegate = self;
        [self.bannerVire addSubview:_banner];
        _banner.shouldLoop = YES;
        _banner.showFooter = NO;
        _banner.autoScroll = YES;
    }
    return _banner;
}

//#pragma mark - 初始化左侧分类列表
//- (UITableView *)categoryTableView{
//    if (!_categoryTableView) {
//        
//        _categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 90,_bottomView.height) style:UITableViewStylePlain];
//        _categoryTableView.delegate = self;
//        _categoryTableView.dataSource = self;
//        _categoryTableView.scrollEnabled = YES;
//        _categoryTableView.tableFooterView = [UIView new];
//        
//        [_bottomView addSubview:_categoryTableView];
//        
//        
//    }
//    return _categoryTableView;
//}
//
//#pragma mark - 初始化悬浮列表
//- (UITableView *)suspendTableView{
//    if (!_suspendTableView) {
//        
//        _suspendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 90,_bottomView.height) style:UITableViewStylePlain];
//        _suspendTableView.delegate = self;
//        _suspendTableView.dataSource = self;
//        _suspendTableView.scrollEnabled = YES;
//        _suspendTableView.tableFooterView = [UIView new];
//        [_suspendTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//        
//        
//    }
//    return _suspendTableView;
//}
//#pragma mark - 初始化右侧视图
//- (UICollectionView *)rightCollectionView{
//    
//    if (!_rightCollectionView) {
//        UICollectionViewFlowLayout *flowayout = [[UICollectionViewFlowLayout alloc]init];
//        flowayout.minimumInteritemSpacing = 0.f;
//        flowayout.minimumLineSpacing = 0.5f;
//        _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(90, 0, kScreenWidth-90, _bottomView.frame.size.height) collectionViewLayout:flowayout];
//        [_rightCollectionView registerClass:[RightCollectionViewCell class] forCellWithReuseIdentifier:@"RightCollectionViewCell"];
//        [_rightCollectionView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellWithReuseIdentifier:@"CollectCell"];
//
//        [_rightCollectionView setBackgroundColor:rgb(240, 240, 240)];
//        _rightCollectionView.delegate = self;
//        _rightCollectionView.alwaysBounceVertical = YES;
//        _rightCollectionView.dataSource = self;
//        [_bottomView addSubview:_rightCollectionView];
//        
//    }
//    
//    return _rightCollectionView;
//}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView){
        return _class1_listArray.count + 1;
    }else{
        return _class2_listArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (tableView == self.categoryTableView){
        if (indexPath.row == 0) {
            cell.tableview_textLabel.text =@"全部商品";
            cell.tableview_textLabel.backgroundColor = [UIColor whiteColor];
        }else{
            Class_List * class_list =_class1_listArray[indexPath.row -1];
            cell.tableview_textLabel.text =class_list.gc_name;
        }
        
    }else{
        Class_List * class_list =_class2_listArray[indexPath.row];
        cell.tableview_textLabel.text = class_list.gc_name;
        cell.tableview_textLabel.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  self.tableRowH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.categoryTableView){
        LeftTableViewCell *topCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        topCell.tableview_textLabel.backgroundColor = rgb(220, 220, 220);
        
        LeftTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.tableview_textLabel.backgroundColor = [UIColor whiteColor];
        if (indexPath.row  > 3 && kScreenWidth == 320){
            [self.scrollview setContentOffset:CGPointMake(0, indexPath.row * self.tableRowH - self.tableRowH) animated:YES];
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.suspendTableTopDis.constant = indexPath.row * self.tableRowH;
        }];
        
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if(indexPath.row ==0){
            _gc_id = @"0";
            self.page = 1;
            [self loadAllShopList];
            [self hideSuspendTable];
        }else{
            Class_List * class_list =_class1_listArray[indexPath.row-1];
            [self loadShopListWithGc_id:class_list.gc_id];
        }
    }else{
        [self hideSuspendTable];
        
        Class_List * class_list =_class2_listArray[indexPath.row];
        [_class_listArray removeAllObjects];
        _gc_id = class_list.gc_id;
        self.page = 1;
        [_rightCollectionView setContentOffset:CGPointZero];
        [self loadAllShopList];
    }

    
}





#pragma mark------UICollectionViewDataSource UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _class_listArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
    
//    if (_isAllGoods) {
    
        if(_class_listArray.count > indexPath.item){
            id model = _class_listArray[indexPath.item];
            if ([model isKindOfClass:[Goods_List class]]) {
                Goods_List * goodlist = _class_listArray[indexPath.item];
                [cell.iconImgV setImageWithUrl:goodlist.goods_image_url placeholder:kDefaultImage_Z];
                cell.nameLbl.text =goodlist.goods_name;
                cell.priceLbl.text = [NSString stringWithFormat:@"¥：%@",goodlist.goods_price];
                if (showPrice){
                    cell.priceLbl.hidden = NO;
                }else{
                    cell.priceLbl.hidden = YES;
                }
                cell.inventoryLbl.text = [NSString stringWithFormat:@"商城库存：%@",goodlist.goods_storage];
                cell.areaLbl.text = goodlist.area_name;
            }else{
                //   kTipAlert(@"12432");
            }
        }
        
//    }else{
    
//        if(_class_listArray.count != 0){
//            Class_List * class_list =_class_listArray[indexPath.row];
//            [cell.collectionView_imageview setImageWithUrl:class_list.gc_image placeholder:kDefaultImage_Z];
//            cell.collectionView_Label.text =class_list.gc_name;
//        }
//    }
    return cell;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(kScreenWidth-90, 85);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
//    if (_isAllGoods ) {
        Goods_List * goodlist = _class_listArray[indexPath.row];
        ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
        vc.goods_id = goodlist.goods_id;
        vc.goods_image = goodlist.goods_image_url;
        [self.navigationController pushViewController:vc animated:YES];
        
//    }else{
//        
//        Class_List * class_list =_class_listArray[indexPath.row];
//        SubjectViewController * vc = [[SubjectViewController alloc]initWithNibName:@"SubjectViewController" bundle:nil];
//        vc.gc_id =class_list.gc_id;
//        vc.navigationItem.title = class_list.gc_name;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }
    
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
    [imageView setImageWithUrl:bannerModel.banner_image placeholder:kDefaultImage_c1];
    imageView.tag = 100;
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //    imageView.clipsToBounds = YES;
    return imageView;
    
}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(MCBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    
    NSMutableArray * imageArray = [NSMutableArray new];
    
    [_bannerArray enumerateObjectsUsingBlock:^(Banner_List  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageArray addObject:obj.banner_image];
    }];
    
    YWWebScrollView *scrollView=[[YWWebScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView. ScrollViewTag=index;
    scrollView.imageUrls =[NSMutableArray arrayWithArray:imageArray];
    scrollView.alpha=0.2;
    [UIView animateWithDuration:0.2f animations:^{
        scrollView.alpha = 1.0f;
    }];
    
}



#pragma mark - 加载左侧全部商品对应的右侧列表数据
/**
 加载左侧全部商品对应的右侧列表数据
 
 @param gc_id 商品分类  获取全部  传 0
 @param page  页数
 */
- (void)loadAllShopList{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"store_id"] = @"1";//店铺ID
    params[@"gc_id"] = _gc_id;//商品分类ID
    params[@"key"] = @"4";// 排序类型【1:销量】【2:人气（访问量）】【3:价格】【4:新品】
    params[@"order"] = @"2";//排序方式【1:升序】【2:降序】
    params[@"curpage"] = @(self.page);//页数
    
    
    //显示菊花
    [PDHud show];
    [MCNetTool postWithCachePageUrl:HttpShopList params:params success:^(NSDictionary *requestDic, NSString *msg, BOOL hasmore, NSInteger page_total) {
        //隐藏菊花
        [PDHud dismiss];
        
        _isAllGoods = YES;
        
        ShopListModel * shopListModel = [ShopListModel mj_objectWithKeyValues:requestDic];
        
        [self.class_listArray addObjectsFromArray:shopListModel.goods_list];
        
        
        [_rightCollectionView reloadData];
        
        if (shopListModel.goods_list.count < 10) {
            [_rightCollectionView hidenFooter];
        }
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.class_listArray empty:EmptyDataTableViewDefault withScrollView:_rightCollectionView];
        
        self.page==1?[_rightCollectionView headerEndRefresh]:[_rightCollectionView footerEndRefresh];
        self.page ++;
    } fail:^(NSString *error) {
        [PDHud dismiss];
        
        self.page==1?[_rightCollectionView headerEndRefresh]:[_rightCollectionView footerEndRefresh];
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:self.class_listArray empty:EmptyDataTableViewDefault withScrollView:_rightCollectionView];
        
    }];
    
}


@end
