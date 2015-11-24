//
//  WCAddContactViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/20.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCAddContactViewController.h"

@interface WCAddContactViewController ()<UITextFieldDelegate>

@end

@implementation WCAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //添加好友
    
    //1.获取好友的账号
    NSString *user = textField.text;
    WCLog(@"%@",user);
    
    //判断这个账号是否为手机号码
    if (![textField isTelphoneNum]) {
        [self showAlert:@"请输入正确的手机号码"];
        return YES;
    }
    
    //判断是否添加自己
    if ([user isEqualToString:[WCUserInfo sharedWCUserInfo].user]) {
        [self showAlert:@"不能添加自己为好友"];
        return YES;
    }
    
    
    
    
    
    
    
    //2.发送好友添加的请求
    //添加好友,xmpp有一个叫订阅
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domin];
    
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    //判断添加的好友是否已存在
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        [self showAlert:@"好友已存在"];
        return YES;
    }
    
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:friendJid];
    
    
    
    return YES;
}

- (void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
    
    
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
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
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
