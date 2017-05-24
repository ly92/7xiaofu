//
//  SendOrder1UpImageCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/22.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SendOrder1UpImageCell.h"
#import "PhotoCollectionViewCell.h"
#import "Helper.h"
#import "MessagePhotoView.h"

#define kItemWH ((kScreenWidth - 60) / 5)
#define kCellH  ((kScreenWidth - 60) / 5 + 20)


@interface SendOrder1UpImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{


    MessagePhotoView * _photosView;


}
@property (weak, nonatomic) IBOutlet UIView *upImageView;

@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, strong)NSMutableArray *photoUrlArray;



@end



@implementation SendOrder1UpImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    _photoUrlArray = [NSMutableArray new];
    
    //创建collectionView进行上传图片
    
//    [self addCollectionViewPicture];
    
    
    
  
}

- (void)setImageArray:(NSArray *)imageArray{

    _photoUrlArray = [NSMutableArray arrayWithArray:imageArray];

}

- (void)setType:(NSInteger)type{


    _type = type;
    
    if (_type == 1) {
        
        
        [self addImageView];
        
    }else{
    
    
        [self showImaegView];
    }
    
    
    
        
}


- (void)addImageView{

    WEAKSELF
    _photosView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kCellH) withImageArray:_imageArray];
     [_upImageView addSubview:_photosView];
    
    _photosView.photoViewDidSelectePhotoAtIndex =^(NSInteger index,UIImage * selectImage){
        
            
    };
    _photosView.photoViewDidAddPhoto =^(){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:[UIApplication sharedApplication].windows[0]];

    };
    
    _photosView.photoViewDidDeletePhotoAtIndex =^(NSInteger index){
        
        [self.photoArrayM removeObjectAtIndex:index];
    };

}


- (void)showImaegView{


    [self addCollectionViewPicture];


}



///图片上传
-(void)picureUpload:(UIButton *)sender{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:[UIApplication sharedApplication].windows[0]];
    
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
    
    flowL.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //行
//    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth),kCellH) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor clearColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.scrollEnabled = YES;

    //添加集合视图
    [_upImageView addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
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
    
    
    
    [cell.photoV setImageWithUrl:_photoUrlArray[indexPath.item] placeholder:kDefaultImage_Z];

    
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
    imageData = UIImageJPEGRepresentation(image, 0.5);
    [self.photoArrayM addObject:image];
    
    
    _photosView.imageArray = _photoArray;
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    
    
    [self showLoading];
    
    [MCNetTool uploadDataWithURLStr:HttpMeUploadImage withDic:params imageKey:@"img" withData:imageData uploadProgress:^(float progress) {
        [self showProgress:progress];
    } success:^(NSDictionary *requestDic, NSString *msg) {
        
        
        [self dismissLoading];
        
        [_photoUrlArray addObject:requestDic[@"img"]];
      
        if (_sendOrder1UpImageCellBlock) {
            _sendOrder1UpImageCellBlock(_photoUrlArray);
        }
        
    } failure:^(NSString *error) {
        [self showErrorText:error];
    }];

    
    [[self viewController] dismissViewControllerAnimated:YES completion:^{

    }];
    
}





//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArray) {
        _photoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
