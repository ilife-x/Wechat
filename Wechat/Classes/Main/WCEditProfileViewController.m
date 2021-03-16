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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cell.textLabel.text;
    self.editTextField.text = self.cell.detailTextLabel.text;

}

- (void)save{
    WCLog(@"save");
    
};



@end
