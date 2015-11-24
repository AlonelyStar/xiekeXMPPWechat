//
//  WCRegisterViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/16.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
- (IBAction)registBtnClick;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    // 判断当前设备的类型 改变左右两边约束的类型
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant = 10;
        self.rightConstraint.constant = 10;
    }
    
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    // Do any additional setup after loading the view.
}

- (IBAction)registBtnClick {
    // 判断用户输入的是否为手机号
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    
    //1.把用户注册的数据保存到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    
    [self.view endEditing:YES];
    
    //2.调用AppDelegate的xmppUserRegist
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    app.RegisterOperation = YES;
    [WCXMPPTool sharedWCXMPPTool].RegisterOperation = YES;
    
    //提示
    [MBProgressHUD showMessage:@"正在注册中" toView:self.view];
    
    __weak typeof(self) selfVc = self;
    [[WCXMPPTool sharedWCXMPPTool] xmppUserRegist:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeNetError:
                [MBProgressHUD showError:@"网络不稳定" toView:self.view];
                break;
                
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                //回到上一次控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)]) {
                    [self.delegate registerViewControllerDidFinishRegister];
                }
                break;
                
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            default:
                break;
        }
        
    });
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)textChange {
    //设置注册按钮的可用状态
    BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
    self.registBtn.enabled = enabled;
    
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
