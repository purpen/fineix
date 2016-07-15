//
//  FBShareViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBShareViewController.h"
#import "ShareStyleCollectionViewCell.h"
#import "FBEditShareInfoViewController.h"

static NSString *const URLShareTextNum = @"/scene_sight/add_share_context_num";
static NSString *const URLGiveExp = @"/user/send_exp";

@interface FBShareViewController () {
    NSString * _editBgImg;
    NSString * _editTitle;
    NSString * _editDes;
    NSString * _tags;
    NSString * _oid;
}

@pro_strong  ShareViewController  *  shareVC;

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

- (FBPopupView *)sharePopView {
    if (!_sharePopView) {
        _sharePopView = [[FBPopupView alloc] init];
    }
    return _sharePopView;
}

#pragma mark - 网络请求
- (void)networkShareTextNumData:(NSString *)oid {
    self.shareTextNumRequest = [FBAPI postWithUrlString:URLShareTextNum requestDictionary:@{@"id":oid} delegate:self];
    [self.shareTextNumRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"%@", result);
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 分享成功送积分
- (void)networkGiveExp {
    [self.shareVC dismissViewControllerAnimated:YES completion:nil];
    
    self.sendExpRequest = [FBAPI postWithUrlString:URLGiveExp requestDictionary:@{@"type":@"2", @"evt":@"1", @"target_id":self.sceneId} delegate:self];
    [self.sendExpRequest  startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            NSInteger expNum = [[[result valueForKey:@"data"] valueForKey:@"exp"] integerValue];
            if (expNum > 0) {
                [self.sharePopView showPopupViewOnWindowStyleTwo:NSLocalizedString(@"shareDoneContent", nil) withAddJifen:expNum];
            
            } else if (expNum == 0) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"shareDone", nil)];
            }
        }
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
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
    [self.styleView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                   animated:YES
                             scrollPosition:(UICollectionViewScrollPositionNone)];
}

#pragma mark - 分享场景信息视图
- (UIView *)shareView {
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareView addSubview:self.shareBottomView];
        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editShareInfo)];
//        [_shareView addGestureRecognizer:tap];
    }
    return _shareView;
}

//#pragma mark - 打开编辑场景语境的视图
//- (void)editShareInfo {
//    FBEditShareInfoViewController * editShareInfoVC = [[FBEditShareInfoViewController alloc] init];
//    editShareInfoVC.bgImg = _editBgImg;
//    editShareInfoVC.afterTitle = _editTitle;
//    editShareInfoVC.afterDes = _editDes;
//    editShareInfoVC.sceneTags = _tags;
//    [self presentViewController:editShareInfoVC animated:YES completion:nil];
//    
//    editShareInfoVC.getEdtiShareText = ^ (NSString * title, NSString * des, NSString * oid) {
//        [self.shareTopView changeWithSearchText:title withDes:des];
//        [self.shareBottomView changeWithSearchText:title withDes:des];
//        [self.shareTitleBottomView changeWithSearchText:title withDes:des];
//        [self.shareTitleTopView changeWithSearchText:title withDes:des];
//        _oid = oid;
//    };
//}

- (ShareStyleTopView *)shareTopView {
    if (!_shareTopView) {
        _shareTopView = [[ShareStyleTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareTopView setShareSceneData:self.dataDict];
        _editBgImg = [self.dataDict valueForKey:@"cover_url"];
        _editTitle = [self.dataDict valueForKey:@"title"];
        _editDes = [self.dataDict valueForKey:@"des"];
        _tags = [[self.dataDict valueForKey:@"tag_titles"] componentsJoinedByString:@","];
    }
    return _shareTopView;
}

- (ShareStyleBottomView *)shareBottomView {
    if (!_shareBottomView) {
        _shareBottomView = [[ShareStyleBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareBottomView setShareSceneData:self.dataDict];
    }
    return _shareBottomView;
}

- (ShareStyleTitleBottomView *)shareTitleBottomView {
    if (!_shareTitleBottomView) {
        _shareTitleBottomView = [[ShareStyleTitleBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareTitleBottomView setShareSceneData:self.dataDict];
    }
    return _shareTitleBottomView;
}

- (ShareStyleTitleTopView *)shareTitleTopView {
    if (!_shareTitleTopView) {
        _shareTitleTopView = [[ShareStyleTitleTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_shareTitleTopView setShareSceneData:self.dataDict];
    }
    return _shareTitleTopView;
}

#pragma mark - 分享样式视图
- (UICollectionView *)styleView {
    if (!_styleView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70)/4, 110);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
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
    return 4;
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
            [self.shareView addSubview:self.shareBottomView];
        }
        
    } else if (indexPath.row == 1) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareTopView];
        }
        
    } else if (indexPath.row == 2) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareTitleBottomView];
        }
        
    } else if (indexPath.row == 3) {
        if (self.shareView.subviews.count > 0) {
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:self.shareTitleTopView];
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
        [_shareBtn setImage:[UIImage imageNamed:@"Share_white"] forState:(UIControlStateNormal)];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_shareBtn addTarget:self action:@selector(shareItemSelected) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBtn;
}

- (void)shareItemSelected {
    //  保存图片到本地
    UIImageWriteToSavedPhotosAlbum([self shareImage], self, nil, nil);
    
    if (_oid.length > 0) {
        [self networkShareTextNumData:_oid];
    }
    
    self.shareVC = [[ShareViewController alloc] init];
    self.shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.shareVC animated:YES completion:nil];
    [self.shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)wechatShareBtnAction {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self networkGiveExp];
        }
    }];
}

-(void)timelineShareBtnAction {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self networkGiveExp];
        }
    }];
}

-(void)qqShareBtnAction {
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [self networkGiveExp];
        }
    }];
}

-(void)sinaShareBtnAction {
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"有Fiu的生活，才够意思，快点扫码加我吧！查看个人主页>>http://m.taihuoniao.com" image:[self shareImage] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            [self networkGiveExp];
        }
    }];
}

@end
