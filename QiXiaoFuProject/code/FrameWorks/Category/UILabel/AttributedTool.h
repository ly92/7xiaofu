//
//  AttributedTool.h
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributedTool : NSObject


+ (void)attributedLab:(UILabel *)lab color:(UIColor *)color range:(NSRange)range;

+ (void)attributedLab:(UILabel *)lab fontSize:(CGFloat)fontSize range:(NSRange)range;

+ (void)attributedLab:(UILabel *)lab color:(UIColor *)color fontSize:(CGFloat)fontSize range:(NSRange)range;
+ (void )attributedLab:(UILabel *)lab  deletLineRange:(NSRange)range;


+ (NSMutableAttributedString *)linkText:(NSString *)text range:(NSRange)range;

// 调整行间距
+ (void)attributedLabLineSpacing:(UILabel *)lab space:(NSInteger )space;
 
@end
