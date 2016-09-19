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
#import "UIView+TYAlertView.h"

static NSInteger const actionBtnTag = 686;

@interface FBAlertViewController () {
    NSInteger _isFavorite;
}

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
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 132, SCREEN_WIDTH, 132)];
        _alertView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _alertView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 132)];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 情境中的“更多”选项
- (void)initFBAlertVcStyle:(BOOL)isUserSelf isFavorite:(NSInteger)favorite {
    NSArray * alertTitle = [NSArray array];
    _isFavorite = favorite;
    
    if (isUserSelf == YES) {
        alertTitle = @[NSLocalizedString(@"ShareBtn", nil), NSLocalizedString(@"Delete", nil), NSLocalizedString(@"cancel", nil)];
        
    } else {
        if (favorite == 0) {
            alertTitle = @[NSLocalizedString(@"saveScene", nil), NSLocalizedString(@"reportScene", nil), NSLocalizedString(@"cancel", nil)];
        } else if (favorite == 1) {
            alertTitle = @[NSLocalizedString(@"cancelSaveScene", nil), NSLocalizedString(@"reportScene", nil), NSLocalizedString(@"cancel", nil)];
        }
    }
    
    for (NSUInteger idx = 0; idx < alertTitle.count; ++ idx) {
        UIButton * actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * idx, SCREEN_WIDTH, 44)];
        actionBtn.tag = actionBtnTag + idx;
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        actionBtn.backgroundColor = [UIColor whiteColor];
        [actionBtn setTitle:alertTitle[idx] forState:(UIControlStateNormal)];
        if ([actionBtn.titleLabel.text isEqualToString:NSLocalizedString(@"reportScene", nil)]) {
            [actionBtn setTitleColor:[UIColor colorWithHexString:@"#E30B0B"] forState:(UIControlStateNormal)];
        } else if ([actionBtn.titleLabel.text isEqualToString:NSLocalizedString(@"saveScene", nil)] || [actionBtn.titleLabel.text isEqualToString:NSLocalizedString(@"cancelSaveScene", nil)] ) {
            [actionBtn setTitleColor:[UIColor colorWithHexString:@"#0B78F7"] forState:(UIControlStateNormal)];
        } else {
            [actionBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        }
        
        if (isUserSelf == YES) {
            [actionBtn addTarget:self action:@selector(userActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        } else {
            [actionBtn addTarget:self action:@selector(visitorsActionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        [self.alertView addSubview:actionBtn];
    }
}

//  用户自己创建的情境，可编辑／删除
- (void)userActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
        shareVC.sceneModel = self.sceneModel;
        shareVC.sceneId = self.targetId;
        [self presentViewController:shareVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            TYAlertView *cancelAlertView = [TYAlertView alertViewWithTitle:@"情境删除后不可恢复" message:@""];
            cancelAlertView.layer.cornerRadius = 10;
            cancelAlertView.buttonDefaultBgColor = [UIColor colorWithHexString:fineixColor];
            cancelAlertView.buttonCancleBgColor = [UIColor colorWithHexString:@"#999999"];
            [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"取消" style:(TYAlertActionStyleCancle) handler:^(TYAlertAction *action) {
                
            }]];
            [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"确定删除" style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
                self.deleteScene(self.targetId);
            }]];
            [cancelAlertView showInWindowWithBackgoundTapDismissEnable:YES];
        }];
        
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

//  访客查看情境详情时
- (void)visitorsActionBtnClick:(UIButton *)button {
    if (button.tag == actionBtnTag) {
        if (_isFavorite == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.favoriteTheScene(self.targetId);
            }];
            
        } else if (_isFavorite == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.cancelFavoriteTheScene(self.targetId);
            }];
        }
        
    } else if (button.tag == actionBtnTag + 1) {
        ReportViewController * reportVC = [[ReportViewController alloc] init];
        reportVC.targetId = self.targetId;
        [self presentViewController:reportVC animated:YES completion:nil];
        
    } else if (button.tag == actionBtnTag + 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
