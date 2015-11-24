//
//  WCChatViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/20.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate>{
    NSFetchedResultsController *_resultController;
}

@property (nonatomic,strong)NSLayoutConstraint *inputViewBottomConstraint;//inputView底部的约束

@property (nonatomic,strong)NSLayoutConstraint *inputViewHeightConstraint;//inputView高度的约束

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.friendJid.bare;
    
    [self setupView];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //加载数据
    [self loadMsgs];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)keyboardWillShow:(NSNotification *)noti{
    
    //获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight = kbEndFrm.size.height;
    
    
    //如果是iOS7以下的,屏幕是横屏的时候,键盘的高度是size.with
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kbHeight = kbEndFrm.size.width;
    }
    self.inputViewBottomConstraint.constant = kbHeight;
    
    //表格滚动到底部
    [self scrollToTableBottom];
    
}

- (void)keyboardWillHide:(NSNotification *)noti{
    //隐藏键盘 距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
    
    
}

- (void)keyboardDidShow:(NSNotification *)noti{
    [self scrollToTableBottom];
}

//- (void)kbFrmWillChange:(NSNotification *)noti{
//    
//    NSLog(@"%@",noti.userInfo);
//    
//    //获取窗口的高度
//    
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    
//    //键盘结束的Frm
//    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    //获取键盘结束的y值
//    CGFloat kbEndY = kbEndFrm.origin.y;
//    
//    self.inputViewBottomConstraint.constant = windowH - kbEndY;
//}

-(void)setupView{
   //代码方式实现自动布局 VFL
    //创建一个TableView
    self.tableView = [[UITableView alloc]init];
    //tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
#warning 代码实现自动布局,需要设置下面的属性为NO
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.tableView];
    //创建输入框View
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    //设置textView 的代理
    inputView.textview.delegate = self;
    [self.view addSubview:inputView];
    
    //自动布局
    
    //水平方向上的约束
    NSDictionary *views = @{@"tableView":self.tableView,
                            @"inputView":inputView};
    
    //1.tableView水平方向上的约束
    NSArray *tableViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHConstraints];
    
    //2.inputView水平方向上的约束
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstraints];
    
    //处置方向上的约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    //添加inpytView的高度约束
    self.inputViewHeightConstraint = vContraints[2];
    self.inputViewBottomConstraint = [vContraints lastObject];
    [self.view addConstraints:vContraints];
    
}

#pragma mark--加载XMPPMessageArchiving数据库的数据显示在表格
- (void)loadMsgs{
    
    //上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //过滤,排序
    //1.当前登录用户的JID的消息
    //2.好友的Jid消息
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid,self.friendJid.bare];
    
    request.predicate = predicate;
    //时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    //查询
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    
    NSError *err = nil;
    [_resultController performFetch:&err];
    if (err) {
        WCLog(@"%@",err);
    }
    
    [self scrollToTableBottom];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultController.fetchedObjects[indexPath.row];
    
    //显示消息
    if ([msg.outgoing boolValue]) {
        //自己发
        cell.detailTextLabel.text = [NSString stringWithFormat:@"我: %@",msg.body];
        cell.textLabel.text = nil;
    }else{
        //别人发
        cell.textLabel.text = [NSString stringWithFormat:@"Other: %@",msg.body];
        cell.detailTextLabel.text = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
#pragma mark--ResultController的代理
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    WCLog(@"数据发生改变");
    //刷新表格
    [self.tableView reloadData];
    [self scrollToTableBottom];
    
}


#pragma mark--textViewl的代理
-(void)textViewDidChange:(UITextView *)textView{
    //获取ContentSize
    CGFloat contentHeight = textView.contentSize.height;
    
    //大于33 超过一行的高度  小于 68 高度是在三行内
    if (contentHeight > 33 && contentHeight < 68) {
        self.inputViewHeightConstraint.constant = contentHeight + 18;
    }
    
    
    
    //换行就等于点击了send
    NSString *text = textView.text;
    if ([text rangeOfString:@"\n"].length != 0) {
        
        //去除换行字符
        text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //发送数据
        [self sendMsgWithText:text];
        //清空数据
        textView.text = nil;
        
        //发送完消息把inputView的高度改回来
        self.inputViewHeightConstraint.constant = 50;
    }else{
        
    }
}

#pragma mark--发送聊天消息
- (void)sendMsgWithText:(NSString *)text{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    //设置内容
    [msg addBody:text];
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];

}

#pragma mark--滚动到底部
- (void)scrollToTableBottom{
    if (_resultController.fetchedObjects.count != 0) {
        NSInteger lastRow = _resultController.fetchedObjects.count - 1;
        
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
