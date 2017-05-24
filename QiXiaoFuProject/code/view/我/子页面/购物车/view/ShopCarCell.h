//
//  ShopCarCell.h
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarModel.h"


@protocol ShopCarCellDelegate

-(void)btnClick:(UITableViewCell *)cell andNum:(NSInteger)flag;

@end


@interface ShopCarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cheackBtn;

@property (assign,nonatomic) BOOL selectState;//选中状态

@property (nonatomic,assign) id<ShopCarCellDelegate>delegate;


@property (nonatomic,strong) Cart_List * cart_List;

@property (nonatomic,strong) NSIndexPath * indexPath;

@end



@interface ShopCarEditModel : NSObject
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *goods_price;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *goods_count;
@property (nonatomic, copy) NSString *price_number;

@end


//        "quantity":444,
//        "goods_price":"99.00",
//        "total_price":"43956.00",
//        "goods_count":2,
//        "price_number":"312.00"



//        成功返回参数说明：
//
//        参数名	必选	类型	说明
//        quantity	是	string	商品数量
//        goods_price	是	string	商品单价
//        total_price	是	string	该商品购买总价
//        goods_count	是	string	购物车商品总数
//        price_number	是	string	购物车商品总价


