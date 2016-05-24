//
//  FBShareViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBShareViewController.h"
#import "ShareStyleCollectionViewCell.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <SVProgressHUD/SVProgressHUD.h>

static NSInteger const shareViewTag = 10000;

@interface FBShareViewController ()

@end

@implementation FBShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setShareVcUI];
}

- (UIImage *)shareImage {
    UIGraphicsBeginImageContextWithOptions(self.shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 设置界面UI
- (void)setShareVcUI {
    [self.view addSubview:self.shareView];
    CGAffineTransform shareViewTrans = CGAffineTransformScale(self.shareView.transform, 0.76, 0.76);
    [self.shareView setTransform:shareViewTrans];
    self.shareView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2.24);
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.styleView];
}

#pragma mark - 分享场景信息视图
- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareView addSubview:self.shareTopView];
    }
    return _shareView;
}

- (ShareStyleTopView *)shareTopView {
    if (!_shareTopView) {
        _shareTopView = [[ShareStyleTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shareTopView.tag = shareViewTag;
        [_shareTopView setShareSceneData:self.dataDict];
    }
    return _shareTopView;
}

- (ShareStyleBottomView *)shareBottomView {
    if (!_shareBottomView) {
        _shareBottomView = [[ShareStyleBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _shareBottomView.tag = shareViewTag + 1;
        [_shareBottomView setShareSceneData:self.dataDict];
    }
    return _shareBottomView;
}

#pragma mark - 分享样式视图
- (UICollectionView *)styleView {
    if (!_styleView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(70, 110);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _styleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 110) collectionViewLayout:flowLayout];
        _styleView.showsHorizontalScrollIndicator = NO;
        _styleView.delegate = self;
        _styleView.dataSource = self;
        [_styleView registerClass:[ShareStyleCollectionViewCell class] forCellWithReuseIdentifier:@"shareStyleCollectionViewCellId"];
        _styleView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
    }
    return _styleView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareStyleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareStyleCollectionViewCellId" forIndexPath:indexPath];
    cell.styleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"Share_Style_%zi", indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareTopView];
            [self.shareTopView defultTitleFontStyle];
        }
        
    } else if (indexPath.row == 1) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareTopView];
            [self.shareTopView smallTitleFontStyle];
        }
        
    } else if (indexPath.row == 2) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareBottomView];
            [self.shareBottomView defultTitleFontStyle];
        }
        
    } else if (indexPath.row == 3) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareBottomView];
            [self.shareBottomView smallTitleFontStyle];
        }
    }
}

#pragma mark - 顶部视图
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:.3];
        
        [_topView addSubview:self.closeBtn];
        [_topView addSubview:self.shareBtn];
    }
    return _topView;
}

#pragma mark - 关闭
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeItemSelected) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

- (void)closeItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 分享
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_shareBtn setTitle:NSLocalizedString(@"ShareBtn", nil) forState:(UIControlStateNormal)];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_shareBtn addTarget:self action:@selector(shareItemSelected) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBtn;
}

- (void)shareItemSelected {
    ShareViewController * shareVC = [[ShareViewController alloc] init];
    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:shareVC animated:YES completion:nil];
    [shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)wechatShareBtnAction {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)timelineShareBtnAction {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)qqShareBtnAction {
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)sinaShareBtnAction {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"有Fiu的生活，才够意思，快点扫码加我吧！查看个人主页>>http://m.taihuoniao.com" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

@end
