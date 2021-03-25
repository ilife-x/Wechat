//
//  WCXMPPTool.m
//  Wechat
//
//  Created by xiao on 2021/3/9.
//

#import "WCXMPPTool.h"
#import "HomeViewController.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"
#import "UIStoryboard+WF.h"

@interface WCXMPPTool()<XMPPStreamDelegate>{
    XMPPResultBlock _resultBlock;
    XMPPvCardCoreDataStorage *_vCardStorage;
    XMPPvCardTempModule *_vCard;
    XMPPvCardAvatarModule *_vCardAvatar;


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

@implementation WCXMPPTool
singleton_implementation(WCXMPPTool);

#pragma mark - 登录流程

//1.
- (void)setupXMPPStream{
    //初始化
    _xmppStream = [[XMPPStream alloc]init];
    
    //添加电子名片模块(头像和个人信息)
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];//激活
    
    //头像模块
    _vCardAvatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];
    
    //添加自动连接模块,接入后有自动重连的功能
    _reconnect = [[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    
    //花名册
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //消息模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _msgArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];


    //添加代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)teardownStream
{
    [_xmppStream removeDelegate:self];
    
    [_reconnect deactivate];
    [_vCard deactivate];
    [_vCardAvatar deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    [_xmppStream disconnect];
    
    
    _xmppStream = nil;
    _reconnect = nil;
    _vCardStorage = nil;
    _vCard = nil;
    _vCardAvatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
}



//2.
- (void)connectToHost{
    //初始化
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //获取用户名
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = WCUserInfo.sharedWCUserInfo.registerUser;
    }else{
        user = WCUserInfo.sharedWCUserInfo.user;
    }
    
    //设置用户JID
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"bogon" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    
    //域名,也可以是ip地址
//    _xmppStream.hostName = @"10.20.34.13";
    _xmppStream.hostName = @"192.168.1.4";

    
    //默认端口就是5222,可以省略
    _xmppStream.hostPort = 5222;
    
    //连接
    NSError *error = nil;;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        WCLog(@"%@",error);
        
    };
}

//3.
- (void)sendPwdToHost{
    NSError *error = nil;
    NSString *pwd = WCUserInfo.sharedWCUserInfo.pwd;
    [_xmppStream authenticateWithPassword:pwd error:&error];
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
    
    if (self.isRegisterOperation) {
        //如果是注册，发送注册密码
        NSString *pwd = WCUserInfo.sharedWCUserInfo.registerPwd;
        NSError *err = nil;
        [_xmppStream registerWithPassword:pwd error:&err];
        
    }else{
        //主机链接成功后发送密码授权
        [self sendPwdToHost];
    }
    

}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误,就代表链接失败
    NSLog(@"与主机断开链接 %@",error);
    if (error && _resultBlock) {
        _resultBlock(XMPPResultTypeNetErr);
    }

}

#pragma mark - 授权成功 & 失败
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


#pragma mark - 注册成功 & 失败
- (void)xmppStreamDidRegister:(XMPPStream *)sender{

    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{

    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
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
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4.更改用户状态
    WCUserInfo.sharedWCUserInfo.loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanbox];
}

#pragma mark - 注册
- (void)XMPPUserRegister:(XMPPResultBlock)resultBlock{
    //存储block,其他地方回调
    _resultBlock = resultBlock;
    //如果以前链接过,退出链接
    [_xmppStream disconnect];
    //链接到服务器
    [self connectToHost];
}

- (void)dealloc{
    [self teardownStream];
}
@end
