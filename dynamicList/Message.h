//
//  Message.h
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic,copy) NSString *messageText;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) NSInteger property;

- (Message *)initWithDic:(NSDictionary *)dic;
+ (Message *)getMessageByDic:(NSDictionary *)dic;

@end
