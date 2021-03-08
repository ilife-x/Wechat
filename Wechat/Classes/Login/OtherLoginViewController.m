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
    
    [super login];
 
}





//取消
- (IBAction)cancle:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
