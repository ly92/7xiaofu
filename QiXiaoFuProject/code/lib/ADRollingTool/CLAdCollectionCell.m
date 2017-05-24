//
//  CLAdCollectionCell.m
//  Budayang
//
//  Created by darren on 16/4/12.
//  Copyright © 2016年 chinaPnr. All rights reserved.
//

#import "CLAdCollectionCell.h"

@implementation CLAdCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.lableContent1 = [[UILabel alloc] init];
        self.lableContent1.backgroundColor = [UIColor whiteColor];
         self.lableContent1.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lableContent1];
         self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lableContent1.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
//    self.lableContent1.text = @"啥！丁俊晖夺冠？";
}



- (void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;

}


@end

