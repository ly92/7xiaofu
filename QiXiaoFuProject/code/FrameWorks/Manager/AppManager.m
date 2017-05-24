//
//  SystemManager.m
//  bzy
//
//  Created by 八爪鱼 on 16/3/9.
//  Copyright © 2016年 冯洪建. All rights reserved.
//

#import "AppManager.h"

@interface AppManager ()
@property(nonatomic,copy)NSString* verison;
@property(nonatomic,copy)NSString* build;
@end

@implementation AppManager

+ (AppManager *)sharedManager
{
    static AppManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

/**当前Verison号*/
-(NSString*)getCurrentVerison
{
    if (self.verison == nil) {
        
        self.verison = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    
    return self.verison;
}

/**当前Build号*/
-(NSString*)getCurrentBuild
{
    if (self.build == nil) {
        
        self.build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    
    return self.build;
}

@end
