//
//  WCProfileViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/10.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileViewController.h"

@interface WCProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCEditProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgUnitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailNameLabel;
@property (nonatomic, strong) UIActionSheet *sheet;


@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置用户信息
    [self loadVCard];

}

- (void)loadVCard{
    //获取个人信息电子卡
    XMPPvCardTemp *myCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    //设置头像
    if (myCard.photo) {
        self.headerView.image = [UIImage imageWithData:myCard.photo];
    }
    
    //设置昵称
    self.nickNameLabel.text = myCard.nickname;
    
    //设置微信号
    self.weixinNumLabel.text = [WCUserInfo sharedWCUserInfo].user;
    
    //设置公司
    self.orgNameLabel.text = myCard.orgName;
    
    //设置部门
    self.orgUnitNameLabel.text = myCard.orgUnits.lastObject;
    
    //设置职位
    self.titleNameLabel.text = myCard.title;
    
    //设置电话
    self.phoneNameLabel.text = myCard.telecomsAddresses;
    
    //设置邮箱
    self.emailNameLabel.text = myCard.emailAddresses;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    switch (tag) {
        case 0:{
            WCLog(@"修改头像,显示弹窗");
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册",nil];
            [sheet showInView:self.view];
            
        }
            break;
        case 1:{
            WCLog(@"跳转到下一个控制器");
            [self performSegueWithIdentifier:@"EditProfileSegue" sender:cell];

        }
            break;;
        case 2:{
            WCLog(@"不做任何操作");

        }

            break;
            
        default:
            break;
    }
    
}

/**
 'UIActionSheet' is deprecated: first deprecated in iOS 8.3 - UIActionSheet is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleActionSheet instead
 */

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    switch (buttonIndex) {
        case 0:
        {
            WCLog(@"照相");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }

        }
            break;

            
        default:{
            WCLog(@"相册");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];

            }

        }
            break;
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    WCLog(@"%@",info);
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headerView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //更新到服务器
    [self editProfileViewControllerDidSave];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id desVc = segue.destinationViewController;
    if ([desVc isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editVc = desVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

//保存信息到服务器
- (void)editProfileViewControllerDidSave{
    WCLog(@"editProfileViewControllerDidSave");
    //重新赋值
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    myvCard.photo = UIImagePNGRepresentation(self.headerView.image);
    myvCard.nickname = self.nickNameLabel.text;
    myvCard.orgName = self.orgNameLabel.text;
    if (self.orgUnitNameLabel.text.length > 0) {
        myvCard.orgUnits = @[self.orgUnitNameLabel.text];
    }
    myvCard.title = self.titleNameLabel.text;
    myvCard.mailer = self.emailNameLabel.text;
    //上传服务器更新
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];
}

@end
