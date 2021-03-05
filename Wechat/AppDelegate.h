//
//  AppDelegate.h
//  Wechat
//
//  Created by xiao on 2021/2/25.
//

#import <UIKit/UIKit.h>

typedef enum{
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
}XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType resultType);//登录结果回调
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;

- (void)XMPPUserLogin:(XMPPResultBlock)resultBlock;
- (void)XMPPUserLogout;
@end

