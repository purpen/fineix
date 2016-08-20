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
#import "AddUrlViewController.h"
#import "FBFilters.h"
#import "FBStickersContainer.h"

static NSString *const URLDeleUserGoods = @"/scene_product/deleted";
static NSString *const URLUserAddGoods = @"/scene_product/add";

@interface SceneAddViewController () <FBFootViewDelegate, FBUserGoodsTagDelegaet, FBStickerContainerDelegate> {
    UserGoodsTag    * goodsTag;
    NSString        * _title;
    NSString        * _price;
    NSString        * _imgUrl;
    NSInteger         _idx;
    BOOL              _urlGoods;
}

@pro_strong UserGoodsTag           *   userGoodsTag;
@pro_strong NSMutableDictionary    *   userAddGoodsDict;
@pro_strong NSMutableArray         *   tagBtnMarr;
@pro_strong NSMutableArray         *   userAddGoodsMarr;
@pro_strong NSMutableArray         *   goodsIdData;
@pro_strong NSMutableArray         *   goodsTitleData;
@pro_strong NSMutableArray         *   goodsPriceData;
@pro_strong NSMutableArray         *   stickersContainer;

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

#pragma mark - 应用第一次打开，加载操作指示图
- (void)setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"flitersLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"flitersLaunch"];
        [self setGuideImgForVC:@"Guide_stamp product"];
    }
}

#pragma mark - 网络请求
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
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.top.equalTo(self.view.mas_top).with.offset(45);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomBtn];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-(SCREEN_WIDTH+90)));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-45);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
    
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.filtersView];
    [_filtersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 120));
        make.top.equalTo(self.view.mas_top).with.offset(SCREEN_WIDTH+90);
        make.left.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH);
    }];
    
    [self setNotification];
}

#pragma mark - 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:NSLocalizedString(@"marker", nil), NSLocalizedString(@"filter", nil), nil];
        _footView = [[FBFootView alloc] init];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleArr = arr;
        _footView.titleFontSize = Font_ControllerTitle;
        _footView.btnBgColor = [UIColor colorWithHexString:@"#222222"];
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor colorWithHexString:fineixColor alpha:1];
        [_footView addFootViewButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        [self showFiltersViewFrame:0];
    } else if (index == 0) {
        [self showFiltersViewFrame:1];
    }
}

- (void)showFiltersViewFrame:(NSInteger)index {
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:10.0f
          initialSpringVelocity:5.0f
                        options:(UIViewAnimationOptionOverrideInheritedDuration)
                     animations:^{
        [self.filtersView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH * index);
        }];
        [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH * (index-1));
        }];
                         
        [self.view layoutIfNeeded];
                         
    } completion:nil];
}

#pragma mark - 标记视图
- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        [_bottomBtn setTitle:NSLocalizedString(@"markGoodsBtnTitle", nil) forState:(UIControlStateNormal)];
        [_bottomBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _bottomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [_bottomBtn setImage:[UIImage imageNamed:@"ic_touch_app"] forState:(UIControlStateNormal)];
        _bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        [_bottomBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
    }
    return _bottomBtn;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] init];
    }
    return _filtersView;
}

#pragma mark 接收消息通知
- (void)setNotification {
    //  from "FiltersView.m"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFilter:) name:@"fitlerName" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fitlerName" object:nil];
}

#pragma mark 改变滤镜
- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
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
        
        NSMutableDictionary * tagDataDict = [NSMutableDictionary dictionary];
        [tagDataDict setObject:title forKey:@"title"];
        [tagDataDict setObject:price forKey:@"price"];
        [tagDataDict setObject:imgUrl forKey:@"img"];
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
    FBStickersContainer * sticker = [[FBStickersContainer alloc] initWithFrame:CGRectMake(100, 100, imgW/5, imgH/5)];
    [sticker setupSticker:imgUrl];
    sticker.delegate = self;
    [self.filtersImageView addSubview:sticker];
    [self.stickersContainer addObject:sticker];
    
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
    
    /**
     *  用户自定义添加的产品
     */
    __weak __typeof(self)weakSelf = self;
    weakSelf.markGoodsView.addBrandInfoDoneBlock = ^(NSString *brand, NSString *goods) {
        weakSelf.addUserGoods = [FBAPI getWithUrlString:URLUserAddGoods requestDictionary:@{@"title":goods} delegate:self];
        [weakSelf.addUserGoods startRequestSuccess:^(FBRequest *request, id result) {
            NSString *userAddGoodsId = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"id"] integerValue]];
            [weakSelf addUserGoodsTagWithTitle:[NSString stringWithFormat:@"%@ %@", brand, goods]
                                     withPrice:@""
                                   withGoodsId:userAddGoodsId];
            [weakSelf.goodsTitleData addObject:[NSString stringWithFormat:@"%@ %@", brand, goods]];
            [weakSelf.goodsIdData addObject:userAddGoodsId];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    };
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor blackColor];
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
            releaseVC.bgImg = [self generateImage:self.filtersImageView];
            releaseVC.goodsTitle = self.goodsTitleData;
            releaseVC.goodsId = self.goodsIdData;
            releaseVC.goodsX = originX;
            releaseVC.goodsY = originY;
            releaseVC.goodsLoc = loc;
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
    CGAffineTransform flip = CGAffineTransformMakeScale(1.0, - 1.0);
    CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip, 0, -size.height);
    CGContextConcatCTM(context, flipThenShift);
    CGContextDrawImage(context, imageView.bounds, imageView.image.CGImage);
    CGContextRestoreGState(context);
    for (FBStickersContainer * container in self.stickersContainer) {
        CGContextSaveGState(context);
        FBSticker * sticker = [container generateSticker];
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(sticker.translateCenter.x, sticker.translateCenter.y - (sticker.translateCenter.y / 8));
        CGAffineTransform rotateAfterTranslate = CGAffineTransformRotate(translateToCenter, sticker.rotateAngle);
        CGContextConcatCTM(context, rotateAfterTranslate);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(-sticker.size.width/2, -sticker.size.height/2, sticker.size.width, sticker.size.height), sticker.image.CGImage);
        CGContextRestoreGState(context);
    }
    
    //  返回绘制的新图形
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
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

- (NSMutableArray *)stickersContainer {
    if (!_stickersContainer) {
        _stickersContainer = [NSMutableArray array];
    }
    return _stickersContainer;
}

@end
