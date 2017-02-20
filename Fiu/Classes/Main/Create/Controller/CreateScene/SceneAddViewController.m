//
//  SceneAddViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneAddViewController.h"
#import "ReleaseViewController.h"
#import "MarkGoodsViewController.h"
#import "FBFilters.h"
#import "FBStickersContainer.h"

static NSString *const URLDeleUserGoods = @"/product/deleted";
static NSString *const URLUserAddGoods = @"/product/submit";
static NSString *const URLUserAddBrand = @"/scene_brands/submit";
static NSString *const DefaultFilter = @"original";

@interface SceneAddViewController () <FBFootViewDelegate, FBUserGoodsTagDelegaet, FBStickerContainerDelegate> {
    UserGoodsTag    *goodsTag;
    NSString        *_title;
    NSString        *_price;
    NSString        *_imgUrl;
    NSInteger        _idx;
    BOOL             _urlGoods;
    NSString        *_filterName;
    NSArray         *_footTitleArr;
    FSImageParamType _editFilterType; //  记录调整参数的类型（亮度／曝光度...）
    NSInteger        _chooseIndex;
}

@end

@implementation SceneAddViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFiltersControllerUI];
    
    _idx = 391;
}

- (NSArray *)footTitleArr {
    if (!_footTitleArr) {
        _footTitleArr = @[NSLocalizedString(@"marker", nil),
                          NSLocalizedString(@"filter", nil),
                          NSLocalizedString(@"adjustment", nil)
                          ];
    }
    return _footTitleArr;
}

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"flitersLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"flitersLaunch"];
        [self setGuideImgForVC:@"Guide_stamp product"];
    }
}

#pragma mark - 网络请求
#pragma mark 添加品牌
- (void)thn_networkUserAddBrand:(NSString *)title goodsTitle:(NSString *)goodsTitle {
    self.addUserBrand = [FBAPI postWithUrlString:URLUserAddBrand requestDictionary:@{@"title":title} delegate:self];
    [self.addUserBrand startRequestSuccess:^(FBRequest *request, id result) {
        NSString *brandId = [[result valueForKey:@"data"] valueForKey:@"id"];
        [self thn_networkUserAddGoods:goodsTitle brandTitle:title brandId:brandId];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 添加产品
- (void)thn_networkUserAddGoods:(NSString *)title brandTitle:(NSString *)brandTitle brandId:(NSString *)brandId {
    self.userAddRequest = [FBAPI postWithUrlString:URLUserAddGoods requestDictionary:@{@"title":title, @"brand_id":brandId} delegate:self];
    [self.userAddRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSString *userAddGoodsId = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"id"] integerValue]];
        [self addUserGoodsTagWithTitle:[NSString stringWithFormat:@"%@ %@", brandTitle, title]
                                 withPrice:@""
                               withGoodsId:userAddGoodsId];
        [self.goodsTitleData addObject:[NSString stringWithFormat:@"%@ %@", brandTitle, title]];
        [self.goodsIdData addObject:userAddGoodsId];
        [self.goodsTypeData addObject:@"1"];

    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 删除标记的产品
- (void)networkDeleteUserGoods:(NSString *)ids {
    self.deleteUserGoods = [FBAPI getWithUrlString:URLDeleUserGoods requestDictionary:@{@"id":ids} delegate:self];
    [self.deleteUserGoods startRequestSuccess:^(FBRequest *request, id result) {
        [self.goodsIdData removeObject:ids];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    self.filtersImageView.image = self.editFilterImage.image = self.filtersImg;
    
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.top.equalTo(self.view.mas_top).with.offset(45);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.functionView];
    [_functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(_filtersImageView.mas_bottom).with.offset(0);
        make.bottom.equalTo(_footView.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
    
    [self.view addSubview:self.filterValueView];
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = self.footTitleArr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#25272A"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_footView addFootViewButton];
        _footView.delegate = self;
        _footView.clipsToBounds = YES;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0 animations:^{
        self.functionView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
    }];
}

#pragma mark - 底部功能视图
- (UIScrollView *)functionView {
    if (!_functionView) {
        _functionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_HEIGHT -(SCREEN_WIDTH +45))];
        _functionView.contentSize = CGSizeMake(SCREEN_WIDTH * self.footTitleArr.count, 0);
        _functionView.pagingEnabled = YES;
        _functionView.showsHorizontalScrollIndicator = NO;
        _functionView.scrollEnabled = NO;
        
        [_functionView addSubview:self.bottomBtn];
        [_functionView addSubview:self.filtersView];
        [_functionView addSubview:self.adjustView];
    }
    return _functionView;
}

#pragma mark - 标记商品按钮
- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(SCREEN_WIDTH+90))];
        [_bottomBtn setTitle:NSLocalizedString(@"markGoodsBtnTitle", nil) forState:(UIControlStateNormal)];
        [_bottomBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:(UIControlStateNormal)];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomBtn setImage:[UIImage imageNamed:@"ic_touch_app"] forState:(UIControlStateNormal)];
        _bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        [_bottomBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMarkGoodsView:)];
        [_bottomBtn addGestureRecognizer:tap];
    }
    return _bottomBtn;
}

#pragma mark - 调整视图
- (THNAdjustView *)adjustView {
    if (!_adjustView) {
        _adjustView = [[THNAdjustView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *2, SCREEN_HEIGHT-SCREEN_WIDTH-210, SCREEN_WIDTH, 120)];
        _adjustView.delegate = self;
    }
    return _adjustView;
}

- (void)thn_adjustFilterValue:(NSString *)value index:(NSInteger)index {
    self.filterValueView.hidden = NO;
    self.filterValueView.valueTitle.text = value;
    [self.filterValueView thn_setSliderWithType:index filterImage:self.editFilterImage];
    _editFilterType = (FSImageParamType)index;
    _chooseIndex = index;
}

#pragma mark - 调整参数值
- (FSFliterImage *)editFilterImage {
    if (!_editFilterImage) {
        _editFilterImage = [[FSFliterImage alloc] init];
    }
    return _editFilterImage;
}

- (THNFilterValueView *)filterValueView {
    if (!_filterValueView) {
        _filterValueView = [[THNFilterValueView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _filterValueView.hidden = YES;
        _filterValueView.delegate = self;
    }
    return _filterValueView;
}

//  调整中
- (void)thn_changeImageFilterValue:(CGFloat)value {
    self.filtersImageView.image = [self.filterManager randerImageWithProgress:value
                                                                    WithImage:self.editFilterImage.image
                                                           WithImageParamType:_editFilterType];
}

//  取消调整
- (void)thn_cancelChangeFilterValue {
    self.filtersImageView.image = self.editFilterImage.image;
}

//  完成调整
- (void)thn_sureChangeFilterValue:(CGFloat)value {
    [self.editFilterImage updataParamsWithIndex:_chooseIndex WithValue:value];
//    self.editFilterImage.image = self.filtersImg;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH-210, SCREEN_WIDTH, 120)];
        [_filtersView thn_getNeedEditSceneImage:self.filtersImg];
        _filtersView.delegate = self;
    }
    return _filtersView;
}

- (FSImageFilterManager *)filterManager {
    if (!_filterManager) {
        _filterManager = [[FSImageFilterManager alloc] init];
    }
    return _filterManager;
}

#pragma mark 改变滤镜
- (void)thn_chooseFilterWithName:(NSString *)filterName {
    _filterName = filterName;
    UIImage *showFilterImage = [self.filterManager randerImageWithIndex:_filterName WithImage:self.filtersImg];
    self.filtersImageView.image = self.editFilterImage.image = showFilterImage;
    [self.editFilterImage setImageDefaultValue];
}

#pragma mark - 标记产品信息视图
- (THNMarkGoodsView *)markGoodsView {
    if (!_markGoodsView) {
        _markGoodsView = [[THNMarkGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _markGoodsView.delegate = self;
        _markGoodsView.vc = self;
    }
    return _markGoodsView;
}

- (void)mark_GoodsImageAndInfo {
    MarkGoodsViewController *markGoodsVC = [[MarkGoodsViewController alloc] init];
    [self presentViewController:markGoodsVC animated:YES completion:nil];
    markGoodsVC.getImgBlock = ^(NSString * imgUrl, NSString * title, NSString * price, NSString * ids, CGFloat imgW, CGFloat imgH) {
        if (self.goodsIdData.count == 0) {
            _idx = 391;
        }
        [self addMarkGoodsImg:imgUrl withImgW:imgW withImgH:imgH];
        [self.goodsIdData addObject:ids];
        NSString * pri = [NSString stringWithFormat:@"￥%@",price];
        [self addUserGoodsTagWithTitle:title withPrice:pri withGoodsId:ids];
        
        [self.goodsTitleData addObject:title];
        [self.goodsPriceData addObject:price];
        [self.goodsTypeData addObject:@"2"];
        
        NSMutableDictionary * tagDataDict = [NSMutableDictionary dictionary];
        [tagDataDict setObject:title forKey:@"title"];
        [tagDataDict setObject:price forKey:@"price"];
        if (imgUrl.length > 0) {
            [tagDataDict setObject:imgUrl forKey:@"img"];
        }
        [self.userAddGoodsMarr addObject:tagDataDict];
    };
    
}

#pragma mark - 创建一个标签
- (void)addUserGoodsTagWithTitle:(NSString *)title withPrice:(NSString *)price withGoodsId:(NSString *)ids {
    _idx += 1;
    
    UserGoodsTag *tag = [[UserGoodsTag alloc] init];
    tag.isMove = YES;
    tag.tag = _idx;
    tag.index = _idx - 392;
    tag.goodsId = ids;
    tag.delegate = self;
    [tag userTag_SetGoodsInfo:title];
    
    [self.filtersImageView addSubview:tag];
    [self.tagBtnMarr addObject:tag];
    
    self.markGoodsView.transform = CGAffineTransformMakeScale(1, 1);
    self.markGoodsView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.markGoodsView.alpha = 0;
        self.markGoodsView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self.markGoodsView removeFromSuperview];
    }];
    
    [self getNowAddGoodsInfoNum:self.tagBtnMarr.count];
}

#pragma mark - 标记一个产品图片
- (void)addMarkGoodsImg:(NSString *)imgUrl withImgW:(CGFloat)imgW withImgH:(CGFloat)imgH {
    if (imgUrl.length > 0) {
        FBStickersContainer * sticker = [[FBStickersContainer alloc] initWithFrame:CGRectMake(100, 100, imgW/3, imgH/3)];
        [sticker setupSticker:imgUrl];
        sticker.delegate = self;
        [self.filtersImageView addSubview:sticker];
        [self.stickersContainer addObject:sticker];
    }
    
    for (UserGoodsTag * userTag in self.tagBtnMarr) {
        [self.view bringSubviewToFront:userTag];
    }
}

#pragma mark - 删除标记的产品
- (void)didRemoveStickerContainer:(FBStickersContainer *)container {
    [self.stickersContainer removeObject:container];
}

#pragma mark 删除标签
- (void)delegateThisTagBtn:(UserGoodsTag *)tag {
    [self.tagBtnMarr removeObject:tag];
    
    [self getNowAddGoodsInfoNum:self.tagBtnMarr.count];
    
    [self.goodsIdData removeObject:tag.goodsId];
    [self.goodsTitleData removeObject:tag.title.text];
    [self.goodsPriceData removeObject:tag.price.text];
}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] init];
        _filtersImageView.userInteractionEnabled = YES;
        _filtersImageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMarkGoodsView:)];
        [_filtersImageView addGestureRecognizer:tap];
    }
    return _filtersImageView;
}

- (void)showMarkGoodsView:(UITapGestureRecognizer *)tap {
    self.markGoodsView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.markGoodsView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.markGoodsView.alpha = 1;
        self.markGoodsView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    [self.view addSubview:self.markGoodsView];
    
    __weak __typeof(self)weakSelf = self;
    /**
     *  用户自定义添加的品牌
     */
    weakSelf.markGoodsView.addBrandInfoDoneBlock = ^(NSString *brand, NSString *brandId, NSString *goods, NSString *goodsId) {
        if (goodsId.length > 1 && brandId.length > 1) {
            [weakSelf addUserGoodsTagWithTitle:[NSString stringWithFormat:@"%@ %@", brand, goods]
                                     withPrice:@""
                                   withGoodsId:goodsId];
            [weakSelf.goodsTitleData addObject:[NSString stringWithFormat:@"%@ %@", brand, goods]];
            [weakSelf.goodsIdData addObject:goodsId];
            [weakSelf.goodsTypeData addObject:@"2"];
            
        } else if (brandId.length == 0) {
            [weakSelf thn_networkUserAddBrand:brand goodsTitle:goods];
        
        } else if (brandId.length > 0) {
            [weakSelf thn_networkUserAddGoods:goods brandTitle:brand brandId:brandId];
        }
    };
    
    /**
     *  用户自定义添加的产品
     */
    weakSelf.markGoodsView.addGoodsInfoDoneBlock = ^(NSString *goods, NSString *goodsId) {
        if (goodsId.length > 1) {
            [weakSelf addUserGoodsTagWithTitle:[NSString stringWithFormat:@"%@", goods]
                                     withPrice:@""
                                   withGoodsId:goodsId];
            [weakSelf.goodsTitleData addObject:[NSString stringWithFormat:@"%@", goods]];
            [weakSelf.goodsIdData addObject:goodsId];
            [weakSelf.goodsTypeData addObject:@"2"];
        
        } else {
            [weakSelf thn_networkUserAddGoods:goods brandTitle:@"" brandId:@""];
        }
    };
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    [self addNavViewTitle:NSLocalizedString(@"marker", nil)];
    [self addBackButton:@"icon_back_white"];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
        if (self.goodsIdData.count > 3) {
            [SVProgressHUD showInfoWithStatus:@"最多标记三个产品信息哦～"];
            
        } else if (self.goodsIdData.count <= 3) {
            NSMutableArray *originX = [NSMutableArray array];
            NSMutableArray *originY = [NSMutableArray array];
            NSMutableArray *loc = [NSMutableArray array];
            for (UserGoodsTag * btn in self.tagBtnMarr) {
                if (btn.isFlip == 1) {
                    [originX addObject:[NSString stringWithFormat:@"%f", (CGRectGetMinX(btn.frame) + 44)/SCREEN_WIDTH]];
                } else {
                    [originX addObject:[NSString stringWithFormat:@"%f", (CGRectGetMaxX(btn.frame) - 18)/SCREEN_WIDTH]];
                }
                [originY addObject:[NSString stringWithFormat:@"%f", CGRectGetMaxY(btn.frame)/SCREEN_WIDTH]];
                [loc addObject:[NSString stringWithFormat:@"%zi", btn.isFlip + 1]];
            }
    
            ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
            releaseVC.actionId = self.actionId;
            releaseVC.activeTitle = self.activeTitle;
            releaseVC.bgImg = [self generateImage:self.filtersImageView];
            releaseVC.goodsType = self.goodsTypeData;
            releaseVC.goodsTitle = self.goodsTitleData;
            releaseVC.goodsId = self.goodsIdData;
            releaseVC.goodsX = originX;
            releaseVC.goodsY = originY;
            releaseVC.goodsLoc = loc;
            releaseVC.domainId = self.domainId;
            [releaseVC thn_releaseTheSceneType:0 withSceneId:nil withSceneData:nil];
            [self.navigationController pushViewController:releaseVC animated:YES];
        }
}

#pragma mark - 计算当前添加产品信息数量
- (void)getNowAddGoodsInfoNum:(NSInteger)count {
    if (count == 0) {
        [self.bottomBtn setTitle:NSLocalizedString(@"markGoodsBtnTitle", nil) forState:(UIControlStateNormal)];
        
    } else if (count >= 3) {
        [self mark_GoodsImageAndInfo];
        [self.bottomBtn setTitle:NSLocalizedString(@"markGoodsOver", nil) forState:(UIControlStateNormal)];
        
    } else {
        [self.bottomBtn setTitle:[NSString stringWithFormat:@"%@ %zi %@", NSLocalizedString(@"canAddGoods", nil),
                                  (3 - count),
                                  NSLocalizedString(@"addGoodsNum", nil)]
                        forState:(UIControlStateNormal)];
    }

}

#pragma mark - 合成图片
- (UIImage *)generateImage:(UIImageView *)imageView {
    CGSize size = imageView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
    CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip, 0, -size.height);
    CGContextConcatCTM(context, flipThenShift);
    CGContextDrawImage(context, imageView.bounds, imageView.image.CGImage);
    CGContextRestoreGState(context);
    [imageView.image drawInRect:imageView.bounds];
    
    //  合成标记的商品图
    for (FBStickersContainer * container in self.stickersContainer) {
        CGContextSaveGState(context);
        FBSticker *sticker = [container generateSticker];
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(sticker.translateCenter.x, sticker.translateCenter.y);
        CGAffineTransform rotateAfterTranslate = CGAffineTransformRotate(translateToCenter, sticker.rotateAngle);
        CGContextConcatCTM(context, rotateAfterTranslate);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(-sticker.size.width/2, -sticker.size.height/2, sticker.size.width, sticker.size.height), sticker.image.CGImage);
        CGContextRestoreGState(context);
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

#pragma mark -
- (NSMutableArray *)tagBtnMarr {
    if (!_tagBtnMarr) {
        _tagBtnMarr = [NSMutableArray array];
    }
    return _tagBtnMarr;
}

- (NSMutableDictionary *)userAddGoodsDict {
    if (!_userAddGoodsDict) {
        _userAddGoodsDict = [NSMutableDictionary dictionary];
    }
    return _userAddGoodsDict;
}

- (NSMutableArray *)userAddGoodsMarr {
    if (!_userAddGoodsMarr) {
        _userAddGoodsMarr = [NSMutableArray array];
    }
    return _userAddGoodsMarr;
}

- (NSMutableArray *)goodsIdData {
    if (!_goodsIdData) {
        _goodsIdData = [NSMutableArray array];
    }
    return _goodsIdData;
}

- (NSMutableArray *)goodsTitleData {
    if (!_goodsTitleData) {
        _goodsTitleData = [NSMutableArray array];
    }
    return _goodsTitleData;
}

- (NSMutableArray *)goodsPriceData {
    if (!_goodsPriceData) {
        _goodsPriceData = [NSMutableArray array];
    }
    return _goodsPriceData;
}

- (NSMutableArray *)goodsTypeData {
    if (!_goodsTypeData) {
        _goodsTypeData = [NSMutableArray array];
    }
    return _goodsTypeData;
}

- (NSMutableArray *)stickersContainer {
    if (!_stickersContainer) {
        _stickersContainer = [NSMutableArray array];
    }
    return _stickersContainer;
}

@end
