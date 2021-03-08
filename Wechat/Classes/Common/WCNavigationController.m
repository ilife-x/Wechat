//
//  WCNavigationController.m
//  Wechat
//
//  Created by xiao on 2021/3/8.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//设置导航栏主题
+(void)setupNavTheme{
    UINavigationBar *appearance = [UINavigationBar appearance];
    //背景
    [appearance setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    //字体
    [appearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:UIColor.whiteColor}];
    
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
