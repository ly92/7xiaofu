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
#import "ShopDetaileViewController.h"



@interface ShopViewController ()<MCBannerViewDataSource, MCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *bannerVire;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) MCBannerView *banner;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic ,strong) NSArray *ategoryArray;

@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic ,strong) NSArray *myData;
@property (nonatomic ,assign) NSInteger selectedIndex;




@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _ategoryArray = [[NSArray alloc]initWithObjects:@"推荐分类", @"潮流女装",@"品牌男装",@"酒水饮料",@"家用电器",@"手机数码",@"电脑办公",@"图书",@"居家生活",@"运动户外",@"玩具乐器",@"钟表珠宝",@"食品生鲜",@"奢侈礼品",@"汽车用品",@"生活旅行",nil];
    _myData = [[NSArray alloc]initWithObjects:@"笔记本",@"休闲裤",@"牛仔裤",@"手机",@"净化器",@"火锅",@"OPPO",@"面膜",@"漱口水",@"测试",@"测试1", nil];

//    [self banner];
    _bottomView.height = kScreenHeight - 170 - 49;
    [self categoryTableView];
    [self rightCollectionView];
    // Do any additional setup after loading the view from its nib.
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
    return _ategoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.tableview_textLabel.text = _ategoryArray[indexPath.row];
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
    _selectedIndex = indexPath.row;
    
    [_rightCollectionView reloadData];
    
}


#pragma mark------UICollectionViewDataSource UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _myData.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionViewCell" forIndexPath:indexPath];
    //根据左边点击的indepath更新右边内容;
    switch (_selectedIndex)
    {
        case 0:
            cell.collectionView_imageview.image = [UIImage imageNamed:@"3.jpg"];
            break;
        case 1:
            cell.collectionView_imageview.image = [UIImage imageNamed:@"4.jpg"];
            break;
        case 2:
            cell.collectionView_imageview.image = [UIImage imageNamed:@"3.jpg"];
            break;
        case 3:
            cell.collectionView_imageview.image = [UIImage imageNamed:@"4.jpg"];
            break;
        default:
            break;
    }
    
    cell.collectionView_Label.text = _myData[indexPath.row];
    return cell;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth/3*2 - 30)/2, (kScreenWidth/3*2 - 30)/2);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
    
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
    //    BannerModel * bannerModel = _bannerArr[index];
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    //    [imageView setImageWithUrl:bannerModel.image placeholder:nil];
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
