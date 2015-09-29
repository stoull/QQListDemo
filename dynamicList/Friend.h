//
//  Friend.h
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger QAge;
@property (nonatomic,assign) BOOL *isVIP;
@property (nonatomic,assign) BOOL *isOnline;

+ (Friend *)getFriendFromDic:(NSDictionary *)dic;
- (Friend *)initWithDic:(NSDictionary *)dic;

@end
