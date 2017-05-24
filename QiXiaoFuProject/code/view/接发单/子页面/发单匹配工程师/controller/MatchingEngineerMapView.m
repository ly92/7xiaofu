//
//  MatchingEngineerMapView.m
//  QiXiaoFuProject
//
//  Created by mac on 16/12/11.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "MatchingEngineerMapView.h"

#import <QuartzCore/QuartzCore.h>


#define  Arror_height 15

@interface MatchingEngineerMapView ()

{
    UIImageView * _iconImageView ;
    UILabel * _titleLab ;
    
    
    UILabel * classLab ;
    UILabel * timeLab ;
    UILabel * adressLab ;
    
}
-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;

@end

@implementation MatchingEngineerMapView

@synthesize contentView;

- (void)dealloc
{
    self.contentView = nil;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //        self.centerOffset = CGPointMake(0, -(220*kScreenWidth/640));
        
        self.centerOffset = CGPointMake(0, - 45);
        
        CGFloat width =  kScreenWidth - (30*kScreenWidth/640) * 2;
        CGFloat height =  55;
        
        self.frame = CGRectMake(0, 0, width, height);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        _contentView.backgroundColor   = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
        self.contentView = _contentView;
        
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        [_contentView addSubview:_iconImageView];
        _iconImageView.layer.cornerRadius = 30/2;
        _iconImageView.clipsToBounds = YES;
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.right + 10, 0, width - _iconImageView.right - 10, 40)];
        _titleLab.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_titleLab];
        
    }
    return self;
}

- (void)loadDataWithModel:(EngineerModel *)model{
    
    [_iconImageView setImageWithUrl:model.member_avatar placeholder:[UIImage imageNamed:@"me_img_default"]];
    _titleLab.text = [NSString stringWithFormat:@"%@",model.member_truename];
    
    _bdModel =model;
}




-(void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    //    CGContextSetLineWidth(context, 1.0);
    //     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //    [self getDrawPath:context];
    //    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}


@end
