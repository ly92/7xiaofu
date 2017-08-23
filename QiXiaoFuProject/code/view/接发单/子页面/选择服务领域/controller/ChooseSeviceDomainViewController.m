//
//  ChooseSeviceDomainViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseSeviceDomainViewController.h"
//#import "PDCollectionViewFlowLayout.h"
//#import "User.h"
#import "ChooseSeviceDomainCell.h"

@interface ChooseSeviceDomainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *secTwoArray;

@property (nonatomic, strong) NSMutableArray *resultArray;//

@property (nonatomic, strong) NSMutableArray *selectedIds;//选中的

@property (nonatomic, copy) NSString *selectId;//当前选中的section1中元素的ID

@end

@implementation ChooseSeviceDomainViewController

- (NSMutableArray *)secTwoArray{
    if(!_secTwoArray){
        _secTwoArray = [NSMutableArray array];
    }
    return _secTwoArray;
}

- (NSMutableArray *)resultArray{
    if(!_resultArray){
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (NSMutableArray *)selectedIds{
    if(!_selectedIds){
        _selectedIds = [NSMutableArray array];
    }
    return _selectedIds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择服务领域";
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(rightTrueAction:)];

    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake((kScreenWidth - 60)/3.0, 35);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseSeviceDomainCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ChooseSeviceDomainCell class])];
}

#pragma mark - 确认选中的领域
- (void)rightTrueAction:(UIBarButtonItem *)item{
    
    if (self.domainsChooseSeviceDomainViewBlock != nil){
        self.domainsChooseSeviceDomainViewBlock(self.resultArray);
    }
     
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
#pragma mark - MUCollectionViewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isFromPersonalInfo){
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0){
        return [_domains count];
    }else{
        return self.secTwoArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseSeviceDomainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseSeviceDomainCell" forIndexPath:indexPath];
    if (indexPath.section == 0){
        Service_Sector12 *contact = _domains[ indexPath.row];
        cell.titleLbl.text = contact.gc_name;
        if ([self.selectedIds containsObject:contact.gc_id]){
            cell.iconImgV.image = [UIImage imageNamed:@"img_bg_content_s"];
            cell.titleLbl.textColor = kThemeColor;
        }else{
            cell.iconImgV.image = [UIImage imageNamed:@"img_bg_content_n"];
            cell.titleLbl.textColor = [UIColor darkGrayColor];
        }
    }else{
        Service_Sector22 *contact = self.secTwoArray[ indexPath.row];
        cell.titleLbl.text = contact.gc_name;
        if ([self.selectedIds containsObject:contact.gc_id]){
            cell.iconImgV.image = [UIImage imageNamed:@"img_bg_content_s"];
            cell.titleLbl.textColor = kThemeColor;
        }else{
            cell.iconImgV.image = [UIImage imageNamed:@"img_bg_content_n"];
            cell.titleLbl.textColor = [UIColor darkGrayColor];
        }
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        Service_Sector12 *contact = _domains[ indexPath.row];
        [self.secTwoArray removeAllObjects];
        if ([self.selectedIds containsObject:contact.gc_id]){
            [self.selectedIds removeObject:contact.gc_id];
            self.selectId = @"";
            //删除子类
            for (Service_Sector22 *contact2 in contact.list) {
                if ([self.selectedIds containsObject:contact2.gc_id]){
                    [self.selectedIds removeObject:contact2.gc_id];
                }
            }
            //删除
            NSArray *array = [NSArray arrayWithArray:self.resultArray];
            for (NSDictionary *dict in array) {
                //有则删除
                if ([dict.allKeys containsObject:@"model"]){
                    Service_Sector12 *contact11 = [dict objectForKey:@"model"];
                    if (contact11.gc_id == contact.gc_id){
                        [self.resultArray removeObject:dict];
                    }
                }
            }
        }else{
            [self.selectedIds addObject:contact.gc_id];
            [self.secTwoArray addObjectsFromArray:contact.list];
            self.selectId = contact.gc_id;
            //记录选中
            NSArray *array = [NSArray arrayWithArray:self.resultArray];
            for (NSDictionary *dict in array) {
                //有则删除
                if ([dict.allKeys containsObject:@"model"]){
                    Service_Sector12 *contact11 = [dict objectForKey:@"model"];
                    if (contact11.gc_id == contact.gc_id){
                        [self.resultArray removeObject:dict];
                    }
                }
            }
            //添加
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"model"] = contact;
            [self.resultArray addObject:dictM];
        }
    }else{
        Service_Sector22 *contact = self.secTwoArray[ indexPath.row];
        //记录选中
        BOOL haveKey = false;
        NSInteger index = 0;
        for (int i = 0; i < self.resultArray.count; i ++) {
            NSMutableDictionary *dict = self.resultArray[i];
            if ([dict.allKeys containsObject:@"model"]){
                Service_Sector12 *contact11 = [dict objectForKey:@"model"];
                if (contact11.gc_id == self.selectId){
                    haveKey = true;
                    index = i;
                }
            }
        }
        
        if ([self.selectedIds containsObject:contact.gc_id]){
            [self.selectedIds removeObject:contact.gc_id];
            if (haveKey){
                NSMutableDictionary *dictM = self.resultArray[index];
                if ([dictM.allKeys containsObject:@"list"]){
                    NSMutableArray *array = [dictM objectForKey:@"list"];
                    NSMutableArray *array2 = [NSMutableArray arrayWithArray:array];
                    for (Service_Sector22 *contact22 in array2) {
                        if (contact22.gc_id == contact.gc_id){
                            [array removeObject:contact22];
                        }
                    }
                    dictM[@"list"] = array;
                }
                
                [self.resultArray removeObjectAtIndex:index];
                [self.resultArray addObject:dictM];
            }
        }else{
            [self.selectedIds addObject:contact.gc_id];
            if (haveKey){
                NSMutableDictionary *dictM = self.resultArray[index];
                if ([dictM.allKeys containsObject:@"list"]){
                    NSMutableArray *array = [dictM objectForKey:@"list"];
                    NSMutableArray *array2 = [NSMutableArray arrayWithArray:array];
                    for (Service_Sector22 *contact22 in array2) {
                        if (contact22.gc_id == contact.gc_id){
                            [array removeObject:contact22];
                        }
                    }
                    [array addObject:contact];
                    dictM[@"list"] = array;
                }else{
                    NSMutableArray *arrayM = [NSMutableArray array];
                    [arrayM addObject:contact];
                    dictM[@"list"] = arrayM;
                }
                
                [self.resultArray removeObjectAtIndex:index];
                [self.resultArray addObject:dictM];
            }
        }
    }
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
