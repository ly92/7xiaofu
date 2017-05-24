//
//  SearchViewControler.m
//  BeautifulFaceProject
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "SearchViewControler.h"
#import "MLSearchBar.h"
 #import "SearchTableView.h"
#import "BlockUIAlertView.h"
#import "SearchKeyManager.h"
#import "SearchCell.h"
#import "SearchFlowLayout.h"


@interface SearchViewControler ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{

    UIView * _searchtableViewBg;
}

 @property (nonatomic ,strong)NSArray * dataArray;
@property (nonatomic ,strong)NSMutableArray * searchDataArray;
@property (nonatomic, copy) NSString * screenString;

@property (nonatomic ,strong)SearchTableView * searchTableView;

@property (nonatomic ,strong)UITextField* searchTextField;

@end

@implementation SearchViewControler

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self clearNavigationBarColoTitleColor:[UIColor blackColor]];
    [self navigationBarView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSString * placeholder;
    
    if(_type == 1){
    
        placeholder= @"输入品牌型号、地点等搜索";
    }else{
        placeholder= @"输入商品品牌、名称、类别进行搜索";
    }
    
    
    UITextField * searchTextField=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 34)];
    searchTextField.delegate = self;
    searchTextField.placeholder =placeholder;
    searchTextField.font = [UIFont systemFontOfSize:14];
    searchTextField.layer.cornerRadius = 5;
    searchTextField.layer.masksToBounds  = YES;
    [searchTextField addTarget:self action:@selector(searchTextFieldChangeValueAction:) forControlEvents:UIControlEventValueChanged];
    searchTextField.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
     UIImageView *imgv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 34)];
    searchTextField.leftView=imgv;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.minimumFontSize = 12;
    searchTextField.returnKeyType =UIReturnKeySearch;

     self.navigationItem.titleView = searchTextField;
 
    
    _searchTextField = searchTextField;
    
    _searchDataArray = [NSMutableArray new];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];

    
    [_searchtableViewBg removeFromSuperview];
    [self clearNavigationBarColoTitleColor:[UIColor blackColor]];
//    [self clearNavigationBarShadowImage];
    
    [_searchTextField becomeFirstResponder];
}










- (void)tapAction{

    [_searchtableViewBg removeFromSuperview];
    [_searchTextField resignFirstResponder];

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}
/**
 *  添加收缩历史列表
 */
- (void)addSearchListTableView{

    
    
    _searchtableViewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _searchtableViewBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_searchtableViewBg];

    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [_searchtableViewBg addGestureRecognizer:tap];
    
    
    _searchTableView = [SearchTableView contentTableView];
    _searchTableView.frame= CGRectMake(-2, 0, self.view.frame.size.width + 4, self.view.frame.size.height);
    _searchTableView.backgroundColor =[UIColor clearColor] ;//RGBA(255, 255, 255, 0.7);
    _searchTableView.scrollEnabled = NO;
     [_searchtableViewBg addSubview:_searchTableView];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIColor * lineColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    footerView.layer.borderColor = lineColor.CGColor;
    footerView.layer.borderWidth = 1;
    _searchTableView.tableFooterView = footerView;
    
    UIButton * clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(0, 0, 110, 25);
    clearBtn.center = CGPointMake(footerView.width/2, footerView.height/2);
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [clearBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [clearBtn setBackgroundImage:[UIImage imageNamed:@"img_bg_content_s"] forState:UIControlStateNormal];
    [clearBtn setTitle:@"清除搜索记录" forState:UIControlStateNormal];
    [footerView addSubview:clearBtn];
    
    
    [clearBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
         
        BlockUIAlertView * alertView = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"是否要清空搜索记录" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex ) {
            
            if(buttonIndex != 0){
                [[SearchKeyManager sharedManager] removeProductAllSearchKey];
                [UIView animateWithDuration:0.3 animations:^{
                    _searchTableView.alpha = 1;
                } completion:^(BOOL finished) {
                    _searchTableView.hidden = YES;
                    [_searchTextField resignFirstResponder];
                    [_searchTableView removeFromSuperview];

                }];
            }
        } otherButtonTitles:@"确定"];
        [alertView show];
        
        
    }];
    
    WEAKSELF
    _searchTableView.searchTableViewBlock = ^(NSString * key){
    
    
        
        if (weakSelf.searchViewBlock) {
            weakSelf.searchViewBlock(key);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    _searchDataArray = [[SearchKeyManager sharedManager] searchProductSearchKey];
    if (_searchDataArray.count!= 0) {
        
        [self addSearchListTableView];
        
        _searchTableView.dataArray = _searchDataArray;
        _searchTableView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _searchTableView.hidden = NO;
        } completion:^(BOOL finished) {
            _searchTableView.alpha = 1;
            
        }];
    }



}
- (void)searchTextFieldChangeValueAction:(UITextField *)textField{

    self.screenString = textField.text;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    self.screenString = textField.text;
    [[SearchKeyManager sharedManager] insertProductSearchKey:self.screenString];
    
    
    if (_searchViewBlock) {
        _searchViewBlock(self.screenString);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
//    SearchReslutViewController * vc = [[SearchReslutViewController alloc]init];
//    vc.searchText = textField.text;
//    [self.navigationController pushViewController:vc animated:YES];

    return YES  ;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self loadShareListData];
    
    
    
}









/**
 *  添加导航按钮
 */
- (void)navigationBarView{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemCancleWithTitle:@" 取消" target:self action:@selector(cancleItemAction:)];
 }


- (void)cancleItemAction:(UIBarButtonItem *)item{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
     [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
