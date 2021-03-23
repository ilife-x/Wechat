//
//  WCAddContactViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/22.
//

#import "WCAddContactViewController.h"

@interface WCAddContactViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    WCLog(@"点击了return");
    // 收起键盘
    [self.textField endEditing:YES];
    
    NSString *user = self.textField.text;

    
    //判断手机号格式是否正确
    if (![textField isTelphoneNum]) {
        [self showAlertWithMessage:@"请输入正确的手机号"];
        return YES;
    }
    
    //判断是否是添加自己为好友
    if ([user isEqual:[WCUserInfo sharedWCUserInfo].user]) {
        [self showAlertWithMessage:@"不能添加自己为好友"];
        return YES;
    }
    
    //判断好友是否存在
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:jid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        [self showAlertWithMessage:@"好友已经存在"];
        return YES;
    };
    
    //添加联系人(订阅就是添加)
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:jid];
    [self.navigationController popViewControllerAnimated:YES];

    
    return YES;
}

- (void)showAlertWithMessage:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:self cancelButtonTitle:@"thank you" otherButtonTitles:nil, nil];
    [alert show];
    
//    UIAlertController *alertVc = [[UIAlertController alloc]init];
//    alertVc.message = str;
//    alertVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVc animated:YES completion:nil];
//
}
@end
