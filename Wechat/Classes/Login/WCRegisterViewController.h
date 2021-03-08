//
//  WCRegisterViewController.h
//  Wechat
//
//  Created by wang xiao on 2021/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//完成注册的协议
@protocol regisgerViewControllerDidFinishRegister <NSObject>

- (void)regisgerViewControllerDidFinishRegister;

@end



@interface WCRegisterViewController : UIViewController

@property (nonatomic,weak)id<regisgerViewControllerDidFinishRegister> delegate;

@end

NS_ASSUME_NONNULL_END
