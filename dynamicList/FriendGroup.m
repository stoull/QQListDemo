//
//  FriendGroup.m
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "FriendGroup.h"
#import "Friend.h"

@implementation FriendGroup

-(NSMutableArray *)friendsArray
{
    if (!_friendsArray) {
        _friendsArray = [NSMutableArray array];
    }
    return _friendsArray;
}
+ (FriendGroup *)getGroupByDic:(NSDictionary *)dic
{
    return [[FriendGroup alloc] initWithDic:dic];
    
}
- (FriendGroup *)initWithDic:(NSDictionary *)dic
{
    NSArray *total = dic[@"friends"];
    
    for (NSDictionary *dic in total)
    {
        Friend *friend = [[Friend alloc] initWithDic:dic];
        [self.friendsArray addObject:friend];
    }
//    self.friendsArray = dic [@"friends"];
    self.groupName = dic[@"name"];
    self.isOpen = NO;
    return self;
}

@end
