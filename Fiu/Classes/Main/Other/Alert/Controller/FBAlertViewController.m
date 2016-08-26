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
#import "EditViewController.h"

static NSInteger const actionBtnTag = 686;
static NSInteger const fiuActionBtnTag = 696;

@interface FBAlertViewController ()

@end

@implementation FBAlertViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    
    [self.view addSubview:self.closeBtn];
    
    [self.view addSubview:self.alertView];
}

#pragma mark -
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 222, SCREEN_WIDTH, 222)];
        _alertView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _alertView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 情景中的“更多”选项
- (void)initFiuSceneAlertStyle {
    self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT - 135, SCREEN_WIDTH, 135);
    NSArray * alertTitle = @[NSLocalizedString(@"Edit", nil), NSLocalizedString(@"Delete", nil), NSLocalizedString(@"cancel", nil)];
    for (NSUInteger idx = 0; idx < alertTitle.count; ++ idx) {
        UIButton * actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * idx, SCREEN_WIDTH, 44)];
        actionBtn.tag = fiuActionBtnTag + idx;
        if (IS_iOS9) {
            actionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        } else {
            actionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        actionBtn.backgroundColor = [UIColor whiteColor];
        [actionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [actionBtn setTitle:alertTitle[idx] forState:(UIControlStateNormal)];
        [actionBtn addTarget:self action:@selector(fiuActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.alertView addSubview:actionBtn];
    }
}

#pragma mark - 情景选项
- (void)fiuActionBtnClick:(UIButton *)button {
    if (button.tag == fiuActionBtnTag) {
        EditViewController * editVC = [[EditViewController alloc] init];
        editVC.createType = self.type;
        editVC.ids = self.targetId;
        editVC.data = self.fiuSceneData;
        editVC.editSceneDone = ^ {
            [self dismissViewControllerAnimated:YES completion:^{
                self.editDoneAndRefresh();
            }];
        };
        [self presentViewController:editVC animated:YES completion:nil];
        
    } else if (button.tag == fiuActionBtnTag + 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.deleteScene();
        }];
        
    } else if (button.tag == fiuActionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 场景中的“更多”选项
- (void)initFBAlertVcStyle:(BOOL)isUserSelf {
    NSArray * alertTitle = [NSArray array];
    
    if (isUserSelf == YES) {
        alertTitle = @[NSLocalizedString(@"CommentVcTitle", nil), NSLocalizedString(@"ShareBtn", nil), NSLocalizedString(@"Edit", nil), NSLocalizedString(@"Delete", nil), NSLocalizedString(@"cancel", nil)];
    } else {
        alertTitle = @[NSLocalizedString(@"saveScene", nil), NSLocalizedString(@"reportScene", nil), NSLocalizedString(@"cancel", nil)];
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT - 132, SCREEN_WIDTH, 132);
    }
    
    for (NSUInteger idx = 0; idx < alertTitle.count; ++ idx) {
        UIButton * actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * idx, SCREEN_WIDTH, 44)];
        actionBtn.tag = actionBtnTag + idx;
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        actionBtn.backgroundColor = [UIColor whiteColor];
        [actionBtn setTitle:alertTitle[idx] forState:(UIControlStateNormal)];
        if ([actionBtn.titleLabel.text isEqualToString:NSLocalizedString(@"reportScene", nil)]) {
            [actionBtn setTitleColor:[UIColor colorWithHexString:@"#E30B0B"] forState:(UIControlStateNormal)];
            
        } else if ([actionBtn.titleLabel.text isEqualToString:NSLocalizedString(@"saveScene", nil)]) {
            [actionBtn setTitleColor:[UIColor colorWithHexString:@"#0B78F7"] forState:(UIControlStateNormal)];
            
        } else
            [actionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        if (isUserSelf == YES) {
            [actionBtn addTarget:self action:@selector(userActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        } else {
            [actionBtn addTarget:self action:@selector(visitorsActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        [self.alertView addSubview:actionBtn];
    }
}

//  用户自己创建的场景，可编辑
- (void)userActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.openCommentVc();
        }];
        
    } else if (button.tag == actionBtnTag + 1) {
//        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
//        shareVC.dataDict = self.sceneData;
//        [self presentViewController:shareVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 2) {
        EditViewController * editVC = [[EditViewController alloc] init];
        editVC.createType = self.type;
        editVC.ids = self.targetId;
        editVC.data = self.sceneData;
        [editVC.bgImgView downloadImage:[self.sceneData valueForKey:@"cover_url"] place:[UIImage imageNamed:@""]];
        editVC.editSceneDone = ^ {
            [self dismissViewControllerAnimated:YES completion:^{
                self.editDoneAndRefresh();
            }];
        };
        [self presentViewController:editVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 3) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.deleteScene();
        }];
        
    } else if (button.tag == actionBtnTag + 4) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//  访客查看场景详情时
- (void)visitorsActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.favoriteTheScene(self.targetId);
        }];
        
    } else if (button.tag == actionBtnTag + 1) {
        ReportViewController * reportVC = [[ReportViewController alloc] init];
        reportVC.targetId = self.targetId;
        [self presentViewController:reportVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
