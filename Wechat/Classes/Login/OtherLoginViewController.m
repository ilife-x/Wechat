//
//  OtherLoginViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import "OtherLoginViewController.h"
#import "AppDelegate.h"
@interface OtherLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrains;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation OtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstrains.constant = 10;
        self.rightConstrains.constant = 10;
        
    }
    
}
- (IBAction)loginBtnClick:(id)sender {
    //官方示例:本地存储用户名和密码,存储到UserInfo单例中
    //调用APPdelegate的login登录方法
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    
    //取消键盘
    [self.view endEditing:YES];
    //登录提示
    [MBProgressHUD showMessage:@"正在登录..." toView:self.view];
    //调用Appdelegate的登录方法
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del XMPPUserLogin:^(XMPPResultType resultType) {
        [self handleResultType:resultType];
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

- (IBAction)cancle:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
