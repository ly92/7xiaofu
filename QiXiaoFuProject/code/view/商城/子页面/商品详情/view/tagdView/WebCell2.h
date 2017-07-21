//
//  WebCell.h
//  WebViewCellDemo
//
//  Created by xiayong on 16/8/31.
//  Copyright © 2016年 bianguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebCell2 : UITableViewCell

@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString * htmlUrl;
@property (nonatomic,assign) CGFloat height;
@property (strong, nonatomic) UIWebView *webView;

@property(nonatomic, copy) void (^webCell2ReturnHeightBlock)(WebCell2 * webCell,CGFloat height);


@end
