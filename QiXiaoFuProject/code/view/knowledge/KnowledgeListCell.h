//
//  KnowledgeListCell.h
//  QiXiaoFuProject
//
//  Created by ly on 2017/8/22.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UILabel *agreeLbl;

@end
