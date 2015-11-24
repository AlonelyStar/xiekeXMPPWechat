//
//  WCXMPPTool.h
//  Wechat
//
//  Created by 谢科的Mac on 15/11/17.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"


typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetError,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
    
}XMPPResultType;

typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool);

@property (nonatomic, strong)XMPPvCardTempModule *vCard;
@property (nonatomic, strong)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
@property (nonatomic, strong)XMPPRoster *roster;//花名册模块
@property (nonatomic, strong)XMPPStream *xmppStream;
@property (nonatomic, strong)XMPPMessageArchiving *msgArchiving;//消息归档
@property (nonatomic, strong)XMPPMessageArchivingCoreDataStorage *msgStorage;//消息归档数据存储

//注册的标示,YES代表注册, NO 代表登录
@property (nonatomic, assign, getter = isRegisterOperation)BOOL RegisterOperation;

//用户登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock;
//用户注销
-(void)xmppUserlogout;
//用户注册
- (void)xmppUserRegist:(XMPPResultBlock)resultBlock;

@end
