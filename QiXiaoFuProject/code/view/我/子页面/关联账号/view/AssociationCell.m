//
//  AssociationCell.m
//  QiXiaoFuProject
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import "AssociationCell.h"

@interface AssociationCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *settingMarkBtn;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;

@end


@implementation AssociationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    _iconImageView.layer.cornerRadius = 25;
    _iconImageView.clipsToBounds = YES;
    [_settingMarkBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    
    [_settingMarkBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        UIAlertView *    customAlertView = [[UIAlertView alloc] initWithTitle:@"设置备注" message:@"请输入要设置的备注名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存",nil];
        [customAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *nameField = [customAlertView textFieldAtIndex:0];
        nameField.keyboardType = UIKeyboardTypeDefault;
        nameField.placeholder = @"输入";
        [customAlertView show];
        
    }];

    
    
    // Initialization code
}

- (void)setMe_to_user:(Me_To_User *)me_to_user{

    
    _me_to_user = me_to_user;
    
    [_iconImageView setImageWithUrl:me_to_user.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = me_to_user.member_name;
    _timeLab.text = [Utool comment_timeStamp2TimeFormatter:me_to_user.inputtime];
    _levelLab.text = [NSString stringWithFormat:@"级别: %@",me_to_user.jibie];

    if(me_to_user.to_user_name.length != 0){
        [_settingMarkBtn setTitle:me_to_user.to_user_name forState:UIControlStateNormal];
    }

}


- (void)setUser_to_me:(User_To_Me *)user_to_me{

    _user_to_me = user_to_me;
    
    [_iconImageView setImageWithUrl:user_to_me.member_avatar placeholder:kDefaultImage_header];
    _nameLab.text = user_to_me.member_name;
    _timeLab.text = [Utool comment_timeStamp2TimeFormatter:user_to_me.inputtime];
    
    _levelLab.text = [NSString stringWithFormat:@"级别: %@",user_to_me.jibie];
    
    if(user_to_me.to_user_name.length != 0){
    
        [_settingMarkBtn setTitle:user_to_me.to_user_name forState:UIControlStateNormal];
    }
    

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString * string = nameField.text;
        LxDBAnyVar(string);
        
        NSString * memberId =(_me_to_user.member_id.length ==0)?_user_to_me.member_id:_me_to_user.member_id;
        
        NSMutableDictionary * params = [NSMutableDictionary new];
        params[@"userid"] = @"9632f32bc685ca31a5dbcef444bfbf2f";
        params[@"name"] = string;
        params[@"id"] = memberId;
        
        [MCNetTool postWithUrl:HttpMeSetMemberNote params:params success:^(NSDictionary *requestDic, NSString *msg) {
            
            
            [_settingMarkBtn setTitle:string forState:UIControlStateNormal];
            
            [self showSuccessText:msg];
            
        } fail:^(NSString *error) {
            [self showErrorText:error];
        }];
        
    }
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
