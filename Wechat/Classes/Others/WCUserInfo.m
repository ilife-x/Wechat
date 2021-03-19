//
//  WCUserInfo.m
//  Wechat
//
//  Created by xiao on 2021/3/4.
//

#import "WCUserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"
static NSString *domain = @"bogon";

@implementation WCUserInfo
singleton_implementation(WCUserInfo)

- (void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults valueForKey:UserKey];
    self.pwd  = [defaults valueForKey:PwdKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    
}

- (void)saveUserInfoToSanbox{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults synchronize];
    
    
}

- (NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}
@end
