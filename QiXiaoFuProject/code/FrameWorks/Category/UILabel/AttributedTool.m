//
//  AttributedTool.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "AttributedTool.h"

@implementation AttributedTool



+ (void)attributedLab:(UILabel *)lab color:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    lab.attributedText = attributedStr;
    
}

+ (void)attributedLab:(UILabel *)lab fontSize:(CGFloat)fontSize range:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:fontSize]
                          range:range];
    lab.attributedText = attributedStr;
}


+ (void)attributedLab:(UILabel *)lab color:(UIColor *)color fontSize:(CGFloat)fontSize range:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:fontSize]
                          range:range];
    lab.attributedText = attributedStr;
}


+ (void )attributedLab:(UILabel *)lab  deletLineRange:(NSRange)range{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:lab.text];
//    [attributedStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    
    [attributedStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle] range:range];
    
    
    lab.attributedText = attributedStr;

}



// 设置下划线
+ (NSMutableAttributedString *)linkText:(NSString *)text range:(NSRange)range{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange(1, text.length - 2)];
    return attributedStr;
}

+ (void)attributedLabLineSpacing:(UILabel *)lab space:(NSInteger )space{

    if (lab.text.length != 0) {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:lab.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lab.text length])];
        [lab setAttributedText:attributedString];
        [lab sizeToFit];
     }
}







@end
