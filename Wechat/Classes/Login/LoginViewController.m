//
//  LoginViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import "LoginViewController.h"
#import "WCNavigationController.h"
#import "WCRegisterViewController.h"
#import "UIImage+WF.h"
#import "UITextField+WF.h"
#import "UIButton+WF.h"

@interface LoginViewController ()<regisgerViewControllerDidFinishRegister>;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pwdField setBackground:[UIImage stretchedImageWithName:@"operationbox_text"]];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
    
    // 默认记住上次登录用户
    NSString *user = WCUserInfo.sharedWCUserInfo.user;
    self.userLabel.text = user;
}

//点击登录
- (IBAction)loginBtnClick:(id)sender {
    WCUserInfo *userInfo = WCUserInfo.sharedWCUserInfo;
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;

    [super login];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id devc = segue.destinationViewController;
    if ([devc isKindOfClass:[WCNavigationController class]]) {
        WCNavigationController *nav = devc;
        WCRegisterViewController *registerVc = (WCRegisterViewController *)nav.topViewController;
        if ([registerVc isKindOfClass:[WCRegisterViewController class]]) {
            registerVc.delegate = self;
        }

        
    }
}

- (void)regisgerViewControllerDidFinishRegister{
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    [MBProgressHUD showSuccess:@"请重新输入密码登录" toView:self.view];
}



@end
