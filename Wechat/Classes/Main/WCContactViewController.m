//
//  WCContactViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/19.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCContactViewController.h"
#import "WCChatViewController.h"

@interface WCContactViewController ()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultsController;
}

@property (nonatomic,strong) NSArray *friends;

@end

@implementation WCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据里加载好友列表显示
    [self loadFriends2];
}
- (void)loadFriends2{
    //使用coreData获取数据
    
    //1.上下文 [关联到数据]
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.FetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤和排序
    //过滤当前登录用户的好友
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    //4.执行请求获取数据
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultsController.delegate  = self;
    
    NSError *err = nil;
    [_resultsController performFetch:&err];
    if (err) {
        WCLog(@"%@",err);
    }
    
    
}

- (void)loadFriends{
    //使用coreData获取数据
    
    //1.上下文 [关联到数据]
   NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.FetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤和排序
    //过滤当前登录用户的好友
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    //4.执行请求获取数据
   self.friends = [context executeFetchRequest:request error:nil];
    
    
}

#pragma mark --当数据库的内容发生改变后,会调用这个方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    WCLog(@"数据发生改变");
    //刷新表格
    [self.tableView reloadData];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (_resultsController.fetchedObjects != nil) {
        return _resultsController.fetchedObjects.count;
        
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ContactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //获取对应好友
    
    if (_resultsController.fetchedObjects != nil) {
        XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
        switch ([friend.sectionNum intValue]) {
            case 0:
                cell.detailTextLabel.text = @"在线";
                break;
                
            case 1:
                cell.detailTextLabel.text = @"离开";
                break;
                
            case 2:
                cell.detailTextLabel.text = @"离线";
                break;
            default:
                break;
        }
        cell.textLabel.text = friend.jidStr;
    }
    
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
   if (editingStyle == UITableViewCellEditingStyleDelete) {
        WCLog(@"删除好友");
        
        XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = friend.jid;
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:friendJid];
    }
}

//选中表格,进入聊天界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取好友
    XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];

    
    [self performSegueWithIdentifier:@"ChatSegue" sender:friend.jid];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[WCChatViewController class]]) {
        WCChatViewController *chatVC = destVC;
        chatVC.friendJid = sender;
    }
    
}

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
