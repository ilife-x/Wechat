//
//  WCEditProfileViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/10.
//

#import "WCEditProfileViewController.h"

@interface WCEditProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *editTextField;

@end

@implementation WCEditProfileViewController
- (IBAction)clickTextField:(id)sender {
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //保存按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.title = self.cell.textLabel.text;
    self.editTextField.text = self.cell.detailTextLabel.text;

}

- (void)save{
    WCLog(@"save");
    self.cell.detailTextLabel.text = self.editTextField.text;
    [self.cell layoutSubviews];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //回调
    if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSave)]) {
        [self.delegate editProfileViewControllerDidSave];
    }
};



@end
