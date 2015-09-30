//
//  ChatViewContorller.m
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "ChatViewContorller.h"
#import "messageCell.h"
#import "receiveMessageCell.h"
#import "Message.h"

#define kToolBarH 44
#define kTextFieldH 30

static NSString *cellIdentifer = @"messageCell";
static NSString *receiveCellIdentifer = @"receiveMessageCell";
static CGFloat offsetY = 0;

@interface ChatViewContorller ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *chatView;
@property (nonatomic,strong) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImageView *toolBar;

@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UITextField *textField;

@end

@implementation ChatViewContorller

-(NSArray *)messageArray
{
    if (!_messageArray) {
        NSString *messagePath = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
        _messageArray = [[NSMutableArray alloc] initWithContentsOfFile:messagePath];
    }
    return _messageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // add keyboard observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldChange:) name:
     UITextFieldTextDidChangeNotification object:nil];
    // setUp navigationBar
    [self setNavigationBar];
    
    // add chatListView
    [self addChatView];
    
    // set toolView
    [self setToolView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChatView
{
    self.chatView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kToolBarH)];
    self.chatView.delegate = self;
    self.chatView.dataSource = self;
    self.chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chatView];
     [self.chatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    self.chatView.bounces = NO;
    // scroll to last line
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageArray.count -1 inSection:0];
    [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)setNavigationBar
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UILabel *charInforLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    charInforLabel.font = [UIFont systemFontOfSize:15];
    charInforLabel.text = [NSString stringWithFormat:@"%@(%@)",self.chatFriend.nickName,self.chatFriend.isOnline? @"在线":@"离线"];
    UIBarButtonItem *inforItem = [[UIBarButtonItem alloc] initWithCustomView:charInforLabel];
    self.navigationItem.leftBarButtonItems = @[backButton,inforItem];
    
    UIImage *iconImage = [self scaleToSize:[UIImage imageNamed:self.chatFriend.icon] size:CGSizeMake(80, 80)];
    UIButton *friendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [friendButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [friendButton setBackgroundImage:[self circleImageWithImage:iconImage borderWidth:0 boraderColor:[UIColor clearColor]] forState:UIControlStateNormal];
    UIBarButtonItem *infroButton = [[UIBarButtonItem alloc] initWithCustomView:friendButton];
    infroButton.tintColor = [UIColor clearColor];
    self.navigationItem.rightBarButtonItem = infroButton;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setToolView
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, self.view.frame.size.height - kToolBarH, self.view.frame.size.width, kToolBarH);
    bgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [self.view addSubview:bgView];
    
    UIButton *sendSoundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendSoundBtn.frame = CGRectMake(0, 0, kToolBarH, kToolBarH);
    [sendSoundBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [bgView addSubview:sendSoundBtn];
    
    UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addMoreBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH, 0, kToolBarH, kToolBarH);
    [addMoreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [bgView addSubview:addMoreBtn];
    self.addButton = addMoreBtn;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kToolBarH-5, 5, kToolBarH, kToolBarH-10)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendBtn"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sendButton];
    sendButton.hidden = YES;
    self.sendButton = sendButton;
    
    
    UIButton *expressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expressionBtn.frame = CGRectMake(self.view.frame.size.width - kToolBarH * 2, 0, kToolBarH, kToolBarH);
    [expressionBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [bgView addSubview:expressionBtn];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(kToolBarH, (kToolBarH - kTextFieldH) * 0.5, self.view.frame.size.width - 3 * kToolBarH, kTextFieldH);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    self.textField = textField;
    [bgView addSubview:textField];
}

#pragma -mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [Message getMessageByDic:self.messageArray[indexPath.row]];
    
    if (message.property) {
        messageCell *cell = [self.chatView dequeueReusableCellWithIdentifier:cellIdentifer];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"messageCell" bundle:nil] forCellReuseIdentifier:cellIdentifer];
            cell=[[[NSBundle mainBundle] loadNibNamed:@"messageCell" owner:nil options:nil] firstObject];
        }
        cell.icon.image = [UIImage imageNamed:@"me"];
        [cell setMessageByMessage:message];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        return cell;
    }else{
        receiveMessageCell *cell = [self.chatView dequeueReusableCellWithIdentifier:receiveCellIdentifer];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"receiveMessageCell" bundle:nil] forCellReuseIdentifier:receiveCellIdentifer];
            cell=[[[NSBundle mainBundle] loadNibNamed:@"receiveMessageCell" owner:nil options:nil] firstObject];
        }
        cell.icon.image = [UIImage imageNamed:self.chatFriend.icon];
        [cell setMessageByMessage:message];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *messageDic = self.messageArray[indexPath.row];
    NSString *text = messageDic[@"text"];
    NSInteger lineNumber = [text length]/11;
    return (lineNumber +1 )*15 + 50;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *timeString=[dateformatter stringFromDate:senddate];
    
    NSMutableDictionary *messageDic = [NSMutableDictionary dictionary];
    messageDic[@"text"] = textField.text;
    messageDic[@"time"] = timeString;
    messageDic[@"type"] = @1;
    
    NSInteger count = self.messageArray.count;
    [self.messageArray insertObject:messageDic atIndex:count];
    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:count inSection:0];
    [self.chatView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationFade];
    // move to last indexPath
    [_chatView scrollToRowAtIndexPath:insertPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    textField.text = @"";
    return YES;
}

- (void)sendClick
{
    [self textFieldShouldReturn:self.textField];
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSDictionary *userInfor = notification.userInfo;
    CGFloat duration = [userInfor[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardFrame = [userInfor[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyboardFrame.origin.y - self.view.frame.size.height;

    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}

- (void)textfieldChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([textField.text length] > 0) {
        self.addButton.hidden = YES;
        self.sendButton.hidden = NO;
    }else
    {
        self.addButton.hidden = NO;
        self.sendButton.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (offsetY != 0 && scrollView.contentOffset.y < offsetY) {
        [self endEdit];
    }
    offsetY = scrollView.contentOffset.y;
}


- (void)endEdit
{
    [self.view endEditing:YES];
}

// cut image
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


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
