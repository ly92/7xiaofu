//
//  CertificationModel.h
//  QiXiaoFuProject
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 fhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertificationModel : NSObject

@property (nonatomic, copy) NSString *member_truename;//真实姓名

@property (nonatomic, copy) NSString *id_card;//身份证号

@property (nonatomic, copy) NSString *real_img1;//身份证正面

@property (nonatomic, copy) NSString *real_img2;//身份证背面

@property (nonatomic, copy) NSString *is_real;//0 未认证可提交 1 已认证不可提交 2 待审核不可提交

@end

//                参数名	类型	说明
//                member_truename	string	真实姓名
//                id_card	string	身份证号
//                real_img1	string	身份证正面
//                real_img2	string	身份证背面
//                is_real	string	0 未认证可提交 1 已认证不可提交 2 待审核不可提交
