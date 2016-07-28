//
//  FBOrderTimeViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBOrderTimeViewController.h"

static NSInteger const timeBtnTag = 232;

@interface FBOrderTimeViewController ()

@end

@implementation FBOrderTimeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * titleArr = @[NSLocalizedString(@"anySendTime", nil),NSLocalizedString(@"workSendTime", nil),NSLocalizedString(@"weekSendTime", nil), ];
    for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
        UIButton * timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 74 + (54 * idx), SCREEN_WIDTH, 44)];
        [timeBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
        [timeBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            timeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        timeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        timeBtn.backgroundColor = [UIColor whiteColor];
        timeBtn.tag = timeBtnTag + idx;
        [self.view addSubview:timeBtn];
    }
    
}

- (void)timeBtnClick:(UIButton *)button {
    if (button.tag == timeBtnTag) {
        self.getSendTimeBlock(button.titleLabel.text, @"a");
    } else if (button.tag == timeBtnTag + 1) {
        self.getSendTimeBlock(button.titleLabel.text, @"b");
    } else if (button.tag == timeBtnTag + 2) {
        self.getSendTimeBlock(button.titleLabel.text, @"c");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    self.navViewTitle.text = NSLocalizedString(@"SendGoodsTime", nil);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

@end
