//
//  SortTableView.m
//  PrettyFactoryProject
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "SortTableView.h"

@interface SortTableView ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation SortTableView

+ (SortTableView *)contentTableView {
    SortTableView *contentTV = [[SortTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTV.bounces = NO;
    contentTV.tableFooterView = [UIView new];
    
    return contentTV;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        UITapGestureRecognizer * sortTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sortTapAction:)];
        sortTap.delegate = self;
        [self addGestureRecognizer:sortTap];

    }
    return self;
}


- (void)setDataArray:(NSArray *)dataArray{

    _dataArray = dataArray;

    [self reloadData];
}





#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSInteger sortValue = 99999996;
    
    if (_type == 0) {
        sortValue = [[NSUserDefaults standardUserDefaults]integerForKey:@"left"];
    }else{
        sortValue = [[NSUserDefaults standardUserDefaults]integerForKey:@"right"];
    }
    
    if (sortValue == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = kThemeColor;
        cell.tintColor =kThemeColor;
    }else{
    
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
     }
  
    Value * value = _dataArray[indexPath.row];
    cell.textLabel.text = value.attr_value_name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (_type == 0) {
        [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"left"];
    }else{
        [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"right"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor =kThemeColor;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.tintColor =kThemeColor;
    
    
    Value * value = _dataArray[indexPath.row];

    if (_didSelectRow) {
        _didSelectRow(value);
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        tableView.alpha =0;
        //tableView.frame = CGRectMake(0, tableView.frame.origin.y, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        [tableView removeFromSuperview];
    }];

    
}



- (void)sortTapAction:(UITapGestureRecognizer *)tapG {
    if (_didDismisView) {
        _didDismisView(_type);
    }
//    [UIView animateWithDuration:0.3f animations:^{
//        self.alpha =0;
//
//        //self.frame = CGRectMake(0, self.frame.origin.y, kScreenWidth, 0);
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
}


//  tableView的侧滑是从右往左滑。而抽屉是从左往右滑。 解决方法刚刚找到了，判断滑动的视图。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}





@end
