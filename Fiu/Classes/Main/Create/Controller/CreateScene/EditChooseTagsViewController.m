//
//  EditChooseTagsViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditChooseTagsViewController.h"

@interface EditChooseTagsViewController ()

@end

@implementation EditChooseTagsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"editTagsVC", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCloseBtn];
    [self addDoneButton];
    [self.doneBtn setTitle:NSLocalizedString(@"Done", nil) forState:(UIControlStateNormal)];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(editTagsDone) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)editTagsDone {
    [SVProgressHUD showInfoWithStatus:@"完成编辑"];
}

@end
