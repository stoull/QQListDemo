//
//  Friend.m
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+ (Friend *)getFriendFromDic:(NSDictionary *)dic
{
    return [[Friend alloc] initWithDic:dic];
}

- (Friend *)initWithDic:(NSDictionary *)dic
{
    self.nickName = dic[@"name"];
    self.icon = dic[@"icon"];
    self.signature = dic[@"intro"];
    self.isOnline = [dic[@"isOnline"] intValue];
    self.isVIP = [dic[@"vip"] intValue];
    return self;
}
@end
