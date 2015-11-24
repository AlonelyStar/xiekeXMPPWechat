//
//  WCRegisterViewController.h
//  Wechat
//
//  Created by 谢科的Mac on 15/11/16.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCRegisterViewControllerDelegate <NSObject>

- (void)registerViewControllerDidFinishRegister;

@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic,weak) id<WCRegisterViewControllerDelegate> delegate;

@end
