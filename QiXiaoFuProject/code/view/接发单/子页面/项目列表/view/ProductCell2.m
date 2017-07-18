//
//  ProductCell2.m
//  QiXiaoFuProject
//
//  Created by ly on 2017/7/18.
//  Copyright © 2017年 fhj. All rights reserved.
//

#import "ProductCell2.h"

#define TagVale 100


@interface ProductCell2()
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *severContentLab;
@property (weak, nonatomic) IBOutlet UILabel *severTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *severAdressLab;

@property (weak, nonatomic) IBOutlet UILabel *severPriceLab;
@end




@implementation ProductCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius=10;
    _bgView.clipsToBounds = YES;
    
    
    _iconImageView.layer.cornerRadius=14;
    _iconImageView.clipsToBounds = YES;
    
    // 这三句代码可以代替- (void)setSelected:(BOOL)selected animated:(BOOL)animated
    UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = view;
    
    // Initialization code
}



- (void)setProductModel:(ProductModel *)productModel{
    
    
    [_iconImageView setImageWithUrl:productModel.bill_user_avatar placeholder:kDefaultImage_header];
    
    _nameLbl.text = productModel.entry_name;
    _nameLab.text =productModel.bill_user_name;
    _timeLab.text = [Utool comment_timeStamp2TimeFormatter:productModel.inputtime];
    
    if (productModel.is_top==1) {
        _topBtn.hidden = NO;
    }else{
        _topBtn.hidden = YES;
    }
    _severContentLab.text = productModel.title;
    _severTimeLab.text =[NSString stringWithFormat:@"%@ - %@", [Utool timeStamp2TimeFormatter:productModel.service_stime], [Utool timeStamp2TimeFormatter:productModel.service_etime]];
    _severPriceLab.text = [NSString stringWithFormat:@"¥ %@",productModel.service_price];
    _severAdressLab.text =productModel.service_city;
    
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        
                        if (self.selected) {
                            img.image=[UIImage imageNamed:@"btn_checkbox_s"];
                        }else
                        {
                            img.image=[UIImage imageNamed:@"btn_checkbox_n"];
                        }
                    }
                }
            }
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        img.image = [UIImage imageNamed:@"btn_checkbox_n"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //    self.selected = NO;
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"btn_checkbox_s"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"btn_checkbox_n"];
                    }
                }
            }
        }
    }
    
}





@end
