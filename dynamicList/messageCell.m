//
//  messageCell.m
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "messageCell.h"
@interface messageCell ()
@end
@implementation messageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageByMessage:(Message *)message
{
    self.timeLabel.text = message.time;
    self.messageTextLabel.text = message.messageText;
    self.messageTextLabel.textColor = [UIColor whiteColor];
    self.backgroundImage.image = [UIImage imageNamed:@"chat_send_nor"];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
