//
//  tableViewCell.m
//  dynamicList
//
//  Created by 杜强海 on 9/28/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "tableViewCell.h"


@implementation tableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInforWithFriendGroup:(FriendGroup *)object
{
    if(object.isOpen)
    {
        self.imageView.image = [UIImage imageNamed:@"down"];
    }else
        self.imageView.image = [UIImage imageNamed:@"up"];
    self.textLabel.text = [NSString stringWithFormat:@"%@",object.groupName];
    
    self.nameLabel.hidden = YES;
    self.signatureLabel.hidden = YES;
    self.icon.hidden = YES;
    
    int onLineCount = 0;
    for (Friend *friend in object.friendsArray)
    {
        if (friend.isOnline) {
            onLineCount ++;
        }
    }
    self.groupOnlineIdentifierLabel.hidden = YES;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.text = [NSString stringWithFormat:@"%d/%.0ld",onLineCount,object.friendsArray.count];
    self.accessoryView = lable;
}

- (void)setInforWithFriend:(Friend*)friend
{
    self.nameLabel.text = friend.nickName;
    self.signatureLabel.text = friend.signature;
    self.groupOnlineIdentifierLabel.hidden = YES;
    
    // judge friend is online or not and set icon
    UIImage *iconImage = [UIImage imageNamed:friend.icon];
    if (friend.isOnline) {
        self.icon.image = [self circleImageWithImage:iconImage borderWidth:0 boraderColor:[UIColor clearColor]];
    }
    else
    {
        iconImage = [self grayImage:iconImage];
        self.icon.image = [self circleImageWithImage:iconImage borderWidth:0 boraderColor:[UIColor clearColor]];
    }
}

-(void)drawRect:(CGRect)rect
{
//    self.imageView.transform = CGAffineTransformMakeScale( .5, .5);
}

// cut a image in circle
- (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth boraderColor:(UIColor *)borderColor
{
    CGFloat imageWidth = sourceImage.size.width +2 *borderWidth;
    CGFloat imageHieght = sourceImage.size.height + 2*borderWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHieght), NO, 0);
    UIGraphicsGetCurrentContext(); //CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = sourceImage.size.width<sourceImage.size.height ? sourceImage.size.width *0.5 :sourceImage.size.height*0.5;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth*0.5, imageHieght*0.5) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [borderColor setStroke];
    [bezierPath stroke];
    [bezierPath addClip];
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// turn to grayImage
-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

@end
