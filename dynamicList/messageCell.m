//
//  messageCell.m
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "messageCell.h"
@interface messageCell ()
@property (nonatomic,strong) Message *message;
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
    self.message = message;
    self.timeLabel.text = message.time;
    self.messageTextLabel.text = message.messageText;
    
    [self drawRect:self.frame];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.message.property) {
        self.messageTextLabel.textAlignment = NSTextAlignmentRight;
        self.backgroundImage.image = [UIImage imageNamed:@"chat_send_nor"];
    }else{
        self.messageTextLabel.textAlignment = NSTextAlignmentLeft;
        self.backgroundImage.image = [UIImage imageNamed:@"chat_recive_press_pic"];
        self.icon.frame = CGRectMake(10, 14, 44, 44);
    }
}

@end
