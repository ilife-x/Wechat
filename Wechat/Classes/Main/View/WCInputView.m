//
//  WCInputView.m
//  Wechat
//
//  Created by xiao on 2021/3/23.
//

#import "WCInputView.h"

@implementation WCInputView


+ (instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:self options:nil] lastObject];
}

@end
