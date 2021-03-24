//
//  WCInputView.h
//  Wechat
//
//  Created by xiao on 2021/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCInputView : UIView
+ (instancetype)inputView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

NS_ASSUME_NONNULL_END
