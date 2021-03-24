//
//  WCChatViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/23.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextViewDelegate>{
    NSFetchedResultsController *_resultControl;
}
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstrains;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboabdWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self loadMsgData];
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
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WCInputView *inputView = [WCInputView inputView];
    //代码实现自动布局，要设置下面的属性为NO
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.textView.delegate = self;
    [self.view addSubview:inputView];
    
    NSDictionary *views = @{@"tableView":tableView,
                       @"inputView":inputView};
    
    NSArray *tableViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHConstrains];

    NSArray *inputViewHConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstrains];
#warning 此处需添加机型判断底部安全区域高度
    NSArray *tableViewVConstrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-34-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewVConstrains];
    self.inputViewBottomConstrains = tableViewVConstrains.lastObject;

    WCLog(@"v:%@",tableViewVConstrains);
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    WCLog(@"%@",textView.text);
    if ([textView.text rangeOfString:@"\n"].length != 0) {
        //发送聊天数据
        [self sendMsg:textView.text];
        [self scrollToTablebottom];
        //清空输入框
        textView.text = nil;
        
        
    }else{
        WCLog(@"%@",textView.text);
    }
}

#pragma mark - 发送聊天数据
-(void)sendMsg:(NSString *)text{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [message addBody:text];
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:message];
}

#pragma mark - 加载数据
- (void)loadMsgData{
    
    //通过coreData获取数据,context关联到数据库的表
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    //查找请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //设置过滤和排序
    //1.只能获取当前登录用户的聊天数据
    //2.只能获取当前好友的聊天数据
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@ AND bareJidStr=%@",jid,self.friendJid.bare];
    request.predicate = pre;
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //执行请求
    NSError *error = nil;
    _resultControl = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    _resultControl.delegate = self;
    [_resultControl performFetch:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
    [self scrollToTablebottom];
}

#pragma mark - delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultControl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"msgCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    XMPPMessageArchiving_Message_CoreDataObject *msg = _resultControl.fetchedObjects[indexPath.row];
    
    if ([msg.outgoing boolValue]) {
        cell.textLabel.text = [NSString stringWithFormat:@"me:%@",msg.body];

    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"other:%@",msg.body];

    }
    return cell;
}

- (void)scrollToTablebottom{
    if (_resultControl.fetchedObjects.count == 0) {
        return;
    }
    NSInteger row = _resultControl.fetchedObjects.count-1;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
