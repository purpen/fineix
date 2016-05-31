//
//  FBAlertViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBAlertViewController.h"
#import "ReportViewController.h"
#import "FBShareViewController.h"

static const NSInteger actionBtnTag = 686;

@interface FBAlertViewController ()

@end

@implementation FBAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    
    [self.view addSubview:self.alertView];
    
    [self.view addSubview:self.closeBtn];
}

#pragma mark -
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 178, SCREEN_WIDTH, 178)];
        _alertView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _alertView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 178)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 场景中的“更多”选项
- (void)initFBAlertVcStyle:(BOOL)isUserSelf {
    NSArray * userTitle = [NSArray arrayWithObjects:@"删除", @"编辑", @"取消", nil];
    NSArray * visitorsTitle = [NSArray arrayWithObjects:NSLocalizedString(@"CommentVcTitle", nil), NSLocalizedString(@"ShareBtn", nil), NSLocalizedString(@"ReportVcTitle", nil), NSLocalizedString(@"cancel", nil), nil];
    
    for (NSUInteger idx = 0; idx < visitorsTitle.count; ++ idx) {
        UIButton * actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * idx, SCREEN_WIDTH, 44)];
        actionBtn.tag = actionBtnTag + idx;
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        actionBtn.backgroundColor = [UIColor whiteColor];
        [actionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
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
    
    } else if (button.tag == actionBtnTag + 1) {
    
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//  访客查看场景详情时
- (void)visitorsActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.openCommentVc();
        }];
        
    } else if (button.tag == actionBtnTag + 1) {
        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
        shareVC.dataDict = self.sceneData;
        [self presentViewController:shareVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 2) {
        ReportViewController * reportVC = [[ReportViewController alloc] init];
        reportVC.targetId = self.targetId;
        [self presentViewController:reportVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 3) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
