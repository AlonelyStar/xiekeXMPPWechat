//
//  WCInputView.h
//  Wechat
//
//  Created by 谢科的Mac on 15/11/20.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView

@property (weak, nonatomic) IBOutlet UITextView *textview;

+(instancetype)inputView;

@end
