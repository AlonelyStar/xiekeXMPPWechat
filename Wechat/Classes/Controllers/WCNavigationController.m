//
//  WCNavigationController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/14.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

+(void)initialize{
    [self setupNavTheme];
    
    
}

//设置导航栏的主题
+ (void)setupNavTheme{
    //设置导航栏样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //1.设置导航条的背景
    [navBar setBackgroundImage:[UIImage stretchedImageWithName:@"topbarbg_ios7"] forBarMetrics:(UIBarMetricsDefault)];
    
    //2.设置导航栏的字体
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
    //3.设置状态栏的样式
    //XCode5以上,默认的话,这个状态栏的样式由控制器决定的
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

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
