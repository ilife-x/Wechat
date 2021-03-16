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
#import "DDLog.h"
#import "DDTTYLogger.h"

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
    
    //沙盒路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    WCLog(@"沙盒路径:%@",path);
    
    //打开xmpp的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];


    return YES;
}


@end
