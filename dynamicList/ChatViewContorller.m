//
//  ChatViewContorller.m
//  dynamicList
//
//  Created by 杜强海 on 9/29/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "ChatViewContorller.h"
#import "messageCell.h"
#import "Message.h"
static NSString *cellIdentifer = @"messageCell";
static CGFloat maxTitleWidth = 200;

@interface ChatViewContorller ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *chatView;
@property (nonatomic,strong) NSArray *messageArray;

@end

@implementation ChatViewContorller

-(NSArray *)messageArray
{
    if (!_messageArray) {
        NSString *messagePath = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
        _messageArray = [[NSArray alloc] initWithContentsOfFile:messagePath];
    }
    return _messageArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setUp navigationBar
    [self setNavigationBar];
    
    // add chatListView
    [self addChatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addChatView
{
    self.chatView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.chatView.delegate = self;
    self.chatView.dataSource = self;
    self.chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chatView];
    // set messageTextMaxWidth
    maxTitleWidth = self.view.bounds.size.width - 150;
}

- (void)setNavigationBar
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UILabel *charInforLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    charInforLabel.font = [UIFont systemFontOfSize:15];
    charInforLabel.text = [NSString stringWithFormat:@"%@(%@)",self.chatFriend.nickName,self.chatFriend.isOnline? @"在线":@"离线"];
    UIBarButtonItem *inforItem = [[UIBarButtonItem alloc] initWithCustomView:charInforLabel];
    self.navigationItem.leftBarButtonItems = @[backButton,inforItem];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    messageCell *cell = [self.chatView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"messageCell" bundle:nil] forCellReuseIdentifier:cellIdentifer];
        cell=[[[NSBundle mainBundle] loadNibNamed:@"messageCell" owner:nil options:nil] firstObject];
    }
    Message *message = [Message getMessageByDic:self.messageArray[indexPath.row]];
    [cell setMessageByMessage:message];
    
    // 设置头像
    if (message.property) {
        cell.icon.image = [UIImage imageNamed:@"me"];
    }else{
        cell.icon.image = [UIImage imageNamed:self.chatFriend.icon];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *messageDic = self.messageArray[indexPath.row];
    NSString *text = messageDic[@"text"];
    NSInteger lineNumber = [text length]/15;
    return (lineNumber +1 )*15 + 40;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
