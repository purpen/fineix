//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"创建场景"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
    [self addDoneButton];
    
    //  Nav跟内容的分割线
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#F0F0F1" alpha:1];
    [self.navView addSubview:self.line];
}

@end
