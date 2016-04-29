//
//  MessageViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MessageViewController.h"
#import "SystemInformsViewController.h"
#import "CommentsViewController.h"
#import "MessagesssViewController.h"
#import "MentionedViewController.h"
#import "ReceivedPraiseViewController.h"
#import "PayAttentionViewController.h"

@interface MessageViewController ()<FBNavigationBarItemsDelegate>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"消息";
}
- (IBAction)systemSendBtn:(UIButton *)sender {
    SystemInformsViewController *vc = [[SystemInformsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)commentsBtn:(UIButton *)sender {
    CommentsViewController *vc = [[CommentsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)directMessagesBtn:(UIButton *)sender {
    MessagesssViewController *vc = [[MessagesssViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)mentionedBtn:(UIButton *)sender {
    MentionedViewController *vc = [[MentionedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)receivedBtn:(UIButton *)sender {
    ReceivedPraiseViewController *vc = [[ReceivedPraiseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)focusOnMeBtn:(UIButton *)sender {
    PayAttentionViewController *vc = [[PayAttentionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
