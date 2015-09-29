//
//  ViewController.m
//  dynamicList
//
//  Created by 杜强海 on 9/25/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "ViewController.h"
#import "Friend.h"
#import "FriendGroup.h"
#import "tableViewCell.h"
#import "ChatViewContorller.h"

static NSString *cellIdentifer = @"cell";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray *groupsArray;



@end

@implementation ViewController
-(NSMutableArray *)groupsArray
{
    if (!_groupsArray) {
        _groupsArray = [NSMutableArray array];
    }
    return _groupsArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.groupsArray.count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"];
        NSArray *friendsInforDicArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *dic in friendsInforDicArray)
        {
            FriendGroup *group = [FriendGroup getGroupByDic:dic];
            [self.groupsArray addObject:group];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友列表";
    
    self.listTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.view addSubview:self.listTableView];
    
//    [self.listTableView registerClass:[tableViewCell class] forCellReuseIdentifier:cellIdentifer];
    

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%ld",self.groupsArray.count);
    return self.groupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableViewCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"tableViewCell" owner:nil options:nil]firstObject];
        
    }
    
    id object = [self.groupsArray objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[FriendGroup class]]) {
        [cell setInforWithFriendGroup:(FriendGroup *)object];
    }else
    {
        [cell setInforWithFriend:(Friend*)object];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.groupsArray objectAtIndex:indexPath.row];

    if ([object isKindOfClass:[FriendGroup class]]) {
        return 35;
    }
    else
    {
        return 55;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.groupsArray objectAtIndex:indexPath.row];
    
    tableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[FriendGroup class]]) {
        FriendGroup *friendGroup = (FriendGroup *)object;
        friendGroup.isOpen = !friendGroup.isOpen;
        
        if (friendGroup.isOpen) {
            cell.imageView.image = [UIImage imageNamed:@"down"];
            NSInteger local = indexPath.row;
            NSInteger lenth = friendGroup.friendsArray.count;
            NSRange range = {local+1,lenth};
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            // online friends in front of the downline friend
            NSMutableArray *onLineFriends = [NSMutableArray array];
            NSMutableArray *downLineFriends = [NSMutableArray array];
            for (Friend *fir in friendGroup.friendsArray)
            {
                if (fir.isOnline) {
                    [onLineFriends addObject:fir];
                }else{
                    [downLineFriends addObject:fir];
                }
            }
            [onLineFriends addObjectsFromArray:downLineFriends];

            [self.groupsArray insertObjects:onLineFriends atIndexes:indexSet];
            NSMutableArray *insertPaths = [NSMutableArray array];
            NSInteger insertItemIndex = [self.groupsArray indexOfObject:object];
            for (int i= 0;i<lenth;i++)
            {
                NSIndexPath *indexPth = [NSIndexPath indexPathForRow:++insertItemIndex inSection:0];
                [insertPaths addObject:indexPth];
            }
            [self.listTableView insertRowsAtIndexPaths:insertPaths withRowAnimation:UITableViewRowAnimationTop];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"up"];
            NSInteger local = indexPath.row;
            NSInteger lenth = friendGroup.friendsArray.count;
            NSRange range = {local+1,lenth};
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.groupsArray removeObjectsAtIndexes:indexSet];
            NSMutableArray *insertPaths = [NSMutableArray array];
            NSInteger deleteItemIndex = [self.groupsArray indexOfObject:object];
            for (int i= 0;i<lenth;i++)
            {
                NSIndexPath *indexPth = [NSIndexPath indexPathForRow:++deleteItemIndex inSection:0];
                [insertPaths addObject:indexPth];
            }
            [self.listTableView deleteRowsAtIndexPaths:insertPaths withRowAnimation:UITableViewRowAnimationTop];
        }
    }else
    {
        ChatViewContorller *charView = [[ChatViewContorller alloc] init];
        charView.chatFriend = (Friend *)object;
        charView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:charView animated:YES];
    }
}



@end
