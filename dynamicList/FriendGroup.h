//
//  FriendGroup.h
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendGroup : NSObject

@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSMutableArray *friendsArray;
@property (nonatomic,assign) BOOL isOpen;

+ (FriendGroup *)getGroupByDic:(NSDictionary *)dic;
- (FriendGroup *)initWithDic:(NSDictionary *)dic;

@end
