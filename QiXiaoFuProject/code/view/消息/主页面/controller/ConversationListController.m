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

#import "ConversationListController.h"

#import "ChatViewController.h"
#import "RobotManager.h"
#import "RobotChatViewController.h"
#import "UserProfileManager.h"
#import "RealtimeSearchUtil.h"
//#import "ChatDemoHelper.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "EaseEmotionManager.h"
#import "NSDate+Category.h"
#import "YZSystemMessageModel.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2


#import "MessageHeaderView.h"
#import "SystemMessageViewController.h"
#import "ChatListModel.h"
#import "ChatDBManager.h"
#import "IConversationModel.h"


@interface ConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>
//系统消息
@property (nonatomic, strong) MessageHeaderView * messageHeaderView1;
//资金消息
@property (nonatomic, strong) MessageHeaderView * messageHeaderView2;
//接发单消息
@property (nonatomic, strong) MessageHeaderView * messageHeaderView3;

////未读系统消息数量
//@property (nonatomic, assign) NSInteger *unReadSystemNumber;

@end

@implementation ConversationListController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    //系统消息 资金消息 接发单消息
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 3*80)];
    //系统消息
    _messageHeaderView1 = [MessageHeaderView messageHeaderView];
    _messageHeaderView1.frame = CGRectMake(0, 0, kScreenWidth, 80);
    [topView addSubview:_messageHeaderView1];
    [_messageHeaderView1.clickBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        SystemMessageViewController * vc = [[SystemMessageViewController alloc]initWithNibName:@"SystemMessageViewController" bundle:nil];
        vc.systemMessageType = SystemMessageTypeSystem;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    //资金消息
    _messageHeaderView2 = [MessageHeaderView messageHeaderView];
    _messageHeaderView2.frame = CGRectMake(0, 80, kScreenWidth, 80);
    _messageHeaderView2.titleLab.text=@"资金消息";
    [topView addSubview:_messageHeaderView2];
    [_messageHeaderView2.clickBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        SystemMessageViewController * vc = [[SystemMessageViewController alloc]initWithNibName:@"SystemMessageViewController" bundle:nil];
        vc.systemMessageType = SystemMessageTypeMoney;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //接发单消息
    _messageHeaderView3 = [MessageHeaderView messageHeaderView];
    _messageHeaderView3.frame = CGRectMake(0, 160, kScreenWidth, 80);
    _messageHeaderView3.titleLab.text=@"接发单消息";
    [topView addSubview:_messageHeaderView3];
    [_messageHeaderView3.clickBtn tapControlEventTouchUpInsideWithBlock:^(UIButton *btn) {
        
        SystemMessageViewController * vc = [[SystemMessageViewController alloc]initWithNibName:@"SystemMessageViewController" bundle:nil];
        vc.systemMessageType = SystemMessageTypeSendReceiveMoney;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    topView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = topView;

  

    [self tableViewDidTriggerHeaderRefresh];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEaseModReceiveMessages:) name:@"didReceiveMessages" object:nil];
    
}

#pragma mark --接收到消息通知
- (void)didEaseModReceiveMessages:(NSNotification *)notification{

    [self tableViewDidTriggerHeaderRefresh];
    
}

#pragma mark - 获取系统消息数据
-(void)loadSystemMessageData{
    
   __block  NSInteger unreadMessageNumber = 0;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userid"] = kUserId;
    params[@"op"] = @"message_list";
    params[@"act"] = @"member_index";
    params[@"store_id"] = @"1";
    [MCNetTool postWithUrl:HttpApi params:params success:^(NSDictionary *requestDic, NSString *msg) {
        NSArray *listArr =(NSArray *)requestDic;
        
        if (listArr.count) {
            NSDictionary *systemMessageDict = listArr[0];
            
            YZSystemMessageModel *systemMessageModel=[YZSystemMessageModel mj_objectWithKeyValues:systemMessageDict];
            for (YZUnReadMessageModel *unReadMessageModel in systemMessageModel.countnum_all_count) {
                if ([unReadMessageModel.msg_type isEqual:@"1"]) {//系统消息
                    
                    if (unReadMessageModel.countnum.integerValue >0) {
                        
                        unreadMessageNumber+=unReadMessageModel.countnum.integerValue;
                        _messageHeaderView1.countLab.hidden = NO;
                        
                        _messageHeaderView1.contentLab.hidden = NO;
                        
                        _messageHeaderView1.countLab.text = unReadMessageModel.countnum;
                        _messageHeaderView1.contentLab.text = @"有新消息来了";
                        
                    }else{
                    
                        _messageHeaderView1.countLab.hidden = YES;
                        
                        _messageHeaderView1.contentLab.hidden = YES;
                        
                        _messageHeaderView1.countLab.text =@"";
                        
                        _messageHeaderView1.contentLab.text = @"";
                    
                    }
                    
                  
                }else if ([unReadMessageModel.msg_type isEqual:@"2"]){//资金消息
         
                    
                    if (unReadMessageModel.countnum.integerValue >0) {
                        
                        unreadMessageNumber+=unReadMessageModel.countnum.integerValue;
                        
                        _messageHeaderView2.countLab.hidden = NO;
                        
                        _messageHeaderView2.contentLab.hidden = NO;
                        
                        _messageHeaderView2.countLab.text = unReadMessageModel.countnum;
                        _messageHeaderView2.contentLab.text = @"有新消息来了";
                        
                    }else{
                        
                        _messageHeaderView2.countLab.hidden = YES;
                        
                        _messageHeaderView2.contentLab.hidden = YES;
                        
                        _messageHeaderView2.countLab.text =@"";
                        
                        _messageHeaderView2.contentLab.text = @"";
                        
                    }
                
                }else if ([unReadMessageModel.msg_type isEqual:@"3"]){//接发单消息
                
                    
                    if (unReadMessageModel.countnum.integerValue >0) {
                        unreadMessageNumber+=unReadMessageModel.countnum.integerValue;
                        
                        _messageHeaderView3.countLab.hidden = NO;
                        
                        _messageHeaderView3.contentLab.hidden = NO;
                        
                        _messageHeaderView3.countLab.text = unReadMessageModel.countnum;
                        _messageHeaderView3.contentLab.text = @"有新消息来了";
                        
                    }else{
                        
                        _messageHeaderView3.countLab.hidden = YES;
                        
                        _messageHeaderView3.contentLab.hidden = YES;
                        
                        _messageHeaderView3.countLab.text =@"";
                        
                        _messageHeaderView3.contentLab.text = @"";
                        
                    }
                }
            }
            
        }
        
        kUnreadSystemMessageNumber = unreadMessageNumber;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];


    } fail:^(NSString *error) {
        
        [PDHud showErrorWithStatus:error];
    }];
    
    

}

#pragma mark - 获取自己系统未读消息数目

- (void)loadNoReadCount{
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"store_id"] = @"1";
    
    [MCNetTool postWithUrl:HttpMessageReadCount params:params success:^(NSDictionary *requestDic, NSString *msg) {
          NSString *   _message_count =requestDic[@"message_count"];
         _messageHeaderView1.countLab.text  = _message_count;
        
        if ([_message_count isEqualToString:@"0"]) {
            _messageHeaderView1.countLab.hidden  = YES;
            _messageHeaderView1.contentLab.hidden  = YES;

        }else{
            _messageHeaderView1.countLab.hidden  = NO;
            _messageHeaderView1.contentLab.hidden  = YES;

         }
     } fail:^(NSString *error) {
         _messageHeaderView1.contentLab.hidden  = YES;

    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.dataArray removeAllObjects];
    
    [self refresh];

//    [self loadNoReadCount];
    //获取系统消息数量
    [self loadSystemMessageData];
    
    [self removeEmptyConversationsFromDB];
    [self tableViewDidTriggerHeaderRefresh];
    
    

}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
}

- (void)loadUserIconWithPhone:(NSString *)phone{

    UIImage * friendUserIcon = [Utool getFileFromLoc:phone];
    
    if (friendUserIcon == nil) {
        
        if ([phone isEqualToString:kPhone]){
            [UIImage loadImageWithUrl:kUserIcon returnImage:^(UIImage *image) {
                [Utool saveFileToLoc:phone theFile:image];
                [self.tableView reloadData];
            }];
        }else{
            NSMutableDictionary * params = [NSMutableDictionary new];
            params[@"phone"] = phone;
            [MCNetTool postWithUrl:HttpGetMemberInfoByPhone params:params success:^(NSDictionary *requestDic, NSString *msg) {
                
                ChatListModel * chatListModel = [[ChatListModel alloc] init];
                chatListModel.user = kPhone;
                chatListModel.userName = kUserName;
                chatListModel.userIcon = kUserIcon;
                
                chatListModel.friendUser = phone;
                chatListModel.friendUsername = [requestDic[@"member_nik_name"] length] == 0?requestDic[@"member_id"]:requestDic[@"member_nik_name"];
                chatListModel.friendUserIcon = requestDic[@"touxiang"];
                [[ChatDBManager shareManager] insertDataWithModel:chatListModel];
                
                [UIImage loadImageWithUrl:requestDic[@"touxiang"] returnImage:^(UIImage *image) {
                    [Utool saveFileToLoc:phone theFile:image];
                    [self.tableView reloadData];
                }];
                
            } fail:^(NSString *error) {
                
            }];
        }
     }
}






- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}


#pragma mark - EaseConversationListViewControllerDelegate

//刷新头视图的回调
-(void)conversationListViewReFreshHeaderView{
    
    //获取系统消息数量
     [self loadSystemMessageData];
}

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        
//        LxDBAnyVar(conversation.conversationId);
        
        if (conversation) {
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
                [self.navigationController pushViewController:chatController animated:YES];
            } else {
                
//                ChatViewController *chatController = [[ChatViewController alloc]
//                                                      initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
//
                
                NSMutableDictionary * params = [NSMutableDictionary new];
                params[@"phone"] = conversation.conversationId;
                
                [MCNetTool postWithUrl:HttpGetMemberInfoByPhone params:params success:^(NSDictionary *requestDic, NSString *msg) {
                    
                    [self goToChatView:conversation.conversationId friendUsername:[requestDic objectForKey:@"member_nik_name"] friendUserIcon:[requestDic objectForKey:@"touxiang"] avatarURLPath:conversationModel.avatarURLPath];
                    
                } fail:^(NSString *error) {
                    [self goToChatView:conversation.conversationId friendUsername:@"客服" friendUserIcon:[NSString stringWithFormat:@"%@%@",HttpCommonURL,HttpKefuHeaderImage] avatarURLPath:conversationModel.avatarURLPath];
                }];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

- (void)goToChatView:(NSString *)conversationChatter
      friendUsername:(NSString *)friendUsername
      friendUserIcon:(NSString *)friendUserIcon avatarURLPath:(NSString *)avatarURLPath{
    ChatViewController * chatController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter  friendUsername:friendUsername friendUserIcon:friendUserIcon];
    
    chatController.title = friendUsername;
    chatController.friendIcon = avatarURLPath;
    chatController.userIcon = kUserIcon;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    
     [self loadUserIconWithPhone:model.conversation.conversationId];
    
//    DeLog(@"+++++++++++  %@",model.conversation.conversationId);
    
    ChatListModel *  chatListModel = [[ChatDBManager shareManager] fetchAllUserWithFriendUser:model.conversation.conversationId];
    
    model.avatarURLPath = chatListModel.friendUserIcon;
    model.title = chatListModel.friendUsername;

    if (model.conversation.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:conversation.conversationId];
            if (profileEntity) {
                model.title = chatListModel.friendUsername.length==0?@"":chatListModel.friendUsername;
                model.avatarURLPath = profileEntity.imageUrl;
            }
        }
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        NSDictionary *ext = conversation.ext;
        model.title = [ext objectForKey:@"subject"];
        imageName = [[ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    
    DeLog(@"------------------  %@",lastMessage.from);
    
    
    
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"图片";//NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"语音";
//                NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"位置";
                //NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"视频";
                //NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"文件";
                //NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
//            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
            latestMessageTitle = [NSString stringWithFormat:@"%@", latestMessageTitle];

        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}

                                                               
                                                               
                                                               
#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}
              
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
                                               
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}
                                                    

                                                               
                                                               
                                                               
@end
