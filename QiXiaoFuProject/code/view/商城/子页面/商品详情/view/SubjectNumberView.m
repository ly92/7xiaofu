//
//  SubjectNumberView.m
//  BeautifulFaceProject
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SubjectNumberView.h"
#import "PPNumberButton.h"

@implementation SubjectNumberView


+ (SubjectNumberView *)footerView{

    SubjectNumberView *footerView = [[NSBundle mainBundle] loadNibNamed:@"SubjectNumberView" owner:self options:nil][0];

    
    PPNumberButton *numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    numberButton.input = NO;
    numberButton.shakeAnimation = NO;
    //numberButton.backgroundColor = [UIColor clearColor];
    [numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"increase_normal@2x"] decreaseImage:[UIImage imageNamed:@"decrease_normal@2x"]];
    
    numberButton.numberBlock = ^(NSString *num){
        DeLog(@"%@",num);
        
        if (footerView.subjectNumberViewBlock) {
            footerView.subjectNumberViewBlock([num integerValue]);
        }
        
    };
    
    [footerView.addSubToolView addSubview:numberButton];

    
    
    return footerView;

}






- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
    
    
    
    // Initialization code
}



- (IBAction)tapAction:(id)sender {
    
     [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
     } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)hidenView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
