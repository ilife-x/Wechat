//
//  AppDelegate.m
//  Wechat
//
//  Created by xiao on 2021/2/25.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "XMPPFramework.h"

@interface AppDelegate()<XMPPStreamDelegate>{
    XMPPStream * _xmppStream;
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
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    HomeViewController *home = [[HomeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self connectToHost];
    return YES;
}

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
    
    //设置用户JID
    XMPPJID *myJID = [XMPPJID jidWithUser:@"wangwu" domain:@"bogon" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    _xmppStream.hostName = @"bogon";//域名,也可以是ip地址
    _xmppStream.hostPort = 5222;//默认端口就是5222,可以省略
    NSError *error = nil;;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@",error);
    };
}

#pragma mark - xmppStream delegate
// 与主机链接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机链接成功");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误,就代表链接失败
    NSLog(@"与主机断开链接 %@",error);

}

@end
