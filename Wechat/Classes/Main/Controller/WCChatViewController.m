//
//  WCChatViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/23.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstrains;
@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboabdWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboabdWillShow:(NSNotification *)noti{
    WCLog(@"keyboabdWillShow-notification:%@",noti);
    NSDictionary *userInfo = noti.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 如果是ios7以下的，当屏幕是横屏，键盘的高底是size.with
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0
       && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        self.inputViewBottomConstrains.constant = frame.size.height;
        
    }else{
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:duration animations:^{
            weakSelf.inputViewBottomConstrains.constant = frame.size.height;
        }];
    }
    


}

- (void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.inputViewBottomConstrains.constant = 0;
    }];

}
#pragma mark - UI
- (void)setupView{
    //tableView
    UITableView *tableView = [[UITableView alloc]init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    
    WCInputView *inputView = [WCInputView inputView];
    //代码实现自动布局，要设置下面的属性为NO
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:inputView];
    
    NSDictionary *views = @{@"tableView":tableView,
                       @"inputView":inputView};
    
    NSArray *tableViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHConstrains];

    NSArray *inputViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstrains];
    
    NSArray *tableViewVConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewVConstrains];
    self.inputViewBottomConstrains = tableViewVConstrains.lastObject;

    WCLog(@"v:%@",tableViewVConstrains);
}

@end
