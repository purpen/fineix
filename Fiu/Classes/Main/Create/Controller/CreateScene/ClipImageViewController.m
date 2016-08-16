//
//  ClipImageViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ClipImageViewController.h"
#import "FBPictureCollectionViewCell.h"
#import "FBLoadPhoto.h"
#import "SceneAddViewController.h"

@interface ClipImageViewController () {
    CGFloat beginOriginY;
}

@pro_assign CGFloat scale;
@pro_assign CGFloat rotaion;
@pro_assign CGPoint centerPoint;
@pro_assign CGPoint touchPoint;

@end

@implementation ClipImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    [self setFirstAppStart];
    
    if ([self isAllowMedia]) {
        if (self.pictureView.hidden == YES) {
            if (self.cameraView.session) {
                [self.cameraView.session startRunning];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self loadAllPhotos];
    [self setViewUI];
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"creatLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"creatLaunch"];
        [self setGuideImgForVC:@"Guide_photo"];
    }
}

#pragma mark - 设置顶部Nav
- (void)setNavViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.navTitle.hidden = YES;
    [self addCancelButton:@"icon_cancel"];
    [self addOpenPhotoAlbumsButton:NSLocalizedString(@"createVcTitle", nil)];
    [self getPhotoAlbumsTitleSize:NSLocalizedString(@"createVcTitle", nil)];
    [self.openPhotoAlbums addTarget:self action:@selector(openPhotoAlbumsClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 点击“继续”
- (void)nextButtonClick:(UIImage *)image {
    SceneAddViewController * addVC = [[SceneAddViewController alloc] init];
    addVC.filtersImg = self.clipImageView.capture;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)setNavItemAction:(BOOL)action {
    self.cancelBtn.hidden = action;
    self.nextBtn.hidden = action;
}

- (void)setViewUI {
    [self.view addSubview:self.pictureView];
    [self.pictureView addSubview:self.clipImageView];
    
    [self.pictureView addSubview:self.dragView];
    
    [self.pictureView addSubview:self.photosView];

    [self.view addSubview:self.photoAlbumsView];
    
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - init
- (NSMutableArray *)sortPhotosArr {
    if (!_sortPhotosArr) {
        _sortPhotosArr = [NSMutableArray array];
    }
    return _sortPhotosArr;
}

- (NSMutableArray *)photoAlbumArr {
    if (!_photoAlbumArr) {
        _photoAlbumArr = [NSMutableArray array];
    }
    return _photoAlbumArr;
}

-(UIView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 90)];
    }
    return _pictureView;
}

- (UIView *)dragView {
    if (!_dragView) {
        _dragView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 30)];
        _dragView.backgroundColor = [UIColor blackColor];
        _dragView.clipsToBounds = YES;
        
        [_dragView addSubview:self.gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
    }
    return _dragView;
}

- (UIImageView *)gripView {
    if (!_gripView) {
        _gripView = [[UIImageView alloc] initWithFrame:self.dragView.bounds];
        _gripView.contentMode = UIViewContentModeCenter;
        _gripView.image = [UIImage imageNamed:@"icon_upward"];
    }
    return _gripView;
}

#pragma mark - 加载相薄页面
- (PhotoAlbumsView *)photoAlbumsView {
    if (!_photoAlbumsView) {
        _photoAlbumsView = [[PhotoAlbumsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
        _photoAlbumsView.photosMarr = self.sortPhotosArr;
        _photoAlbumsView.collectionView = self.photosView;
        _photoAlbumsView.photoAlbumsBtn = self.openPhotoAlbums;
        _photoAlbumsView.nextBtn = self.nextBtn;
        //  from "PhotoAlbumsView.h"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewTitle:) name:@"PhotoAlbumsName" object:nil];
    }
    return _photoAlbumsView;
}

- (void)changeViewTitle:(NSNotification *)title {
    [self getPhotoAlbumsTitleSize:[title object]];
    [self.openPhotoAlbums setTitle:[title object] forState:(UIControlStateNormal)];
}

#pragma mark - 打开相册列表
- (void)openPhotoAlbumsClick {
    if (self.openPhotoAlbums.selected == YES) {
        self.openPhotoAlbums.selected = NO;
        CGRect openPhotoAlbumsRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = NO;
        }];
        
    } else if (self.openPhotoAlbums.selected == NO){
        self.openPhotoAlbums.selected = YES;
        CGRect openPhotoAlbumsRect = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [UIView animateWithDuration:.3 animations:^{
            self.photoAlbumsView.frame = openPhotoAlbumsRect;
            self.nextBtn.hidden = YES;
        }];
    }
}

#pragma mark - 打开相机的页面
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
        _cameraView.VC = self;
        _cameraView.Nav = self.navigationController;
    }
    return _cameraView;
}

#pragma mark - 加载所有的相片
- (void)loadAllPhotos {
    __weak __typeof(self)weakSelf = self;
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSArray *photoAlbums, NSError *error) {
        if (!error) {
            NSEnumerator * enumerator = [photos reverseObjectEnumerator];
            while (id object = [enumerator nextObject]) {
                [weakSelf.sortPhotosArr addObject:object];
            }
            [weakSelf.photosView reloadData];
            [weakSelf.photosView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                          animated:YES
                                    scrollPosition:(UICollectionViewScrollPositionNone)];
            
            if (photos.count) {
                [weakSelf showFirstPhoto];
            }
            weakSelf.photoAlbumArr = [photoAlbums copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"photoAlbums" object:self.photoAlbumArr];
            
        } else {
            NSLog(@"error:%@", error);
        }
    }];
}

- (void)showFirstPhoto {
    //  默认加载第一张照片
    FBPhoto *firstPhoto = [self.sortPhotosArr objectAtIndex:0];
    [self.clipImageView displayImage:firstPhoto.originalImage];
}

#pragma mark - 相册的列表视图
- (UICollectionView *)photosView {
    if (!_photosView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6) / 4, (SCREEN_WIDTH - 6) / 4);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        
        _photosView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH+32, SCREEN_WIDTH, CGRectGetHeight(self.pictureView.bounds) - (SCREEN_WIDTH+32)) collectionViewLayout:flowLayout];
        _photosView.delegate = self;
        _photosView.dataSource = self;
        _photosView.backgroundColor = [UIColor blackColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        _photosView.showsVerticalScrollIndicator = NO;
        [_photosView registerClass:[FBPictureCollectionViewCell class] forCellWithReuseIdentifier:@"FBPictureCollectionViewCell"];
    }
    return _photosView;
}

#pragma mark  UICollectionViewDataSource(相册列表)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sortPhotosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellIdentifier = @"FBPictureCollectionViewCell";
    FBPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    FBPhoto *photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    cell.imageView.image = photo.thumbnailImage;
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBPhoto *photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    [self.clipImageView displayImage:photo.originalImage];
    if (self.clipImageView.frame.origin.y != 0) {
        [self tapGestureAction:nil];
    }
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:NSLocalizedString(@"album", nil), NSLocalizedString(@"camera", nil), nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        if ([self isAllowMedia]) {
            if (self.cameraView.session) {
                [self.cameraView.session startRunning];
            }
            self.pictureView.hidden = YES;
            [self.view addSubview:self.cameraView];
        }
        
    } else if (index == 0) {
        if (self.cameraView.session) {
            [self.cameraView.session stopRunning];
        }
        [self.cameraView removeFromSuperview];
        self.pictureView.hidden = NO;
    }
}

- (BOOL)isAllowMedia{
    BOOL isMedia;
    NSString *mediaMessage = @"请在设置->隐私->相机 中打开本应用的访问权限";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isMedia = NO;
    }else{
        isMedia = YES;
    }
    if (!isMedia) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 7;
        alertView.delegate = self;
        [alertView show];
    }
    return isMedia;
}

#pragma mark - 懒加载
- (FBImageScrollView *)clipImageView {
    if (!_clipImageView) {
        _clipImageView = [[FBImageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _clipImageView.clipsToBounds = YES;
    }
    return _clipImageView;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.clipImageView.frame;
            CGFloat endOriginY = self.clipImageView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -CGRectGetHeight(self.clipImageView.bounds);
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -CGRectGetHeight(self.clipImageView.bounds) : 0;
            }
            
            CGRect dragFrame = self.dragView.frame;
            dragFrame.origin.y = CGRectGetMaxY(topFrame);
            
            CGRect collectionFrame = self.photosView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame) + 32;
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(topFrame) + 122);
            
            [UIView animateWithDuration:.3f animations:^{
                self.clipImageView.frame = topFrame;
                self.dragView.frame = dragFrame;
                self.photosView.frame = collectionFrame;
                
                self.gripView.transform = CGAffineTransformIdentity;
                self.gripView.transform = CGAffineTransformMakeRotation(topFrame.origin.y == 0 ? 0 : (M_PI * (180)/180.0));
            }];
            
            if (topFrame.origin.y == 0) {
                [self setNavItemAction:NO];
            } else {
                [self setNavItemAction:YES];
            }
            
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.clipImageView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.clipImageView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.photosView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame) + 32;
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(topFrame) + 122);
            
            CGRect dragFrame = self.dragView.frame;
            dragFrame.origin.y = CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.clipImageView.bounds)))) {
                self.clipImageView.frame = topFrame;
                self.dragView.frame = dragFrame;
                self.photosView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.clipImageView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -CGRectGetHeight(self.clipImageView.bounds) : 0;
    
    CGRect dragFrame = self.dragView.frame;
    dragFrame.origin.y = dragFrame.origin.y == 0 ? CGRectGetMaxY(topFrame) : 0;
    
    CGRect collectionFrame = self.photosView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame) + 32;
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(topFrame) + 122);
    
    [UIView animateWithDuration:.3f animations:^{
        self.clipImageView.frame = topFrame;
        self.dragView.frame = dragFrame;
        self.photosView.frame = collectionFrame;
    
        self.gripView.transform = CGAffineTransformIdentity;
        self.gripView.transform = CGAffineTransformMakeRotation(topFrame.origin.y == 0 ? 0 : (M_PI * (180)/180.0));
    }];
    
    if (topFrame.origin.y == 0) {
        [self setNavItemAction:NO];
    } else {
        [self setNavItemAction:YES];
    }
}

#pragma mark - 停止运行相机
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.cameraView.session) {
        [self.cameraView.session stopRunning];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PhotoAlbumsName" object:nil];
}

@end
