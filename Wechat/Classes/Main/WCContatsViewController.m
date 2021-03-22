//
//  WCContatsViewController.m
//  Wechat
//
//  Created by xiao on 2021/3/19.
//

#import "WCContatsViewController.h"

@interface WCContatsViewController ()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultControl;
}
@property (nonatomic, copy) NSArray *friends;

@end

@implementation WCContatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFriends];

}

- (void)loadFriends{
    //通过coreData获取数据,context关联到数据库的表
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    //查找请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置过滤和排序
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@",jid];
    request.predicate = pre;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //执行请求
    NSError *error = nil;
//    self.friends = [context executeFetchRequest:request error:&error];
//    NSLog(@"friends:%@",self.friends);
    _resultControl = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultControl.delegate = self;
    [_resultControl performFetch:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.friends.count;
    return _resultControl.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCell" forIndexPath:indexPath];
    XMPPUserCoreDataStorageObject *friend = _resultControl.fetchedObjects[indexPath.row];
    
    //好友jid(字符串形式)
    cell.textLabel.text = friend.jidStr;
    
    //好友状态
    switch (friend.sectionNum.intValue) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate
//数据更新会调用
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //刷新
    [self.tableView reloadData];
}



//支持tableView的编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        WCLog(@"删除好友");
        XMPPUserCoreDataStorageObject *obj =_resultControl.fetchedObjects[indexPath.row];
        XMPPJID *friendJid = obj.jid;
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:friendJid];

    }
}





@end
