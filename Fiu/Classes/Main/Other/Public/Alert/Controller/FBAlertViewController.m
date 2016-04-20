//
//  FBAlertViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBAlertViewController.h"

static const NSInteger actionBtnTag = 686;

@interface FBAlertViewController ()

@end

@implementation FBAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    
    [self.view addSubview:self.alertView];
}

#pragma mark -
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 134, SCREEN_WIDTH, 134)];
        _alertView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _alertView;
}

#pragma mark - 场景中的“更多”选项
- (void)initFBAlertVcStyle:(BOOL)isUserSelf {
    NSArray * userTitle = [NSArray arrayWithObjects:@"删除", @"编辑", @"取消", nil];
    NSArray * visitorsTitle = [NSArray arrayWithObjects:@"举报", @"分享", @"取消", nil];
    
    for (NSUInteger idx = 0; idx < 3; ++ idx) {
        UIButton * actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * idx, SCREEN_WIDTH, 44)];
        actionBtn.tag = actionBtnTag + idx;
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        actionBtn.backgroundColor = [UIColor whiteColor];
        if (actionBtn.tag == actionBtnTag) {
            [actionBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        } else {
            [actionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        //
        if (isUserSelf) {
            [actionBtn setTitle:userTitle[idx] forState:(UIControlStateNormal)];
            [actionBtn addTarget:self action:@selector(userActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        } else {
            [actionBtn setTitle:visitorsTitle[idx] forState:(UIControlStateNormal)];
            [actionBtn addTarget:self action:@selector(visitorsActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        [self.alertView addSubview:actionBtn];
    }
}

//  用户自己创建的场景，可编辑
- (void)userActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        [SVProgressHUD showInfoWithStatus:@"删除场景"];
    
    } else if (button.tag == actionBtnTag + 1) {
        [SVProgressHUD showInfoWithStatus:@"编辑场景"];
    
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//  访客查看场景详情时
- (void)visitorsActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        [SVProgressHUD showInfoWithStatus:@"举报场景"];
        
    } else if (button.tag == actionBtnTag + 1) {
        [SVProgressHUD showInfoWithStatus:@"分享场景"];
        
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
