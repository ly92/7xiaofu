//
//  RightCollectionViewCell.h
//  Group
//
//  Created by randy on 16/3/1.
//  Copyright © 2016年 Randy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImgV;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong, nonatomic) IBOutlet UILabel *inventoryLbl;
@property (strong, nonatomic) IBOutlet UILabel *areaLbl;
@end
