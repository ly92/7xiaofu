//
//  ShopDetaileTagCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/23.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopDetaileTagCell.h"
#import "TagModel.h"
#import "CommodityTagView.h"

@interface ShopDetaileTagCell()

@property (nonatomic, strong) NSMutableArray *commModelArray;


@end


@implementation ShopDetaileTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    CommodityTagView *commView = [[CommodityTagView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//    //先在控制器中产生数据
//    [self initCommModelArray];
//    //初始化view
//    [commView initCollectionViewWithModel:self.commModelArray];
//    //加入view中
//    [self.contentView addSubview:commView];
}


- (void)setGoodsDetaileModel:(GoodsDetaileModel *)goodsDetaileModel{

    _goodsDetaileModel = goodsDetaileModel;
    _commModelArray = [[NSMutableArray alloc]init];

    for (Store_Server * store_server in goodsDetaileModel.store_server) {
        TagModel *tag1 = [[TagModel alloc]init];
        tag1.tagID = 1;
        tag1.tagName = store_server.title;
        tag1.modelSelected = NO;
        [_commModelArray addObject:tag1];
    }
    
    CommodityTagView *commView = [[CommodityTagView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    //初始化view
    [commView initCollectionViewWithModel:self.commModelArray];
    //加入view中
    commView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:commView];
    
    _cellHeight = commView.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
