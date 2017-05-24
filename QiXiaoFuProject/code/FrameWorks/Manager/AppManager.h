//
//  SystemManager.h
//  bzy
//
//  Created by 八爪鱼 on 16/3/9.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject
+ (AppManager *)sharedManager;
/**当前Verison号*/
-(NSString*)getCurrentVerison;
/**当前Build号*/
-(NSString*)getCurrentBuild;

@end
