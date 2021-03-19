//
//  WCUserInfo.h
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCUserInfo : NSObject
@property (nonatomic, copy) NSString * user;//用户名
@property (nonatomic, copy) NSString * pwd;//密码
@property (nonatomic, assign) BOOL loginStatus;//登录状态,是否登录

@property (nonatomic,copy)NSString *registerUser;//注册的用户名
@property (nonatomic,copy)NSString *registerPwd;//注册的密码
@property (nonatomic, copy) NSString * jid;


//单例
singleton_interface(WCUserInfo);


#pragma mark - method
/**
 *  从沙盒里获取用户数据
 */
-(void)loadUserInfoFromSanbox;

/**
 *  保存用户数据到沙盒
 
 */
-(void)saveUserInfoToSanbox;


@end

NS_ASSUME_NONNULL_END
