//
//  EngineerCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerEditListCell.h"


#define TagVale 100



@interface EngineerEditListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *lingyuLab;

@property (weak, nonatomic) IBOutlet UILabel *quyuLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *yearLab;

@end


@implementation EngineerEditListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius=10;
    _bgView.clipsToBounds = YES;

    
    // 这三句代码可以代替- (void)setSelected:(BOOL)selected animated:(BOOL)animated
    UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = view;
    // 这个属性是编辑的时候最右边的accessory样式
    //    self.editingAccessoryType = UITableViewCellAccessoryCheckmark;

    // Initialization code
}


- (void)setEngineerModel:(EngineerModel *)engineerModel{

    _engineerModel = engineerModel;

    [_iconImageView setImageWithUrl:engineerModel.member_avatar placeholder:kDefaultImage_header];
    
    _nameLab.text =engineerModel.member_truename;


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
