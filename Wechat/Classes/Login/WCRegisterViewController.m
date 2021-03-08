//
//  WCRegisterViewController.m
//  Wechat
//
//  Created by wang xiao on 2021/3/8.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"
#import "UIImage+WF.h"
#import "UITextField+WF.h"
#import "UIButton+WF.h"

@interface WCRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrains;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.pwdField setBackground:[UIImage stretchedImageWithName:@"operationbox_text"]];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    
    //适配
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstrains.constant = 10;
        self.rightConstrains.constant = 10;
        
    }

}

//注册按钮点击事件
- (IBAction)registerBtnClicked:(id)sender {
    //收起键盘
    [self.view endEditing:YES];
    
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    //保存用户注册信息
    WCUserInfo.sharedWCUserInfo.user = self.userField.text;
    WCUserInfo.sharedWCUserInfo.pwd = self.pwdField.text;
    
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    
    [MBProgressHUD showMessage:@"正在注册。。。" toView:self.view];
    __weak typeof(self) weakSelf = self;
    [delegate XMPPUserRegister:^(XMPPResultType resultType) {
            [weakSelf handleResultType:resultType];
        }];
    
    
    
}


- (void)handleResultType:(XMPPResultType)type {
    //主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                WCLog(@"注册成功");
                
                //回到上个控制器，以便输入密码重新登录
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    //注册完成
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
            case XMPPResultTypeRegisterFailure:
                WCLog(@"注册失败");
                [MBProgressHUD showError:@"账号或密码不正确" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                WCLog(@"网络不稳定");
                [MBProgressHUD showError:@"网络不不稳定" toView:self.view];

                break;
                
            default:
                break;
        }
    });
}

- (IBAction)cacle:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
