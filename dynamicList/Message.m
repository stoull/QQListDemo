//
//  Message.m
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "Message.h"

@implementation Message

- (Message *)initWithDic:(NSDictionary *)dic
{
    self.messageText = dic[@"text"];
    self.time = dic[@"time"];
    self.property = [dic[@"type"] longLongValue];
    return self;
}
+ (Message *)getMessageByDic:(NSDictionary *)dic{
    return [[Message alloc] initWithDic:dic];
}

@end
