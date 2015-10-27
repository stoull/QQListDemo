//
//  detailViewController.m
//  dynamicList
//
//  Created by 杜强海 on 9/30/15.
//  Copyright (c) 2015 AChang. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.iconImageView.image = [UIImage imageNamed:self.chatFriend.icon];
    self.nameLabel.text = self.chatFriend.nickName;
    self.profileLabel.text = self.chatFriend.signature;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
