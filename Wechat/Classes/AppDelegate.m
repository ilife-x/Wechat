//
//  AppDelegate.m
//  Wechat
//
//  Created by xiao on 2021/2/25.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"

@interface AppDelegate()


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [WCNavigationController setupNavTheme];
    
    //重新启动时获取用户信息
    [[WCUserInfo sharedWCUserInfo] loadUserInfoFromSanbox];
    
    //  判断用户状态,如果是yes,就直接来到主页面
    if ([WCUserInfo sharedWCUserInfo].loginStatus == YES) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        self.window.rootViewController = storyBoard.instantiateInitialViewController;
        [[WCXMPPTool sharedWCXMPPTool] XMPPUserLogin:nil];
    }

    return YES;
}


@end
