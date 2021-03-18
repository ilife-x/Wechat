//
//  WCEditProfileViewController.h
//  Wechat
//
//  Created by xiao on 2021/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCEditProfileViewControllerDelegate <NSObject>

- (void)editProfileViewControllerDidSave;

@end

@interface WCEditProfileViewController : UITableViewController
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic,weak)id <WCEditProfileViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
