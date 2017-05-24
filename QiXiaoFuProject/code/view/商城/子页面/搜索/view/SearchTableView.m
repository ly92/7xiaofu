//
//  SearchTableView.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SearchTableView.h"
#import "SearchKeyModel.h"

@interface SearchTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SearchTableView

+ (SearchTableView *)contentTableView {
    SearchTableView *contentTV = [[SearchTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    contentTV.backgroundColor = [UIColor clearColor];
    contentTV.dataSource = contentTV;
    contentTV.delegate = contentTV;
    contentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentTV.tableFooterView = [UIView new];
    return contentTV;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
 }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellid = @"cellid";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor = RGBA(255, 255, 255, 0.8);;
    }
    
    SearchKeyModel * model =_dataArray[indexPath.row];
    cell.textLabel.text = model.searchKey;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kRatio(180);
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchKeyModel * model =_dataArray[indexPath.row];

    
//    SearchReslutViewController * vc = [[SearchReslutViewController alloc]init];
//    vc.searchText = model.searchKey;
//    [[self viewController].navigationController pushViewController:vc animated:YES];
//    
    
    if(_searchTableViewBlock){
        _searchTableViewBlock(model.searchKey);
    }
    
    
    
    
    [self removeFromSuperview];
    [self.superview removeFromSuperview];

}

@end
