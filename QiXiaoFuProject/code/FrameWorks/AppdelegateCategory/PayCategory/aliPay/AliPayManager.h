//
//  AliPayManager.h
//  TomatoDemo
//
//  Created by 冯洪建 on 15/8/18.
//  Copyright (c) 2015年 hongjian feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSigner.h"
#import "TomatoSingleton.h"
#import "ShopPayModel.h"


@interface AliPayManager : NSObject
TomatoSingletonH(AliPayManager)

@property (strong, nonatomic) ShopPayModel * shopPayModel;

- (void)pay:(ShopPayModel *)shopPayModel;

@end



