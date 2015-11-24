//
//  WCXMPPTool.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/17.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCXMPPTool.h"
/*
 * 在AppDelegate实现登录
 
 1.初始化XMPPStream
 2.连接到服务器[传一个JID]
 3.连接到服务器成功后.再发送密码授权
 4.授权成功后,发送在线消息
 *
 */

@interface WCXMPPTool ()<XMPPStreamDelegate>{
    
    XMPPResultBlock _resultBlock;
    
    XMPPvCardCoreDataStorage *_vCardStorage;//电子名片存储
    XMPPvCardAvatarModule *_avatar;//头像模块
    
    XMPPReconnect *_reconnect;//自动连接模块
    
    
    
    
}

//1.初始化XMPPStream
- (void)setupXMPPStream;

//2.连接到服务器
- (void)connectToHost;

//3.连接到服务器成功后,再发送密码授权
- (void)sendPwdToHost;

//4.授权成功后,发送在线消息
- (void)sendOnlineToHost;

@end


@implementation WCXMPPTool
singleton_implementation(WCXMPPTool)

#pragma mark -私有方法

#pragma mark - 初始化XMPPStream
-(void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc]init];

#warning 每一个电子模块添加玩都要激活一下
    //添加子自动连接模块
    _reconnect = [[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    
    //激活电子名片
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    //添加花名册模块[获取好友列表]
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark-- 释放xmppStream相关的资源
- (void)teardownXmpp{
    //移除代理
    [_xmppStream removeDelegate:self];
    
    //停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    //断开连接
    [_xmppStream disconnect];
    
    //清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    
}

#pragma mark - 连接到服务器
-(void)connectToHost{
    WCLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置JID
    //resource 标示用户登录的客户端 such as iPhone android
    
    //从单例获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    }else{
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"xieke.local" resource:@"iPhone"];
    _xmppStream.myJID = myJID;
    
    
    //设置服务器的域名
    _xmppStream.hostName = @"xieke.local";//不仅可以是域名,还可以是IP地址
    
    //设置端口 如果服务器的端口是5222,可以省略
    //_xmppStream.hostPort = 5222;//默认端口
    
    
    //连接
    NSError *err = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]) {
        WCLog(@"%@",err);
    }
}

#pragma mark-- 连接到服务器后,再发送密码授权
-(void)sendPwdToHost{
    WCLog(@"发送密码授权");
    NSError *err = nil;
    //获取沙盒中的密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        WCLog(@"%@",err);
    }
}

#pragma mark-- 授权成功后,发送在线消息
-(void)sendOnlineToHost{
    WCLog(@"发送在线消息");
    XMPPPresence *presence = [XMPPPresence presence];
    WCLog(@"%@",presence);
    [_xmppStream sendElement:presence];
}


#pragma mark --XMPPStream的代理
#pragma mark --与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    WCLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作,发送注册的密码
        [_xmppStream registerWithPassword:[WCUserInfo sharedWCUserInfo].registerPwd error:nil];
    }else{
        
        //主机连接成功后发送密码进行授权
        [self sendPwdToHost];
    }
    
}

#pragma mark --与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误, 就表示连接失败
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [MBProgressHUD hideHUD];
    //    });
    
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetError);
    }
    WCLog(@"与主机断开连接 %@",error);
}

#pragma mark --授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WCLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}

#pragma mark --授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WCLog(@"授权失败");
    
    //判断block有无值,再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    
}
#pragma mark--注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark--注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WCLog(@"注册失败");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark--公共方法

#pragma mark--用户注销
-(void)xmppUserlogout{
    //1.发送离线消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    //2.与服务器断开连接
    [_xmppStream disconnect];
    
    //3.回到登陆界面
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    
//    self.window.rootViewController = storyBoard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //更新用户的登录状态
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
}

#pragma mark--用户登录
- (void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务,要断开
    [_xmppStream disconnect];
    
    //连接到主机,成功后发送登录密码
    [self connectToHost];
}

#pragma mark--用户注册
- (void)xmppUserRegist:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务,要断开
    [_xmppStream disconnect];
    
    //连接到主机,成功后发送注册密码
    [self connectToHost];
}

-(void)dealloc{
    [self teardownXmpp];
}

@end
