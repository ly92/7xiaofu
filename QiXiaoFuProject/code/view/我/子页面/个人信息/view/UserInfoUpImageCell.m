//
//  UserInfoUpImageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "UserInfoUpImageCell.h"
#import "PhotoCollectionViewCell.h"
#import "Helper.h"
#import "QXUILongPressGestureRecognizer.h"
#import "SYPhotoBrowser.h"

#define kItemWH ((kScreenWidth - 60) / 5)
#define kCellH  ((kScreenWidth - 60) / 5 + 20)



@interface UserInfoUpImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIView *editImageView;


@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;
//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;

@property (nonatomic, strong)NSMutableArray *images;
@property (nonatomic, strong)NSMutableArray *titles;




@end


@implementation UserInfoUpImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    
    //创建collectionView进行上传图片
    
    [self addCollectionViewPicture];
    
    
    //上传图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn.frame = CGRectMake(10 , 10, kItemWH, kItemWH);
    [_photoBtn setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
    //[_photoBtn setBackgroundColor:[UIColor redColor]];
    
    [_photoBtn addTarget:self action:@selector(picureUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.editImageView addSubview:_photoBtn];
    _photoBtn.centerY =kCellH/2;
    
}
///图片上传
-(void)picureUpload:(UIButton *)sender{
    
    
    NSInteger index = _userInfoModel1.cer_images.count + 1;
    
    if (_userInfoUpImageCell) {
        _userInfoUpImageCell(index,@"",@"",@"");
    }
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
//    [sheet showInView:[UIApplication sharedApplication].windows[0]];

}

- (void)setUserInfoModel1:(UserInfoModel1 *)userInfoModel1{

    _userInfoModel1 = userInfoModel1;

    [_photoArrayM setArray:_userInfoModel1.cer_images];
    
    _images = [NSMutableArray new];
    _titles = [NSMutableArray new];

    
    [_photoArrayM enumerateObjectsUsingBlock:^(Cer_Images234 * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [_images addObject:obj.cer_image];
        [_titles addObject:obj.cer_image_name];

        
    }];
    
    

    [_collectionV reloadData];
    [self buttonFrame];

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
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [_editImageView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

//button的frame
- (void)buttonFrame{
//-(void)viewWillAppear:(BOOL)animated{
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
//        _editImageView.frame = CGRectMake(20, 84, kScreenWidth - 40, 180);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.editImageView.frame.size.width - 60) / 5 * self.photoArrayM.count, 0, kItemWH,kItemWH);
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
    
    Cer_Images234 * ce = _photoArrayM[indexPath.item];
    
    [cell.photoV setImageWithUrl:ce.cer_image placeholder:kDefaultImage_Z];
    
   
    
    //证书状态 【10 通过】【20 未通过】【30 待审核】
    
    if(ce.cer_image_type != 10){
    
        UIImageView * shenheImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, cell.photoV.width - 20, cell.photoV.frame.size.height - 20)];
        [cell.photoV addSubview:shenheImageView];
    
        if (ce.cer_image_type == 20) {
            shenheImageView.image = [UIImage imageNamed:@"zhengshu_pass"];
        }
        if (ce.cer_image_type == 30) {
            shenheImageView.image = [UIImage imageNamed:@"zhengshu_nopass"];

        }
    }
    
    
    QXUILongPressGestureRecognizer * longTap = [[QXUILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
    longTap.tag= indexPath.item;
    [cell addGestureRecognizer:longTap];
    
//    UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    delBtn.frame = CGRectMake(kItemWH - 20, 0, 20, 20);
//     [delBtn setBackgroundImage:[UIImage imageNamed:@"car_certification_icon_shanchu"] forState:UIControlStateNormal];
//    delBtn.tag = indexPath.item;
//    [delBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
//        
//        [self.photoArrayM removeObjectAtIndex:btn.tag];
//        [_photoUrlArray removeObjectAtIndex:btn.tag];
//        [self buttonFrame];
//        
//    }];
//    [cell.photoV addSubview:delBtn];
//
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger index = indexPath.row;

    SYPhotoBrowser *browser = [[SYPhotoBrowser alloc]init];
    browser.originalImages = _images;
    browser.currentIndex = index;
    browser.currentRect = CGRectMake(kScreenWidth/2, kScreenHeight/2, 0, 0);
    browser.titles = _titles;
    [browser show];

}

- (void)longTapAction:(QXUILongPressGestureRecognizer *)longTap{

    if (longTap.state == UIGestureRecognizerStateBegan) {
        NSInteger index = longTap.tag + 1;
        
        Cer_Images234 * ce = _photoArrayM[index -1];
         if (_userInfoUpImageCell) {
            _userInfoUpImageCell(index,ce.cer_image,ce.cer_image_name,ce.cer_id);
        }
    }
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

    NSData * data = [[NSData alloc]init ];
    data = UIImageJPEGRepresentation(image, 1);
    
    [self.photoArrayM addObject:image];

    
//    
//    [MCNetTool uploadDataWithURLStr:kSaveIcon withDic:kSaveIconParam(kUserId) imageKey:@"icon" withData:data uploadProgress:^(NSString *progress) {
//        
//    } success:^(NSDictionary *requestDic, NSString *msg) {
//        
//        
//        [self loadUserData];
//        
//        
//        
//    } failure:^(NSString *error) {
//        
//    }];
    
    
    
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
