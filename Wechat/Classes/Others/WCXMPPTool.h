//
//  WCXMPPTool.h
//  Wechat
//
//  Created by xiao on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum{
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

typedef void(^XMPPResultBlock)(XMPPResultType resultType);//登录结果回调




@interface WCXMPPTool : NSObject
singleton_interface(WCXMPPTool)
@property (nonatomic, strong) XMPPStream * xmppStream;
//注册标识
@property (nonatomic, assign,getter=isRegisterOperation) BOOL registerOperation;
//电子名片
@property (nonatomic, strong) XMPPvCardTempModule *vCard;
//花名册
@property (nonatomic, strong) XMPPReconnect *reconnect;
@property (nonatomic, strong) XMPPRoster *roster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;


#pragma mark - methods
//登录
- (void)XMPPUserLogin:(XMPPResultBlock)resultBlock;
//注销
- (void)XMPPUserLogout;
//注册
-(void)XMPPUserRegister:(XMPPResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END
