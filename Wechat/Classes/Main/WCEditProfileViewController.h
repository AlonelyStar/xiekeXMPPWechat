//
//  WCEditProfileViewController.h
//  Wechat
//
//  Created by 谢科的Mac on 15/11/18.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate <NSObject>

- (void)EditProfileViewControllerDidSave;

@end

@interface WCEditProfileViewController : UITableViewController

@property (nonatomic,strong)UITableViewCell *cell;

@property (nonatomic,strong)id<WCEditProfileViewControllerDelegate> delegate;

@end
