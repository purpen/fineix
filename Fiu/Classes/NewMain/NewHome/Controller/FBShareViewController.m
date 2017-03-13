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
#import "THNShareActionView.h"
#import "UIImage+QRCode.h"

static NSString *const URLShareTextNum = @"/scene_sight/add_share_context_num";
static NSString *const URLGiveExp = @"/user/send_exp";
static NSString *const URLSceneInfo = @"/scene_sight/view";
static NSString *const URLShareLink = @"/gateway/share_link";

static NSString *const ShareURlText = @"我在D3IN寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！>>> http://m.taihuoniao.com/d3in";

@interface FBShareViewController () {
    NSString *_editBgImg;
    NSString *_editTitle;
    NSString *_editDes;
    NSString *_tags;
    NSString *_oid;
    NSString *_linkUrl;
}

@property (nonatomic, strong) ShareViewController  *shareVC;

@end

@implementation FBShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setShareVcUI];
    
    if (self.sceneId.length) {
        [self thn_networkShareInfoData];
    }
}

- (FBPopupView *)sharePopView {
    if (!_sharePopView) {
        _sharePopView = [[FBPopupView alloc] init];
    }
    return _sharePopView;
}

#pragma mark - 网络请求
#pragma mark 统计分享次数
- (void)networkShareTextNumData:(NSString *)oid {
    self.shareTextNumRequest = [FBAPI postWithUrlString:URLShareTextNum requestDictionary:@{@"id":oid} delegate:self];
    [self.shareTextNumRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"%@", result);
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"---%@---", error);
    }];
}

#pragma mark 获取分享链接
- (void)thn_networkShareInfoData {
    self.shareRequest = [FBAPI postWithUrlString:URLShareLink requestDictionary:@{@"id":self.sceneId, @"type":@"2"} delegate:self];
    [self.shareRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSDictionary *dict =  [result valueForKey:@"data"];
            _linkUrl = [dict valueForKey:@"url"];
            [self.shareTopView setQRCodeImagewithLink:_linkUrl];
            [self.styleOneView setQRCodeImagewithLink:_linkUrl];
            [self.styleTwoView setQRCodeImagewithLink:_linkUrl];
            [self.styleThreeView setQRCodeImagewithLink:_linkUrl];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
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

#pragma mark 获取情境数据
- (void)thn_getSceneInfoData:(NSString *)sceneId {
    [SVProgressHUD show];
    self.sceneInfoRequest = [FBAPI getWithUrlString:URLSceneInfo requestDictionary:@{@"id":sceneId} delegate:self];
    [self.sceneInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        HomeSceneListRow *sceneModel = [[HomeSceneListRow alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self.shareTopView setShareSceneData:sceneModel];
        [self.styleOneView setShareSceneData:sceneModel];
        [self.styleTwoView setShareSceneData:sceneModel];
        [self.styleThreeView setShareSceneData:sceneModel];
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置界面UI
- (void)setShareVcUI {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.shareView];
    CGAffineTransform shareViewTrans = CGAffineTransformScale(self.shareView.transform, 0.7, 0.7);
    [self.shareView setTransform:shareViewTrans];
    self.shareView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2.24);
    
    
    [self.view addSubview:self.styleView];
    [self.styleView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                   animated:YES
                             scrollPosition:(UICollectionViewScrollPositionNone)];
    
    if (self.sceneModel.idField > 0) {
        [self.shareTopView setShareSceneData:self.sceneModel];
        [self.styleOneView setShareSceneData:self.sceneModel];
        [self.styleTwoView setShareSceneData:self.sceneModel];
        [self.styleThreeView setShareSceneData:self.sceneModel];
    } else {
        [self thn_getSceneInfoData:self.sceneId];
    }
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
    }
    return _shareTopView;
}

- (ShareStyleViewOne *)styleOneView {
    if (!_styleOneView) {
        _styleOneView = [[ShareStyleViewOne alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _styleOneView;
}

- (ShareStyleViewTwo *)styleTwoView {
    if (!_styleTwoView) {
        _styleTwoView = [[ShareStyleViewTwo alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _styleTwoView;
}

- (ShareStyleViewThree *)styleThreeView {
    if (!_styleThreeView) {
        _styleThreeView = [[ShareStyleViewThree alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _styleThreeView;
}

#pragma mark - 分享样式视图
- (UICollectionView *)styleView {
    if (!_styleView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70)/4, SCREEN_HEIGHT *0.165);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        
        _styleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT *0.835, SCREEN_WIDTH, SCREEN_HEIGHT *0.165) collectionViewLayout:flowLayout];
        _styleView.showsHorizontalScrollIndicator = NO;
        _styleView.delegate = self;
        _styleView.dataSource = self;
        [_styleView registerClass:[ShareStyleCollectionViewCell class] forCellWithReuseIdentifier:@"shareStyleCollectionViewCellId"];
        _styleView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5" alpha:.3];
    }
    return _styleView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareStyleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareStyleCollectionViewCellId" forIndexPath:indexPath];
    cell.styleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"Share_Style_00%zi", indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_changeShareStyle:indexPath.row];
}

#pragma mark - 切换分享样式
- (void)thn_changeShareStyle:(NSInteger)index {
    switch (index) {
        case 0:
            [self thn_removeAndReplaceLastStyleView:self.shareTopView];
            break;
        case 1:
            [self thn_removeAndReplaceLastStyleView:self.styleOneView];
            break;
        case 2:
            [self thn_removeAndReplaceLastStyleView:self.styleTwoView];
            break;
        case 3:
            [self thn_removeAndReplaceLastStyleView:self.styleThreeView];
            break;
            
        default:
            break;
    }
}

- (void)thn_removeAndReplaceLastStyleView:(UIView *)style {
    if (self.shareView.subviews.count > 0) {
        [UIView animateWithDuration:.3 animations:^{
            [self.shareView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.shareView addSubview:style];
        }];
    }
}

#pragma mark - 顶部视图
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        
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
        [_shareBtn addTarget:self action:@selector(shareItemSelected) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBtn;
}

- (void)shareItemSelected {
    if (_linkUrl.length) {
        [THNShareActionView showShare:self shareMessageObject:[self shareMessageObject] linkUrl:_linkUrl];
    }
    
    if (_oid.length > 0) {
        [self networkShareTextNumData:_oid];
    }
}

#pragma mark - 创建分享消息对象
- (UMSocialMessageObject *)shareMessageObject {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.shareImage = [self shareImage];
    messageObject.shareObject = shareObject;
    return messageObject;
}

#pragma mark - 保存图片到本地
- (void)saveImageToPhotoAlbum {
    UIImageWriteToSavedPhotosAlbum([self shareImage],
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL){
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - 创建分享图片对象
- (UIImage *)shareImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), NO, [UIScreen mainScreen].scale);
    [self.shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 分享完成后获取积分
- (void)afterShare{
    [self networkGiveExp];
    [self saveImageToPhotoAlbum];
}

@end
