//
//  HomeViewController.m
//  Wechat
//
//  Created by xiao on 2021/2/25.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"home";
    

}


#pragma 退出流程
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AppDelegate *app =  [[UIApplication sharedApplication]delegate];
    [app logout];
}


@end
