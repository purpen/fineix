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
    
    [self setReleaseViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self addLine];
}

- (void)setReleaseViewUI {
    [self.view addSubview:self.scenceView];
    
    [self.view addSubview:self.addView];
}

- (ScenceMessageView *)scenceView {
    if (!_scenceView) {
        _scenceView = [[ScenceMessageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 236.5)];
        
    }
    return _scenceView;
}

- (ScenceAddMoreView *)addView {
    if (!_addView) {
        _addView = [[ScenceAddMoreView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT- 290)];
        _addView.nav = self.navigationController;
    }
    return _addView;
}

@end
