//
//  WCXMPPTool.h
//  Wechat
//
//  Created by xiao on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

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

//注册标识
@property (nonatomic, assign,getter=isRegisterOperation) BOOL registerOperation;


#pragma mark - methods
//登录
- (void)XMPPUserLogin:(XMPPResultBlock)resultBlock;
//注销
- (void)XMPPUserLogout;
//注册
-(void)XMPPUserRegister:(XMPPResultBlock)resultBlock;
@end

NS_ASSUME_NONNULL_END