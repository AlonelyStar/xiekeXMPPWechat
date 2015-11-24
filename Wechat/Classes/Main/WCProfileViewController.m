//
//  WCProfileViewController.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/17.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileViewController.h"

@interface WCProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCEditProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号

@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件

@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self loadVCard];

    
}

//加载电子名片信息
- (void)loadVCard{
    
    
    //xmpp提供了一个方法,直接获取个人信息
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myvCard.photo) {
        self.headView.image = [UIImage imageWithData:myvCard.photo];
    }
    //设置昵称
    self.nicknameLabel.text = myvCard.nickname;
    
    //设置微信号[用户名]
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];
    
    //公司
    self.orgnameLabel.text = myvCard.orgName;
    
    //部门
    if (myvCard.orgUnits.count > 0) {
        self.orgunitLabel.text = myvCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text = myvCard.title;
    
    //电话
#warning myVCard.telecomsAddresses 这个get方法,没有对电子名片的xml进行解析.
    //使用note字段充当解析
    self.phoneLabel.text = myvCard.note;
    
    //邮箱
    self.emailLabel.text = myvCard.mailer;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    //判断
    if (tag == 2) {//不做任何操作
        WCLog(@"不做任何操作");
        return;
    }
    if (tag == 0) {
        //选择照片
        WCLog(@"选择照片");
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }else{
        //跳到下一个控制器
        WCLog(@"跳到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人的信息的控制器
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editVC = destVC;
        editVC.cell = sender;
        editVC.delegate = self;
    }
}

#pragma mark-- actionsheet 的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    //设置代理
    imagePicker.delegate = self;
    
    //设置允许编辑
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        //照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        //相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    //显示
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark--图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    WCLog(@"%@",info);
    //获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headView.image = image;
    
    //隐藏当前的模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //更新到服务器
    [self EditProfileViewControllerDidSave];
}

#pragma mark--编辑个人信息控制器代理
-(void)EditProfileViewControllerDidSave{
    //保存
    
    
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //图片
    myVCard.photo = UIImagePNGRepresentation(self.headView.image);

    
    //昵称
    myVCard.nickname = self.nicknameLabel.text;
    
    //公司
    myVCard.orgName = self.orgnameLabel.text;

    //部门
    if (self.orgunitLabel.text.length > 0) {
        myVCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    //职位
    myVCard.title = self.titleLabel.text;
    
    
    //电话
    myVCard.note = self.phoneLabel.text;
    
    //邮件
    myVCard.mailer = self.emailLabel.text;
    
    //更新 这个方法内部会实现数据上传到服务,无需程序自己操作
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myVCard];

    
    
    
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
