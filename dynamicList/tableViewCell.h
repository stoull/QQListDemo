//
//  tableViewCell.h
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "FriendGroup.h"

@interface tableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupOnlineIdentifierLabel;

- (void)setInforWithFriendGroup:(FriendGroup *)object;

- (void)setInforWithFriend:(Friend*)friend;

@end
