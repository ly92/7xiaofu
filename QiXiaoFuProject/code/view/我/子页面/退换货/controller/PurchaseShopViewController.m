//
//  PurchaseShopViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/24.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "PurchaseShopViewController.h"
#import "MCTextView.h"
#import "PhotoCollectionViewCell.h"
#import "NSArray+Utils.h"
#import "UIViewController+XHPhoto.h"
#import "ChatViewController.h"
#import "ChooseSNNumViewController.h"


#define kItemWH ((kScreenWidth - 60) / 5)
#define kCellH  ((kScreenWidth - 60) / 5 + 20)


@interface PurchaseShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{


    
    NSInteger _type;//  1  退货  2 换货
    NSString * _snString;// 备件SN码【多个用逗号拼接】

}



@property (weak, nonatomic) IBOutlet MCTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UILabel *snLab;

@property (weak, nonatomic) IBOutlet UIButton *snBtn;

@property (weak, nonatomic) IBOutlet UITextField *orderNumTF;//物流编号


@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArray;
//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;

@property (nonatomic, strong)NSMutableArray *photoUrlArray;

@property (nonatomic, strong)NSMutableDictionary * selectDictionary;


@end

@implementation PurchaseShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"退换货";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"联系客服" target:self action:@selector(kefuItemAction:)];

    _textView.placeholder = @"请输入退换货原因";
    _photoUrlArray = [NSMutableArray new];
    _selectDictionary = [NSMutableDictionary new];
    
    _type = 1;
    
    _segment.tintColor = kThemeColor;

    //创建collectionView进行上传图片
    
    [self addCollectionViewPicture];
    
    
    //上传图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn.frame = CGRectMake(10 , 10, kItemWH, kItemWH);
    [_photoBtn setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
    //[_photoBtn setBackgroundColor:[UIColor redColor]];
    
    [_photoBtn addTarget:self action:@selector(picureUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_photoBtn];
    _photoBtn.centerY =kCellH/2;

    
    WEAKSELF
    [self.view setTapActionWithBlock:^{
        [weakSelf.view endEditing:YES];
    }];
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)segmentChangeValueAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex + 1;
    DeLog(@"  index  -----  %ld",index);
    _type = index;
}

- (IBAction)snBtnAction:(id)sender {
    
    ChooseSNNumViewController * vc = [[ChooseSNNumViewController alloc]initWithNibName:@"ChooseSNNumViewController" bundle:nil];
    vc.selectDict = _selectDictionary;
    vc.order_id = _order_id;
    vc.chooseSNNumBlock = ^(NSMutableDictionary * selectDict){
        
        _selectDictionary = selectDict;
        //            _sn_num = sn;
        _snLab.text = [NSString stringWithFormat:@"共选择%ld个",selectDict.allValues.count];
        _snString = [selectDict.allValues string];
        
    };
     [self.navigationController pushViewController:vc animated:YES];
 }

- (IBAction)submitBtnAction:(id)sender {
    
    
    NSString * content = _textView.text;
    
    if (self.orderNumTF.text.length == 0){
        [self showErrorText:@"请输入物流编号"];
        return;
    }
    
    if(content.length == 0){
    
        [self showErrorText:@"请输入退换货的原因"];
        return;
    }
    
    if(_snString.length == 0){
        [self showErrorText:@"请选择备件sn码"];
        return;
    }
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"order_id"] = _order_id;
    params[@"message"] = content;
    params[@"goods_image"] = [_photoUrlArray string];
    params[@"type"] = @(_type);
    params[@"goods_sn"] = _snString;
    params[@"wuliu_sn"] = self.orderNumTF.text;
    
    [MCNetTool postWithUrl:HttpShopAdd_refund_all params:params success:^(NSDictionary *requestDic, NSString *msg) {
        [self showSuccessText:msg];
        _textView.text = @"";
        [_photoUrlArray removeAllObjects];
        [_photoArray removeAllObjects];
        [self buttonFrame];
        
        
        if(_purchaseShopViewBlock){
            _purchaseShopViewBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];

    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];
    
}

///图片上传
-(void)picureUpload:(UIButton *)sender{
 
    
    [self showCanEdit:YES photo:^(UIImage *photo,NSData * imageData) {
        
        [self.photoArrayM addObject:photo];

        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = kUserId;
        
        [self showLoading];

        
        [MCNetTool uploadDataWithURLStr:HttpMeUploadImage withDic:params imageKey:@"img" withData:imageData uploadProgress:^(float progress) {
            [self showProgress:progress];
        } success:^(NSDictionary *requestDic, NSString *msg) {
            
            [self dismissLoading];
            
            [_photoUrlArray addObject:requestDic[@"img"]];
            
            [self buttonFrame];

            
        } failure:^(NSString *error) {
            [self showErrorText:error];
        }];


    }];
    

}

#pragma mark 上传图片UIcollectionView

-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(kItemWH, kItemWH );
    flowL.sectionInset = UIEdgeInsetsMake((kCellH - kItemWH)/2, 10, 10, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    //    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth),kCellH) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor clearColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [_bottomView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

//button的frame
- (void)buttonFrame{
    //-(void)viewWillAppear:(BOOL)animated{
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
        //        _editImageView.frame = CGRectMake(20, 84, kScreenWidth - 40, 180);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (_bottomView.frame.size.width - 60) / 5 * self.photoArrayM.count, 0, kItemWH,kItemWH);
        _photoBtn.centerY =kCellH/2;
        
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
    }
}



#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArray.count == 0) {
        return 0;
    }
    else{
        return _photoArray.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.photoV.image = self.photoArrayM[indexPath.item];
    UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(kItemWH - 20, 0, 20, 20);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"car_certification_icon_shanchu"] forState:UIControlStateNormal];
    delBtn.tag = indexPath.item;
    [delBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        
        [self.photoArrayM removeObjectAtIndex:btn.tag];
        [_photoUrlArray removeObjectAtIndex:btn.tag];
        [self buttonFrame];
        
    }];
    [cell.photoV addSubview:delBtn];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}






//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArray) {
        _photoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArray;
}



- (void)kefuItemAction:(UIBarButtonItem *)item{
    
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:@"kefu1" friendUsername:@"客服"
                                                                                   friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage]
                                                                                             user:kPhone
                                                                                         userName:kUserName
                                                                                         userIcon:kUserIcon];
    chatController.title = @"客服";
    chatController.friendIcon = [NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage];
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];
    
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
