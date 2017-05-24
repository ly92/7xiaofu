//
//  OrderDetaileKeHuContentCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "OrderDetaileKeHuContentCell.h"
#import "PhotoCollectionViewCell.h"
#import "Helper.h"

#define kItemWH ((kScreenWidth - 60 - 20 - 20) / 5)
#define kCellH  ((kScreenWidth - 60 - 20) / 5 + 20)


@interface OrderDetaileKeHuContentCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{

    NSInteger _isUpImage;

}


@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;

@property (nonatomic, strong)NSMutableArray *photoUrlArray;

//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;


@end


@implementation OrderDetaileKeHuContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _isUpImage = 1;
    
    _photoUrlArray = [NSMutableArray new];
    
    [_priceTextField addTarget:self action:@selector(priceTextFieldChangeAction:) forControlEvents:UIControlEventEditingChanged];
    
    _ImagebgView.backgroundColor = [UIColor whiteColor];
    
    //创建collectionView进行上传图片
    
    [self addCollectionViewPicture];
    
    
    //上传图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn.frame = CGRectMake(5 , 5, kItemWH, kItemWH);
    [_photoBtn setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
    //[_photoBtn setBackgroundColor:[UIColor redColor]];
    
    [_photoBtn addTarget:self action:@selector(picureUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.ImagebgView addSubview:_photoBtn];
    _photoBtn.centerY =kCellH/2;

    
    // Initialization code
}


- (void)priceTextFieldChangeAction:(UITextField *)textfield{

    CGFloat  text = [textfield.text floatValue];
    
    if (text >= _service_price) {
        
        _isUpImage = 2;
        
    }else{
    
        _isUpImage = 0;

    }
    
    if (_orderDetaileKeHuContentCellBlock) {

        _orderDetaileKeHuContentCellBlock(textfield.text);
    }
}

///图片上传
-(void)picureUpload:(UIButton *)sender{
    
    
    if (_isUpImage == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:[UIApplication sharedApplication].windows[0]];
    }else  if (_isUpImage == 1){
    
        kTipAlert(@"请先输入需要调整的价格");
    
    }else  if (_isUpImage == 2){
        
        kTipAlert(@"调整价格大于等于原来价格时，不需要上传图片");
        
    }
    
    
}


#pragma mark 上传图片UIcollectionView

-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake(kItemWH, kItemWH );
//    flowL.sectionInset = UIEdgeInsetsMake((kCellH - kItemWH)/2, 0, 5, 0);
    flowL.sectionInset = UIEdgeInsetsMake((kCellH - kItemWH)/2, 0, 0, 0);

    //列
    flowL.minimumInteritemSpacing = 5;
    //行
    //    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth - 20),kCellH) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [_ImagebgView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

//button的frame
- (void)buttonFrame{
    //-(void)viewWillAppear:(BOOL)animated{
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
        //        _editImageView.frame = CGRectMake(20, 84, kScreenWidth - 40, 180);
        self.photoBtn.frame = CGRectMake(5 * (self.photoArrayM.count + 1) + (self.ImagebgView.frame.size.width - 60) / 5 * self.photoArrayM.count, 0, kItemWH,kItemWH);
        _photoBtn.centerY =kCellH/2;
        
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
    }
}



#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self openCamera];
    }
    else if(buttonIndex==1){
        [self openAlbum];
    }
}

#pragma mark ---
#pragma mark ---  打开相机

- (void)openCamera{
    if ([Helper checkCameraAuthorizationStatus]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self viewController] presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark ---
#pragma mark ---  打开相册

- (void)openAlbum{
    if ([Helper checkPhotoLibraryAuthorizationStatus]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [[self viewController] presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark - picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];// UIImage 裁剪后图片 *
    // UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData * imageData = [[NSData alloc]init ];
    imageData = UIImageJPEGRepresentation(image, 1);
    
    [self.photoArrayM addObject:image];
    
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    [self showLoading];

    [MCNetTool uploadDataWithURLStr:HttpMeUploadImage withDic:params imageKey:@"img" withData:imageData uploadProgress:^(float progress) {
        [self showProgress:progress];
    } success:^(NSDictionary *requestDic, NSString *msg) {
        
        [self dismissLoading];
      
        [_photoUrlArray addObject:requestDic[@"img"]];
        
        if (_orderDetaileKeHuContentImageArrayCellBlock) {
            _orderDetaileKeHuContentImageArrayCellBlock(_photoUrlArray);
        }
        
    } failure:^(NSString *error) {
        [self showErrorText:error];
    }];
    
    
    
    [[self viewController] dismissViewControllerAnimated:YES completion:^{
        [self buttonFrame];
    }];
    
}




//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArrayM) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
