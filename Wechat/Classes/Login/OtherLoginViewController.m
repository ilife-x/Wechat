//
//  OtherLoginViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import "OtherLoginViewController.h"

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
    
}

- (IBAction)cancle:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
