//
//  WCLoginViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/16.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"

@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置TextField和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    //设置登录名为上次登录名
    
    //从沙盒获取用户名
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.userLabel.text = user;
    
}
- (IBAction)loginBtnClick:(id)sender {
    //保存数据到单例
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    //调用父类的抽取
    [super login];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取注册控制器
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *naV = destVC;
        //获取根控制器
        if ([naV.topViewController isKindOfClass:[WCRegisterViewController class]]) {
            WCRegisterViewController *registerVC = (WCRegisterViewController *)naV.topViewController;
            //设置注册控制器代理
            registerVC.delegate = self;
        };
    }
}

#pragma mark--registerViewController的代理
-(void)registerViewControllerDidFinishRegister{
    //完成注册  userLabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    
    //提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
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
