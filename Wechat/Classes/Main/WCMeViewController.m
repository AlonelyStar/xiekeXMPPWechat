//
//  WCMeViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/14.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface WCMeViewController ()
- (IBAction)logoutBtnClick:(id)sender;
/*
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
/*
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
/*
 微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    
   //显示当前用户的个人信息
    
    //如何使用CoreData获取数据
    //1.上下文 [关联到数据]
    
    //2.FetchRequest
    
    //3.设置过滤和排序
    
    //4.执行请求获取数据
    
    //xmpp提供了一个方法,直接获取个人信息
   XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myvCard.photo) {
        self.headerView.image = [UIImage imageWithData:myvCard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myvCard.nickname;
    
    //设置微信号[用户名]
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];


}
- (IBAction)logoutBtnClick:(id)sender {
    //直接调用AppDelegate里面的注销方法
    
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    
//    [app xmppUserlogout];
    
    [[WCXMPPTool sharedWCXMPPTool] xmppUserlogout];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
     Configure the cell...
 
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
