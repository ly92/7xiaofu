//
//  ChooseSeviceDomainViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ChooseSeviceDomainViewController.h"
#import "PDCollectionViewFlowLayout.h"
//#import "User.h"
#import "ChooseSeviceDomainCell.h"

@interface ChooseSeviceDomainViewController ()<PDCollectionViewFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (weak, nonatomic) IBOutlet UIButton *toggleSelectionBtn;
//@property (weak, nonatomic) IBOutlet UIButton *doneBtn;



@property (nonatomic, strong) NSMutableIndexSet* selectedIndexSet;
@end

@implementation ChooseSeviceDomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择服务领域";
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(rightTrueAction:)];
    
    
    self.selectedIndexSet = [NSMutableIndexSet indexSet];
    
    PDCollectionViewFlowLayout * layout = [[PDCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.columnCount = 3;
    _collectionView.collectionViewLayout = layout;
    _collectionView.scrollEnabled  =YES;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseSeviceDomainCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ChooseSeviceDomainCell class])];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"hear"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:CZCollectionElementKindSectionFooter withReuseIdentifier:@"EngineerFooterReusableView"];
    self.collectionView.allowsMultipleSelection = _allowsMultipleSelection;
        // Do any additional setup after loading the view from its nib.
}

#pragma mark - 确认选中的领域
- (void)rightTrueAction:(UIBarButtonItem *)item{
    
    
    NSArray * selectArray = [self selectedContacts];
    
    if(selectArray.count == 0){
        [self showErrorText:@"请选择技能领域"];
        return;
    }
    
    
    
     if (_domainsChooseSeviceDomainViewBlock) {
        _domainsChooseSeviceDomainViewBlock([self selectedContacts]);
    }
     LxDBAnyVar(@"你选的区域是：");
    LxDBAnyVar([self selectedContacts]);
     
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateSelections];
}


- (void)updateViews {
    [self updateToggleSelectionButton];
 

}

- (void)updateSelections {
    if (!self.selectedContactIds || ![self.selectedContactIds count]) {
        return;
    }
    NSIndexSet *selectedContactsIndexSet = [self.domains indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Service_Sector12 *contact = obj;
        return [self.selectedContactIds containsObject:contact.gc_id];
    }];
    
    [selectedContactsIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.selectedIndexSet addIndex:indexPath.item];
    }];
    
    [self updateToggleSelectionButton];
}

- (void)updateToggleSelectionButton {
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    NSString *title = !allEnabledContactsSelected ? @"全选" : @"全不选";
    [self.toggleSelectionBtn setTitle:title forState:UIControlStateNormal];
}

- (NSIndexSet *)enabledContactsIndexSetForContancts:(NSArray *)contacts {
    NSIndexSet *enabledContactsIndexSet = nil;
    if ([self.disabledContactIds count]) {
        enabledContactsIndexSet = [contacts indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            Service_Sector12* contact = obj;
            return ![self.disabledContactIds containsObject:contact.gc_id];
        }];
    } else {
        enabledContactsIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [contacts count])];
    }
    
    return enabledContactsIndexSet;
}

- (BOOL)allEnabledContactsSelected {
    NSIndexSet* enabledIndexSet = [self enabledContactsIndexSetForContancts:self.domains];
    BOOL allEnabledContactsSelected = [self.selectedIndexSet containsIndexes:enabledIndexSet];
    return allEnabledContactsSelected;
}

- (NSArray *)selectedContacts {
    return [self.domains objectsAtIndexes:self.selectedIndexSet];
}

#pragma mark PickerViewDataSource


#pragma mark PickerViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        Service_Sector12 *contact = _domains[item];
        return ![self.disabledContactIds containsObject:contact.gc_id];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.disabledContactIds count]) {
        NSInteger item = indexPath.item;
        Service_Sector12 *contact = _domains[item];
        return ![self.disabledContactIds containsObject:contact.gc_id];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedIndexSet addIndex:indexPath.item];
    [self updateToggleSelectionButton];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedIndexSet removeIndex:indexPath.item];
    [self updateToggleSelectionButton];
}

#pragma mark actions

- (IBAction)handleToggleSelectionBtn:(id)sender {
    NSUInteger count = [self.domains count];
    BOOL allEnabledContactsSelected = [self allEnabledContactsSelected];
    if (!allEnabledContactsSelected) {
        [self.collectionView performBatchUpdates:^{
            for (NSUInteger index = 0; index < count; ++index) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath]) {
                    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    [self.selectedIndexSet addIndex:indexPath.item];
                }
            }
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    } else {
        [self.collectionView performBatchUpdates:^{
            [self.selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                
                if ([self collectionView:self.collectionView shouldDeselectItemAtIndexPath:indexPath]) {
                    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
                    [self.selectedIndexSet removeIndex:indexPath.item];
                }
            }];
        } completion:^(BOOL finished) {
            [self updateToggleSelectionButton];
        }];
    }
}



#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
#pragma mark - MUCollectionViewFlowLayoutDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_domains count];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CZCollectionElementKindSectionHeader])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:CZCollectionElementKindSectionHeader withReuseIdentifier:@"hear" forIndexPath:indexPath];
        view.backgroundColor = [UIColor yellowColor];
        return view;
    }
    else if ([kind isEqualToString:CZCollectionElementKindSectionFooter])
    {
        UICollectionReusableView * engineerFooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"EngineerFooterReusableView" forIndexPath:indexPath];
        engineerFooterReusableView.backgroundColor = [UIColor whiteColor];
        return engineerFooterReusableView;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooseSeviceDomainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseSeviceDomainCell" forIndexPath:indexPath];
    Service_Sector12 *contact = _domains[ indexPath.item];
    cell.user = contact;
    cell.disabled = [self.disabledContactIds containsObject:contact.gc_id];
    return cell;
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
