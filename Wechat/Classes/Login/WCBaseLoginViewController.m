//
//  WCBaseLoginViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/16.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)login{
    //登录
    /*
     *官方的示例程序
     *1.把用户名和密码放在沙盒
     *2.调用 appdelegate 的 一个connect 连接服务并登陆
     
     
     *
     *
     */
    
    [self.view endEditing:YES];
    
    //调用AppDelegate方法
    
    //登录之前给个提示
    [MBProgressHUD showMessage:@"正在登录中" toView:self.view];
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak typeof (self) selfVc = self;
    [WCXMPPTool sharedWCXMPPTool].RegisterOperation = NO;
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}

- (void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登陆成功");
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登陆失败");
                [MBProgressHUD showError:@"用户名或者密码错误" toView:self.view];
                [self performSelector:@selector(disappearAction) withObject:nil afterDelay:0.8];
                break;
            case XMPPResultTypeNetError:
                NSLog(@"网络不给力");
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                [self performSelector:@selector(disappearAction) withObject:nil afterDelay:0.8];
                break;
            default:
                break;
        }
        
    });
}

- (void)disappearAction{
    [MBProgressHUD hideHUDForView:self.view];
    
}

- (void)enterMainPage{
    //更改用户的登录状态为YES
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    //把用户登录成功的数据保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //登录成功,来到主界面
    //此方法是在子线程被调用的,所以要在主线程刷新UI
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = storyBoard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Main"];
}



//-------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
