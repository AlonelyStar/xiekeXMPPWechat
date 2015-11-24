//
//  WCUserInfo.h
//  Wechat
//
//  Created by 谢科的Mac on 15/11/16.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
static NSString *domin = @"xieke.local";
@interface WCUserInfo : NSObject

singleton_interface(WCUserInfo);

@property (nonatomic, copy) NSString *user;//用户名
@property (nonatomic, copy) NSString *pwd;//密码

/**
 *  登录的状态 YES 登录过/NO 注销
 */
@property (nonatomic, assign) BOOL  loginStatus;

@property (nonatomic, copy)NSString *registerUser;//注册的用户名
@property (nonatomic, copy)NSString *registerPwd;//注册的密码
@property (nonatomic, copy)NSString *jid;

/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;
@end
