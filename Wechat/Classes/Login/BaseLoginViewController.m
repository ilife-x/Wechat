//
//  BaseLoginViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/8.
//

#import "BaseLoginViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface BaseLoginViewController ()

@end

@implementation BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)login{
    //取消键盘
    [self.view endEditing:YES];
    //登录提示
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    //调用Appdelegate的登录方法
    [WCXMPPTool sharedWCXMPPTool].registerOperation = NO;
    __weak typeof (self) weakSelf = self;
    [[WCXMPPTool sharedWCXMPPTool] XMPPUserLogin:^(XMPPResultType resultType) {
        [weakSelf handleResultType:resultType];
    }];
}

- (void)handleResultType:(XMPPResultType)type {
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                WCLog(@"登录成功");
                [self enterHomePage];

                break;
            case XMPPResultTypeLoginFailure:
                WCLog(@"登录失败");
                [MBProgressHUD showError:@"账号或密码不正确" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                WCLog(@"网络不给力");
                [MBProgressHUD showError:@"网络不给力" toView:self.view];

                break;
                
            default:
                break;
        }
    });
    
}

//登录成功,进入主页
- (void)enterHomePage{
    //更改用户登录状态
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    //保存用户信息
    [[WCUserInfo sharedWCUserInfo]saveUserInfoToSanbox];
    
    //退出弹窗
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    //切换主页
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
    
}

@end
