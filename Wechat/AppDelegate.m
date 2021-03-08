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

@interface AppDelegate()<XMPPStreamDelegate>{
    XMPPStream * _xmppStream;
    XMPPResultBlock _resultBlock;
}

/**
 私有方法
 */
//1.初始化xmppStream
- (void)setupXMPPStream;
//2. 链接到服务器
- (void)connectToHost;
//3.链接服务器成功后,再发送密码授权
- (void)sendPwdToHost;
//4.授权成功后,发送"在线"消息
- (void)sendOnlineToHost;
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
        [self XMPPUserLogin:nil];
    }

    return YES;
}

#pragma mark - 登录流程

//1.
- (void)setupXMPPStream{
    //初始化
    _xmppStream = [[XMPPStream alloc]init];

    //添加代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}



//2.
- (void)connectToHost{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    
    //设置用户JID
    XMPPJID *myJID = [XMPPJID jidWithUser:userInfo.user domain:@"bogon" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    
    //域名,也可以是ip地址
    _xmppStream.hostName = @"bogon";
    
    //默认端口就是5222,可以省略
    _xmppStream.hostPort = 5222;
    NSError *error = nil;;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        WCLog(@"%@",error);
        
    };
}

//3.
- (void)sendPwdToHost{
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
}

//4.
- (void)sendOnlineToHost{
    //将在线的消息包裹成xml标签发送到服务器
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    NSLog(@"%@",presence);
}


#pragma mark - 链接到服务器
// 与主机链接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机链接成功");
    //主机链接成功后发送密码授权
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误,就代表链接失败
    NSLog(@"与主机断开链接 %@",error);
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetErr);
    }

}

#pragma mark - 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    [self sendOnlineToHost];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 :%@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);

    }
}

- (void)XMPPUserLogin:(XMPPResultBlock)resultBlock{
    //存储block,其他地方回调
    _resultBlock = resultBlock;
    //如果以前链接过,退出链接
    [_xmppStream disconnect];
    //链接到服务器
    [self connectToHost];
}


#pragma 退出,注销
- (void)XMPPUserLogout{
    
    //1.发送离线消息,unavailable 代表离线
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    //2.断开链接
    [_xmppStream disconnect];

    //3.切换到登录页面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:NSBundle.mainBundle];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
    
    //4.更改用户状态
    WCUserInfo.sharedWCUserInfo.loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
}

@end
