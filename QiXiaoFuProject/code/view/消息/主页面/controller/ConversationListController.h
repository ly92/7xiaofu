/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */
// 消息的主页面
#import "EaseConversationListViewController.h"

@interface ConversationListController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;


@end
