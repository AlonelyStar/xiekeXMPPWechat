//
//  WCOtherLoginViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/13.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其它方式登录";
    
    // 判断当前设备的类型 改变左右两边约束的类型
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginButton setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];

}
- (IBAction)loginBtnClick {
    //登录
    /*
     *官方的示例程序
     *1.把用户名和密码放在沙盒
     *2.调用 appdelegate 的 一个connect 连接服务并登陆
     
     
     *
     *
     */
    NSString *user = self.userField.text;
    NSString *pwd = self.pwdField.text;
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = user;
    userInfo.pwd = pwd;
    
    [super login];
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
