//
//  ShopDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/3.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopDetaileViewController.h"
#import "MCBannerView.h"
#import "ShopDetaileWordCell.h"
#import "ShopDetaileAdressCell.h"
#import "ShopPositionViewController.h"
#import "SubjectNumberView.h"
#import "ShopPayViewController.h"
#import "ShopDetaileTagCell.h"
#import "GoodsDetaileModel.h"
#import "WebCell.h"
#import "WebCell2.h"
#import "YWWebScrollView.h"
#import "ShopCarModel.h"
#import "ChatViewController.h"


@interface ShopDetaileViewController ()<MCBannerViewDataSource, MCBannerViewDelegate,UITableViewDelegate,UITableViewDataSource >{


    UIImage * _shareImage;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MCBannerView *banner;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (weak, nonatomic) IBOutlet UIButton *addShopCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtnAction;
@property (strong, nonatomic)SubjectNumberView * subjectNumberView;
@property (assign, nonatomic)NSInteger count; // 选择的商品数量
@property (assign, nonatomic)CGFloat price;
@property (strong, nonatomic)UIButton * colloctBtn;
@property (nonatomic, strong) GoodsDetaileModel * goodsDetaileModel;
@property(nonatomic,strong)NSMutableDictionary *heightDic;//计算webview的高度
@property (weak, nonatomic) IBOutlet UIButton *chatBuyBtn;//联系客服购买

@property (nonatomic, assign) BOOL showShopTable;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *btnLine;

@end

@implementation ShopDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (showPrice){
        self.chatBuyBtn.hidden = YES;
    }else{
        self.chatBuyBtn.hidden = NO;
    }
    
    _count = 1;
    self.heightDic = [[NSMutableDictionary alloc] init];
    _bannerArray = [NSMutableArray new];
    
    
    [self setUpNavView];
    
    

    
    [self banner];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    [_tableView registerNib:[UINib nibWithNibName:@"ShopDetaileWordCell" bundle:nil] forCellReuseIdentifier:@"ShopDetaileWordCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ShopDetaileAdressCell" bundle:nil] forCellReuseIdentifier:@"ShopDetaileAdressCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ShopDetaileTagCell" bundle:nil] forCellReuseIdentifier:@"ShopDetaileTagCell"];
    [self.tableView registerClass:[WebCell class] forCellReuseIdentifier:@"webCell"];
    [self.tableView registerClass:[WebCell2 class] forCellReuseIdentifier:@"webCell2"];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadDetail];
}

- (void)loadDetail{
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"goods_id"] = _goods_id;
    params[@"userid"] = kUserId;
    
    [MCNetTool postWithCacheUrl:HttpShopDetaile params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _goodsDetaileModel = [GoodsDetaileModel mj_objectWithKeyValues:requestDic];
        
        
        [UIImage loadImageWithUrl:_goodsDetaileModel.share_img_url returnImage:^(UIImage *image) {
            _shareImage = image;
        }];
        if(_goodsDetaileModel.is_fav == 1){
            _colloctBtn.selected = YES;
        }else{
            _colloctBtn.selected = NO;
        }
        [_bannerArray setArray:_goodsDetaileModel.goods_image];
        [_banner reloadData];
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        
        
        
    }];

}

#pragma mark - 收藏
- (void)collectItemAction:(UIButton *)btn{
    
    
    [Utool verifyLogin:self LogonBlock:^{
        
        if (!btn.selected) {
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"goods_id"] = _goods_id;
            
            
            [MCNetTool postWithUrl:HttpShopAddCollect params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:msg];
                
                _colloctBtn.selected = YES;
                
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
            
        }else{
            
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"userid"] = kUserId;
            params[@"store_id"] = @"1";
            params[@"fav_id"] = _goods_id;
            
            [MCNetTool postWithUrl:HttpShopDelCollect params:params success:^(NSDictionary *requestDic, NSString *msg) {
                [self showSuccessText:@"取消收藏成功"];
                _colloctBtn.selected = NO;
            } fail:^(NSString *error) {
                [self showErrorText:error];
            }];
        }
        
        
    }];
    
}
#pragma mark - 分享
- (void)shareItemAction:(UIBarButtonItem *)item{
    
    [self shareWithUMengWithVC:self withImage:nil withID:nil
                     withTitle:@"七小服"
                      withDesc:@"7x24小时技能服务平台" withShareUrl:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpShare] withType:1];

}



#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1){
      return 4;
    }
      return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // 商品图片
            ShopDetaileTagCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShopDetaileTagCell"];
            [cell.contentsView addSubview:self.banner];
            if (self.showShopTable){
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            return cell;
        }
        if (indexPath.row == 1) {
            // 商品标题
            ShopDetaileWordCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShopDetaileWordCell"];
            cell.titleLab.text = _goodsDetaileModel.goods_info.goods_name;
            if (self.showShopTable){
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            return cell;
        }else if (indexPath.row == 2) {
            // 商品介绍
            WebCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell2"];
            cell.tag = indexPath.row;
            NSString *str = _goodsDetaileModel.goods_info.mobile_body;
            NSString *str2 = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
            cell.contentStr = str3;
            cell.webCell2ReturnHeightBlock = ^(WebCell2 * webCell,CGFloat height){
                if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]] floatValue] != webCell.height)
                {
                    [self.heightDic setObject:[NSNumber numberWithFloat:webCell.height] forKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:webCell.tag inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            if (self.showShopTable){
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            return cell;
        }else if (indexPath.row == 3) {
            // 商品价格
             ShopDetaileWordCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShopDetaileWordCell"];
             cell.titleLab.text = [NSString stringWithFormat:@"¥ %@",_goodsDetaileModel.goods_info.goods_price];
            cell.titleLab.textColor = kThemeColor;
            if (self.showShopTable){
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
             return cell;
         }
    }else if (indexPath.section == 2) {
            //商品位置 商品库存  工程师库存
            ShopDetaileAdressCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShopDetaileAdressCell"];
            cell.shopNumLab.text = _goodsDetaileModel.goods_info.goods_storage;
            cell.engineerNumLab.text = _goodsDetaileModel.goods_info.engineer_storage;
        //如果库存为0则联系客服
        if ([_goodsDetaileModel.goods_info.goods_storage intValue] == 0){
            self.chatBuyBtn.hidden = NO;
        }else{
            if (showPrice){
                self.chatBuyBtn.hidden = YES;
            }else{
                self.chatBuyBtn.hidden = NO;
            }
        }
        if (self.showShopTable){
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
            return cell;
    }
    
    if (indexPath.section == 0){
        WebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell"];
        cell.tag = indexPath.row;
        NSString *str = _goodsDetaileModel.goods_info.goods_table;
        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        cell.contentStr = str3;
        cell.webCellReturnHeightBlock = ^(WebCell * webCell,CGFloat height){
            if (![self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]]||[[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]] floatValue] != webCell.height)
            {
                [self.heightDic setObject:[NSNumber numberWithFloat:webCell.height] forKey:[NSString stringWithFormat:@"%ld%ld",webCell.tag,indexPath.section]];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:webCell.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
        if (self.showShopTable){
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showShopTable){
        if (indexPath.section == 0){
            CGFloat height = [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",indexPath.row,indexPath.section]] floatValue];
            return height==0?30:height;
        }
    }else{
        if(indexPath.section == 1){
            if (indexPath.row == 0) {
                // 商品图片
                return kScreenWidth;
            }else if (indexPath.row == 1){
                return 40;
            }else if (indexPath.row == 2) {
                CGFloat height = [[self.heightDic objectForKey:[NSString stringWithFormat:@"%ld%ld",indexPath.row,indexPath.section]] floatValue];
                return height==0?30:height;
            }else if (indexPath.row == 3) {
                if (showPrice){
                    return 35;
                }else{
                    return 0;
                }
            }
        }else if(indexPath.section == 2){
            return  60;
        }
    }
    return  0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        ShopPositionViewController * vc = [[ShopPositionViewController alloc]initWithNibName:@"ShopPositionViewController" bundle:nil];
        vc.goods_id = _goods_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 && !self.showShopTable){
        return 8;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}


#pragma mark - 初始化广告视图
- (MCBannerView *)banner{
    if (!_banner) {
        _banner = [[MCBannerView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenWidth)];
        _banner.dataSource = self;
        _banner.delegate = self;
        _banner.shouldLoop = YES;
        _banner.showFooter = NO;
        _banner.autoScroll = YES;
        _banner.backgroundColor = [UIColor whiteColor];
    }
    return _banner;
}

#pragma mark - ZYBannerViewDataSource
// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(MCBannerView *)banner
{
    if (_bannerArray.count < 2){
        banner.pageControl.hidden = YES;
    }
    return _bannerArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(MCBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
    NSString * imageUrl = _bannerArray[index];
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithUrl:imageUrl placeholder:kDefaultImage_c1];
    imageView.tag = 100;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.clipsToBounds = YES;
    return imageView;

}

#pragma mark - ZYBannerViewDelegate

// 在这里实现点击事件的处理
- (void)banner:(MCBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    DeLog(@"点击了第%ld个项目", (long)index);
    
    
    YWWebScrollView *scrollView=[[YWWebScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scrollView. ScrollViewTag=index;
    scrollView.imageUrls = _bannerArray;
    scrollView.alpha=0.2;
    [UIView animateWithDuration:0.2f animations:^{
        scrollView.alpha = 1.0f;
    }];

 
}

#pragma mark - 立即购买
- (IBAction)buyBtnAction:(id)sender {
  
    if( [_goodsDetaileModel.goods_info.goods_storage integerValue] == 0){
        [self showErrorText:@"商品库存不足"];
        return;
    }
    [self chooseBuyGoodsNumberWithType:NO];
    
}


#pragma mark - 加入购物车
- (IBAction)addShopCarBtn:(id)sender {

    if( [_goodsDetaileModel.goods_info.goods_storage integerValue] == 0){
        [self showErrorText:@"商品库存不足"];
        return;
    }

    [self chooseBuyGoodsNumberWithType:YES];
   
}


- (void)chooseBuyGoodsNumberWithType:(BOOL )addShopCar{
    _subjectNumberView = [SubjectNumberView footerView];
    _subjectNumberView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:_subjectNumberView];
    _subjectNumberView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _subjectNumberView.alpha = 1;
    }];
        _subjectNumberView.subjectNumberViewBlock =^(NSInteger count){
        _count = count;
    };
    [_subjectNumberView.submitBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        [_subjectNumberView  hidenView];
        if (addShopCar) {
            [self addShopCarRequestWithGoodsCount:_count];
        }else{
            Cart_List* cart_List = [[Cart_List alloc]init];
            cart_List.goods_id =_goodsDetaileModel.goods_info.goods_id;
            cart_List.goods_image =_goodsDetaileModel.goods_info.goods_img_laber;
            cart_List.goods_image_url =_goods_image;
            cart_List.goods_price =_goodsDetaileModel.goods_info.goods_price ;
            cart_List.cart_id =[NSString stringWithFormat:@"%@|%@",_goodsDetaileModel.goods_info.goods_id,@(_count)];
            cart_List.goods_name =_goodsDetaileModel.goods_info.goods_name;
            cart_List.goods_sum =[NSString stringWithFormat:@"%@",@([_goodsDetaileModel.goods_info.goods_price floatValue] * _count)];
            cart_List.goods_num =_count;

            NSArray * cartArray= @[cart_List];
            
            ShopPayViewController * vc  = [[ShopPayViewController alloc]initWithNibName:@"ShopPayViewController" bundle:nil];
            vc.cart_id =[NSString stringWithFormat:@"%@|%@",_goodsDetaileModel.goods_info.goods_id,@(_count)];
            vc.ifcart = 0;
            vc.cartGoodsArray = cartArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)addShopCarRequestWithGoodsCount:(NSInteger )count{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"goods_id"] = _goodsDetaileModel.goods_info.goods_id;
    params[@"quantity"] = @(count);

    [MCNetTool postWithUrl:HttpShopAddCar params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self showSuccessText:msg];
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];

}

#pragma mark - 隐藏弹出视图--- 选择购买数量
- (void)hidenSubjectNumberView{
    [UIView animateWithDuration:0.3 animations:^{
        _subjectNumberView.alpha = 0;
    } completion:^(BOOL finished) {
        [_subjectNumberView removeFromSuperview];
    }];
}

- (void)setUpNavView{
    UIBarButtonItem * shareItem = [UIBarButtonItem itemWithImage:@"icon_share" highImage:@"icon_share" target:self action:@selector(shareItemAction:)];
    
    UIButton *colloctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [colloctBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [colloctBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect_red"] forState:UIControlStateHighlighted];
    [colloctBtn setBackgroundImage:[UIImage imageNamed:@"icon_collect_red"] forState:UIControlStateSelected];
    colloctBtn.size = colloctBtn.currentBackgroundImage.size;
    [colloctBtn addTarget:self action:@selector(collectItemAction:) forControlEvents:UIControlEventTouchUpInside];
    _colloctBtn = colloctBtn;
    UIBarButtonItem * filtItem = [[UIBarButtonItem alloc]initWithCustomView:colloctBtn];
    UIBarButtonItem * item =    [UIBarButtonItem itemWithImage:@"" highImage:@"" target:self action:nil];
    self.navigationItem.rightBarButtonItems= @[shareItem,item,filtItem];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [btn1 setTitle:@"商品" forState:UIControlStateNormal];
    [btn1 setTitleColor:kThemeColor forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor clearColor]];
    [btn1 addTarget:self action:@selector(goods_desc) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
    [btn2 setTitle:@"详情" forState:UIControlStateNormal];
    [btn2 setTitleColor:rgb(33, 33, 33) forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor clearColor]];
    [btn2 addTarget:self action:@selector(goods_memo) forControlEvents:UIControlEventTouchUpInside];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 50, 1.5)];
    line.backgroundColor = kThemeColor;
    
    self.leftBtn = btn1;
    self.rightBtn = btn2;
    self.btnLine = line;
    
    [view addSubview:btn1];
    [view addSubview:btn2];
    [view addSubview:line];
    
    self.navigationItem.titleView = view;
}


- (void)goods_desc{
    if (!self.showShopTable) return;
    self.showShopTable = NO;
    
    self.tableView.backgroundColor = rgb(240, 240, 240);
    
    [self.leftBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:rgb(33, 33, 33) forState:UIControlStateNormal];
    self.btnLine.x = 0;
    
    [self.tableView reloadData];
}

- (void)goods_memo{
    if (self.showShopTable) return;
    self.showShopTable = YES;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentOffset = CGPointZero;

    [self.leftBtn setTitleColor:rgb(33, 33, 33) forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    self.btnLine.x = 50;
     [self.tableView reloadData];
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
- (IBAction)connectService {
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:@"kefu1" friendUsername:@"客服"
friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage]];
    
    chatController.title = @"客服";
    chatController.friendIcon = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage];
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
