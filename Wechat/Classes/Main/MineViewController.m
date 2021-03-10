//
//  MineViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/5.
//

#import "MineViewController.h"
#import "XMPPvCardTemp.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LogoutBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinNameLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取个人电子名片
    XMPPvCardTempModule *myVcardModule = (XMPPvCardTempModule *)[WCXMPPTool sharedWCXMPPTool].vCard;
    XMPPvCardTemp *myVCard = myVcardModule.myvCardTemp;
    //设置头像
    if (myVCard.photo) {
        self.headerView.image = [UIImage imageWithData:myVCard.photo];
    }
    self.nickNameLabel.text = myVCard.nickname;
    self.weixinNameLabel.text = myVCard.givenName;

}
#pragma mark - 注销
- (IBAction)LogoutBtnClick:(id)sender {
    [[WCXMPPTool sharedWCXMPPTool] XMPPUserLogout];
}


@end
