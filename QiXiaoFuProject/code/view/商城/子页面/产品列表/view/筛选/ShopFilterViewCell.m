//
//  ShopFilterViewCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopFilterViewCell.h"
#import "ShopListModel.h"

#define offset [UIScreen mainScreen].bounds.size.width/3*2
#define buttonBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@interface ShopFilterViewCell ()
{
    NSMutableArray *buttonArr;
}

@end


@implementation ShopFilterViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView dataArray:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath
{
    NSString * baseCell = [NSString stringWithFormat:@"Brand%ld", indexPath.section];
    ShopFilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCell];
    if (!cell) {
        cell = [[ShopFilterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCell dataArray:arr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataArray:(NSMutableArray *)arr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buttonArr = [NSMutableArray array];
        for (int i=0; i< arr.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            [button setBackgroundColor:buttonBackgroundColor];
            button.titleLabel.font = [UIFont systemFontOfSize:13.0];
            button.tag = i;
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            [buttonArr addObject:button];
        }
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (!button.selected) {
        button.selected = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"YES"];
    }else {
        button.selected = NO;
        [button setBackgroundColor:buttonBackgroundColor];
        button.layer.borderWidth = 0.0;
        [self.delegate selectedValueChangeBlock:self.tag key:button.tag value:@"NO"];
    }
}

- (void)setSelectedArr:(NSMutableArray *)selectedArr
{
    for (int i = 0; i < selectedArr.count; i++) {
        UIButton *button = buttonArr[i];
        //是否为选中状态
        NSString *selectedStr = selectedArr[i];
        if ([selectedStr isEqualToString:@"YES"]) {
            button.selected = YES;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor redColor].CGColor;
        }else {
            button.selected = NO;
            [button setBackgroundColor:buttonBackgroundColor];
            button.layer.borderWidth = 0.0;
        }
    }
}

- (void)setAttributeArr:(NSMutableArray *)attributeArr
{
    /** 九宫格布局算法 */
    CGFloat spacing = 5.0;//行、列 间距
    int totalloc = 2;//列数
    CGFloat appvieww = (offset - spacing*4)/totalloc;
    CGFloat appviewh = 30;
    int row = 0 ;
    for (int i=0; i< attributeArr.count; i++) {
        row = i/totalloc;//行号
        int loc = i%totalloc;//列号
        
        CGFloat appviewx = spacing + (spacing + appvieww) * loc;
        CGFloat appviewy = spacing + (spacing + appviewh) * row;
        
        UIButton *button = buttonArr[i];
        
        button.frame = CGRectMake(appviewx, appviewy, appvieww, appviewh);
        Area_List * area_List = attributeArr[i];
        [button setTitle:area_List.area_name forState:UIControlStateNormal];
        
    }
    _height = (spacing + appviewh) * (row + 1) + spacing;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
