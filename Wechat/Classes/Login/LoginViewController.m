//
//  LoginViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 默认记住上次登录用户
    NSString *user = WCUserInfo.sharedWCUserInfo.user;
    self.userLabel.text = user;
}



@end
