//
//  WCInputView.m
//  Wechat
//
//  Created by 谢科的Mac on 15/11/20.
//  Copyright © 2015年 谢科. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView


+(instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
