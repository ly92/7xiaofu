//
//  ShopCarViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
#import "BlockUIAlertView.h"
#import "ShopCarModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ShopPayViewController.h"
#import "ShopDetaileViewController.h"

@interface ShopCarViewController ()<ShopCarCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *goPayBtn;// 支付按钮
@property (weak, nonatomic) IBOutlet UIButton *allChooseBtn;// 全选按钮
@property (weak, nonatomic) IBOutlet UILabel *priceLab;// 显示总金额

@property (strong,nonatomic)NSMutableArray * dataArray;
@property(nonatomic,assign) float allPrice;

@property (strong,nonatomic)ShopCarModel * shopCarModel;



@end

@implementation ShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
    
    _allPrice = 0.00;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShopCarCell" bundle:nil] forCellReuseIdentifier:@"ShopCarCell"];
    _tableView.tableFooterView = [UIView new];
    
    // 全选按钮
    [_allChooseBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
       
        btn.tag = !btn.tag;
        if (btn.tag)
        {
            btn.selected = YES;
        }else{
            btn.selected = NO;
            
        }
        //改变单元格选中状态
        for (int i=0; i<self.dataArray.count;i++)
        {
            Cart_List * cart_List = self.dataArray[i];
            cart_List.selectState = btn.tag;
        }
        
        
        [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
            
        }];
        
        [self.tableView reloadData];

        
    }];
        
    [_tableView headerAddMJRefresh:^{
       
        [self loadShopCarListData];
    }];
}

#pragma mark - 购物车结算
//
- (IBAction)goPayBtnAction:(id)sender {

    [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
        
        
        if (card_ids.length == 0) {
            [self showErrorText:@"当前购物车没有商品"];
            return ;
        }
        
        
        ShopPayViewController * vc = [[ShopPayViewController alloc]initWithNibName:@"ShopPayViewController" bundle:nil];
        vc.ifcart = 1;
        vc.cart_id = card_ids;
        vc.cartGoodsArray =cartselectArray;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self loadShopCarListData];


}



#pragma mark - 加载购物车数据
- (void)loadShopCarListData{

    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    
    [MCNetTool postWithUrl:HttpShopCarList params:params success:^(NSDictionary *requestDic, NSString *msg) {
        _dataArray = [NSMutableArray new];
        _shopCarModel = [ShopCarModel mj_objectWithKeyValues:requestDic];
        for (Cart_List * cart_List in _shopCarModel.cart_list) {
            cart_List.selectState = NO;
            [_dataArray addObject:cart_List];
        }
        [self.tableView reloadData];
        
        if (_dataArray.count ==0 ) {
            [_tableView showHeader];
        }else{
            [_tableView hidenHeader];
        }
        
        [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
            
        }];
        [_tableView headerEndRefresh];
        
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewShopCar withScrollView:_tableView];
        
        
    } fail:^(NSString *error) {
        
        [self showErrorText:error];
        [_tableView headerEndRefresh];
        
        [EmptyViewFactory emptyDataAnalyseWithDataSouce:_dataArray empty:EmptyDataTableViewShopCar withScrollView:_tableView];

    }];

}




#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCarCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ShopCarCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.cart_List = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.cheackBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        btn.selected =! btn.selected;
        /**
         * 判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
         */
        Cart_List *model = self.dataArray[btn.tag];
        model.selectState = btn.selected;
        [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
        }];
    }];
    return cell;
}


#pragma mark -- 实现加减按钮点击代理事件
/**
 * 实现加减按钮点击代理事件
 *
 * @param cell 当前单元格
 * @param flag 按钮标识，11 为减按钮，12为加按钮
 */

-(void)btnClick:(UITableViewCell *)cell andNum:(NSInteger)flag{
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    Cart_List *model = self.dataArray[index.row];
    model.goods_num = flag;
    //刷新表格
    [self.tableView reloadData];
    //计算总价
    [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
        
    }];}

#pragma mark - 计算价格 并且返回加入购物车商品的 购物车id 以及 选中的购物车实体数组

/**
 *  //计算价格
 *
 *  @param clearing card_ids  选中的购物车id 选中的购物车实体数组
 */
-(void )calculationPrice:(void (^)(NSString * card_ids,NSArray * cartselectArray))clearing
{
    NSMutableArray * cart_idArray= [NSMutableArray new];
    NSMutableArray * cartArray= [NSMutableArray new];

    //遍历整个数据源，然后判断如果是选中的商品，就计算价格(单价 * 商品数量)
    for ( int i =0; i<self.dataArray.count;i++)
    {
        Cart_List *model = self.dataArray[i];
        if (model.selectState)
        {
            self.allPrice = self.allPrice + model.goods_num * [model.goods_price floatValue] ;
//            _allChooseBtn.selected = YES;
            
            NSString * cartid = [NSString stringWithFormat:@"%@|%@",model.cart_id,@(model.goods_num)];
            [cart_idArray addObject:cartid];
            [cartArray addObject:model];

        }else{
            _allChooseBtn.selected = NO;
        }
    }
    //给总价赋值
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总金额:￥%.2f元",self.allPrice]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,4)];
    self.priceLab.attributedText = str;
    
    NSLog(@"%f",self.allPrice);
    
    self.allPrice = 0.0;
    

    NSString * card_ids = [cart_idArray componentsJoinedByString:@","];
    
    if(cartArray.count == _dataArray.count){
        _allChooseBtn.selected = YES;
    }else{
        _allChooseBtn.selected = NO;
    }
    
    
    
    clearing(card_ids,cartArray);
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    Cart_List *model = self.dataArray[indexPath.row];
    ShopDetaileViewController * vc = [[ShopDetaileViewController alloc]initWithNibName:@"ShopDetaileViewController" bundle:nil];
    vc.goods_id =model.goods_id;
    vc.goods_image = model.goods_image_url;

    [self.navigationController pushViewController:vc animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  71;
}

#pragma mark - tableView删除section或者row
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){

        
        BlockUIAlertView * alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除此商品吗" cancelButtonTitle:@"取消" clickButton:^(NSInteger buttonIndex) {
            
            if(buttonIndex == 1){
                
                Cart_List *model = self.dataArray[indexPath.row];

                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"userid"] = kUserId;
                params[@"store_id"] = @"1";
                params[@"cart_id"] = model.cart_id;
                
                [MCNetTool postWithUrl:HttpShopDelCar params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self showSuccessText:msg];
                    
                    [_dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的cell
                    
                    //计算总价
                    [self calculationPrice:^(NSString *card_ids, NSArray *cartselectArray) {
                        
                    }];
                    
                } fail:^(NSString *error) {
                    [self showErrorText:error];
                }];

            }
        } otherButtonTitles:@"确认"];
        [alert show];
 
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
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
