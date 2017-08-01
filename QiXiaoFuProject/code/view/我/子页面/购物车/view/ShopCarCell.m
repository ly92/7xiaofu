//
//  ShopCarCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/18.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopCarCell.h"
#import "PPNumberButton.h"



@interface ShopCarCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIView *bumView;
@property (nonatomic, strong)  PPNumberButton *numberButton;
@end


@implementation ShopCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bumView.backgroundColor = [UIColor clearColor];
    
    _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 110, 25)];
    _numberButton.input = YES;
    _numberButton.shakeAnimation = NO;
    _numberButton.backgroundColor = [UIColor clearColor];
    [_numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"increase_normal@2x"] decreaseImage:[UIImage imageNamed:@"decrease_normal@2x"]];
    
    WEAKSELF
    _numberButton.numberBlock = ^(NSString *num){
        DeLog(@"%@",num);
        if (num.intValue > self.cart_List.sum.intValue){
            return ;
        }
        [weakSelf editShopCarGoodsCount:num];
    };
    
    [_bumView addSubview:_numberButton];
    
    

    // Initialization code
}
// 修改商品数量
- (void)editShopCarGoodsCount:(NSString *)count{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    params[@"cart_id"] = _cart_List.cart_id;
    params[@"quantity"] = count;
    
    
    [MCNetTool postWithUrl:HttpShopEditCar params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        ShopCarEditModel * shopCarEditModel = [ShopCarEditModel mj_objectWithKeyValues:requestDic];
        _numberButton.currentNumber = [NSString stringWithFormat:@"%@",shopCarEditModel.quantity];
        
        [self.delegate btnClick:self andNum:[shopCarEditModel.quantity integerValue]];

    } fail:^(NSString *error) {
        
    }];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
    _cheackBtn.tag = _indexPath.row;

}

- (void)setCart_List:(Cart_List *)cart_List{


    _cart_List = cart_List;
    
    
     self.titleLab.text = cart_List.goods_name	;
    
    if (cart_List.selectState)
    {
        self.cheackBtn.selected = YES;
        self.selectState = YES;
        
    }else{
        self.selectState = NO;
        self.cheackBtn.selected = NO;
    }
    
    self.priceLab.text = [NSString stringWithFormat:@"¥ %@",cart_List.goods_price];
    
    [self.iconImageView setImageWithUrl:cart_List.goods_image_url placeholder:kDefaultImage_Z];
    ;
//     self.numberLab.text = [NSString stringWithFormat:@"%d",shoppingModel.goodsNum];
//    self.addNumberView.numberString = [NSString stringWithFormat:@"%d",shoppingModel.goodsNum];

    _numberButton.currentNumber = [NSString stringWithFormat:@"%@",@(cart_List.goods_num)];

}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation ShopCarEditModel



@end





