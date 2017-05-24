//
//  EngineerDetaileViewController.m
//  QiXiaoFuProject
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "EngineerDetaileViewController.h"
#import "EngineerDetaileHeaderCell.h"
#import "EngineerDetaileWordCell.h"
#import "CommentCell.h"
#import "EngineerDetaileModel.h"
#import "EngineerDetaileImageCell.h"
#import "EngineerDetaileIFooterView.h"
#import "CommentListViewController.h"
#import "CommentReplyCell.h"
#import "EngineerDetaileZhengShuCell.h"
#import "CommentViewController.h"

@interface EngineerDetaileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) EngineerDetaileModel *engineerDetaileModel;
@property (nonatomic, strong) NSMutableArray *service_sector;
@property (nonatomic, strong) NSMutableArray *service_brand;

@end

@implementation EngineerDetaileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"工程师详情";
    
//     self.navigationItem.rightBarButtonItem= [UIBarButtonItem itemWithTitle:@"评论" target:self action:@selector(commentItemAction:)];
//    
    _titles  =@[@"技能领域",@"擅长品牌",@"从业年限"];;
    _service_sector = [NSMutableArray new];
    _service_brand = [NSMutableArray new];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerDetaileHeaderCell" bundle:nil] forCellReuseIdentifier:@"EngineerDetaileHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
     [_tableView registerNib:[UINib nibWithNibName:@"EngineerDetaileWordCell" bundle:nil] forCellReuseIdentifier:@"EngineerDetaileWordCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerDetaileImageCell" bundle:nil] forCellReuseIdentifier:@"EngineerDetaileImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CommentReplyCell" bundle:nil] forCellReuseIdentifier:@"CommentReplyCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"EngineerDetaileZhengShuCell" bundle:nil] forCellReuseIdentifier:@"EngineerDetaileZhengShuCell"];


    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    footerView.backgroundColor = [UIColor clearColor];
     EngineerDetaileIFooterView * footer = [EngineerDetaileIFooterView engineerDetaileIFooterView];
    footer.frame = CGRectMake(0, 0, kScreenWidth, 80);
    [footerView addSubview:footer];
    _tableView.tableFooterView = footerView;
    
     [footer.moreCommentBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        CommentListViewController * vc   =[[CommentListViewController alloc]initWithNibName:@"CommentListViewController" bundle:nil];
        vc.member_id = _member_id;
         vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [self loadEngierInfo];

    

    // Do any additional setup after loading the view from its nib.
}

- (void)commentItemAction:(UIBarButtonItem *)item{
    
    CommentViewController * vc = [[CommentViewController alloc]initWithNibName:@"CommentViewController" bundle:nil];
    vc.f_id = _member_id;
    vc.commentViewBlock =^(){
        
        [self loadEngierInfo];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)loadEngierInfo{


    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"member_id"] = _member_id;
    
    [MCNetTool postWithCacheUrl:HttpMainEngDetail params:params success:^(NSDictionary *requestDic, NSString *msg) {
        
        _engineerDetaileModel = [EngineerDetaileModel mj_objectWithKeyValues:requestDic];
        
        [_engineerDetaileModel.service_sector enumerateObjectsUsingBlock:^(Service_Sector1 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_service_sector addObject:obj.gc_name];
        }];
        //        [_engineerDetaileModel.service_brand enumerateObjectsUsingBlock:^(Service_Brand1 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            [_service_brand addObject:obj.gc_name];
        //        }];
        
        
        [_tableView reloadData];
        
    } fail:^(NSString *error) {
        [self showErrorText:error];
    }];


}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 +  _engineerDetaileModel.evaluation.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==0) {
        return 1;
    }else
    if(section == 1){
        return _titles.count;
    }else
    if(section == 2){
        
//        if (_engineerDetaileModel.cer_images.count>3) {
//            return 2;
//         }
        return 1 + _engineerDetaileModel.cer_images.count;
    }else{
        
        Evaluation1 * evaluation1=_engineerDetaileModel.evaluation[section - 3];
        return evaluation1.reply_list.count + 1;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         EngineerDetaileHeaderCell *  cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerDetaileHeaderCell"];
         cell.engineerDetaileModel =_engineerDetaileModel;
         return cell;
    }
    else if (indexPath.section == 1) {
        EngineerDetaileWordCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerDetaileWordCell"];
        cell.titleLab.text = _titles[indexPath.row];
        if (indexPath.row ==0) {
            
            NSString * service_sector = [_service_sector componentsJoinedByString:@"、"];
            cell.contentLab.text = service_sector.length ==0?@" ":service_sector;
            
         }else if (indexPath.row == 1){
             cell.contentLab.text = _engineerDetaileModel.service_brand.length == 0?@"  ":_engineerDetaileModel.service_brand;//[_service_brand componentsJoinedByString:@""];
          }else if (indexPath.row == 2){
            cell.contentLab.text = [NSString stringWithFormat:@"%@年",_engineerDetaileModel.working_year];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
//        EngineerDetaileImageCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerDetaileImageCell"];
//        cell.row = indexPath.row;
//        cell.imageArray =_engineerDetaileModel.cer_images;
//        return cell;
        
        EngineerDetaileZhengShuCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"EngineerDetaileZhengShuCell"];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 0) {
            cell.titleLab.hidden = NO;
            cell.contentLab.hidden = YES;
            
            if (_engineerDetaileModel.cer_images.count == 0) {
                cell.zhengshuImageView.hidden = YES;

            }else{
                cell.zhengshuImageView.hidden = NO;
            }
            

        }else{
            cell.titleLab.hidden = YES;
            cell.contentLab.hidden = NO;
            cell.zhengshuImageView.hidden = YES;

            Cer_Images * ce = _engineerDetaileModel.cer_images[indexPath.row - 1];
            cell.contentLab.text =ce.cer_image_name;
         }
         return cell;

    }
    
    else  {
        if(indexPath.row ==0){
            CommentCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            Evaluation1 * evaluation1=_engineerDetaileModel.evaluation[indexPath.section - 3];
            cell.evaluation1 =evaluation1;
            return cell;
        }else{
            Evaluation1 * evaluation1=_engineerDetaileModel.evaluation[indexPath.section - 3];
            Reply_List1 * reply_List =evaluation1.reply_list[indexPath.row - 1];
            CommentReplyCell*  cell = [tableView dequeueReusableCellWithIdentifier:@"CommentReplyCell"];
            cell.backgroundColor  =[UIColor clearColor];
            cell.reply_List =(Reply_List *)reply_List;
            return cell;
        }
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            if (_engineerDetaileModel.cer_images.count == 0) {
                return UITableViewAutomaticDimension;
            }else{
                return 80;
            }
        }
        return UITableViewAutomaticDimension;
    }else
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section ==3){
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,40)];
        lab.text =  @"    口碑评价";
        return lab;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==3){
        return 40;
    }
    return 0.001f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //    EngineerDetaileViewController * vc  = [[EngineerDetaileViewController alloc]initWithNibName:@"EngineerDetaileViewController" bundle:nil];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}



//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10.0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
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
