//
//  AF_BrandCell.m
//  差五个让步
//
//  Created by Elephant on 16/5/4.
//  Copyright © 2016年 Elephant. All rights reserved.
//

#import "FilterViewCell.h"

#define offset [UIScreen mainScreen].bounds.size.width/3*2
#define buttonBackgroundColor [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]

@interface FilterViewCell ()
{
    NSMutableArray *buttonArr;
}

@end

@implementation FilterViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView dataArr:(NSArray *)arr indexPath:(NSIndexPath *)indexPath
{
    NSString * baseCell = [NSString stringWithFormat:@"Brand%ld", (long)indexPath.section];
    FilterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCell];
    if (!cell) {
        cell = [[FilterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCell dataArr:arr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataArr:(NSArray *)arr
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
    
    
    if (button.selected) {
        return;
    }
    NSInteger tag = button.tag;
    button.selected = YES;
    
    
    
    for (UIButton * btn in buttonArr) {
        if (btn.tag != tag) {
            btn.selected = NO;
            [btn setBackgroundColor:buttonBackgroundColor];
            btn.layer.borderWidth = 0.0;
        }
    }
//    if (!button.selected) {
        button.selected = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.delegate selectedValueChangeBlock:_indexPath.section key:button.tag value:@"YES"];
    
    
//    }else {
//        button.selected = NO;
//        [button setBackgroundColor:buttonBackgroundColor];
//        button.layer.borderWidth = 0.0;
//        [self.delegate selectedValueChangeBlock:_indexPath.section key:button.tag value:@"NO"];
//    }
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

- (void)setAttributeArr:(NSArray *)attributeArr
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
        
        [button setTitle:attributeArr[i] forState:UIControlStateNormal];
        
        _height = (spacing + appviewh) * (row + 1) + spacing;
      }
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
