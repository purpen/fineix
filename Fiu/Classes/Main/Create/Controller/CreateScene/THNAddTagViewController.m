//
//  THNAddTagViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAddTagViewController.h"

@interface THNAddTagViewController ()

@end

@implementation THNAddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.delegate = self;
    [self addNavViewTitle:NSLocalizedString(@"addTagVcTitle", nil)];
    [self addCloseBtn:@"icon_cancel"];
    [self addSureButton];
}

- (void)thn_sureButtonAction {
    
}

@end
