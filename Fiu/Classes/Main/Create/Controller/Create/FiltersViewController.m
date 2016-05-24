//
//  FiltersViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"
#import "MarkGoodsViewController.h"
#import "AddUrlViewController.h"
#import "FBFilters.h"
#import "UserGoodsTag.h"
#import "FBStickersContainer.h"

static NSString *const URLDeleUserGoods = @"/scene_product/deleted";
static NSString *const URLUserAddGoods = @"/scene_product/add";

@interface FiltersViewController () <FBFootViewDelegate, FBUserGoodsTagDelegaet, FBStickerContainerDelegate> {
    UserGoodsTag    * goodsTag;
    NSString        * _title;
    NSString        * _price;
    NSString        * _imgUrl;
    NSInteger         _idx;
    NSInteger         _canDelete;
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

@implementation FiltersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setFirstAppStart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setFiltersControllerUI];
    
    [self setNotification];
    
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

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        make.top.equalTo(self.view.mas_top).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.filtersView];
    
    //  判断是情景/场景
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"filtersVcTitle", nil)];
    
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"filterVcTitle", nil)];
        [self.footView removeFromSuperview];
        CGRect filtersViewRect = _filtersView.frame;
        filtersViewRect = CGRectMake(0, SCREEN_HEIGHT - 120, SCREEN_WIDTH, 120);
        _filtersView.frame = filtersViewRect;
    }

}

#pragma mark - 底部的工具栏
- (FBFootView *)footView {
    if (!_footView) {
        _footView = [[FBFootView alloc] init];
        NSArray * titleArr = [[NSArray alloc] initWithObjects:NSLocalizedString(@"marker", nil), NSLocalizedString(@"addUrl", nil), NSLocalizedString(@"filter", nil), nil];
        _footView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
        _footView.titleArr = titleArr;
        _footView.titleFontSize = Font_GroupHeader;
        _footView.titleNormalColor = [UIColor whiteColor];
        _footView.titleSeletedColor = [UIColor whiteColor];
        [_footView addFootViewButton];
        _footView.delegate = self;
    }
    return _footView;
}

- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    MarkGoodsViewController * markGoodsVC = [[MarkGoodsViewController alloc] init];
    AddUrlViewController * addUrlVC = [[AddUrlViewController alloc] init];
    
    if (index == 0) {
        [self changeFiltersFrame];
        
        [self presentViewController:markGoodsVC animated:YES completion:nil];
        markGoodsVC.getImgBlock = ^(NSString * imgUrl, NSString * title, NSString * price, NSString * ids) {
            if (self.goodsIdData.count == 0) {
                _idx = 391;
            }
            [self addMarkGoodsImg:imgUrl];
            [self.goodsIdData addObject:ids];
            NSString * pri = [NSString stringWithFormat:@"￥%@",price];
            _canDelete = 0;
            [self addUserGoodsTagWithTitle:title withPrice:pri];
            
            [self.goodsTitleData addObject:title];
            [self.goodsPriceData addObject:price];
            
            NSMutableDictionary * tagDataDict = [NSMutableDictionary dictionary];
            [tagDataDict setObject:title forKey:@"title"];
            [tagDataDict setObject:price forKey:@"price"];
            [tagDataDict setObject:imgUrl forKey:@"img"];
            [self.userAddGoodsMarr addObject:tagDataDict];
        };
        
    } else if (index == 1) {
        [self changeFiltersFrame];
        
        [self presentViewController:addUrlVC animated:YES completion:nil];
        addUrlVC.findGodosBlock = ^(NSString * title, NSString * price, NSString * ids) {
            if (self.goodsIdData.count == 0) {
                _idx = 391;
            }
            [self.goodsIdData addObject:ids];
            _canDelete = 1;
            [self addUserGoodsTagWithTitle:title withPrice:price];
        };
        
        addUrlVC.userAddGoodsBlock = ^(NSDictionary * dict) {
            _title = [dict valueForKey:@"title"];
            _price = [dict valueForKey:@"sale_price"];
            _imgUrl = [dict valueForKey:@"cover_url"];
            
            [self.goodsTitleData addObject:_title];
            [self.goodsPriceData addObject:_price];
            
            NSMutableDictionary * tagDataDict = [NSMutableDictionary dictionary];
            [tagDataDict setObject:_title forKey:@"title"];
            [tagDataDict setObject:_price forKey:@"price"];
            [tagDataDict setObject:_imgUrl forKey:@"img"];
            [self.userAddGoodsMarr addObject:tagDataDict];
        };
        
    } else if (index == 2) {
        CGRect filtersViewRect = _filtersView.frame;
        filtersViewRect = CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120);
        [UIView animateWithDuration:.2 animations:^{
            _filtersView.frame = filtersViewRect;
        }];
        [self.view bringSubviewToFront:self.filtersView];
        [self.view bringSubviewToFront:self.footView];
    }
}

#pragma mark - 创建一个标签
- (void)addUserGoodsTagWithTitle:(NSString *)title withPrice:(NSString *)price {
    _idx += 1;
    int tagX = (arc4random() % 4);
    int tagY = (arc4random() % 2) + 10;
    
    UserGoodsTag * tag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(tagX * 50, tagY * 20, 175, 32)];
    tag.title.text = title;
    tag.price.text = price;
    tag.isMove = YES;
    tag.tag = _idx;
    tag.index = _idx - 392;
    tag.delegate = self;
    
    if (_canDelete == 1) {
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeGoodsData:)];
        [tag addGestureRecognizer:tapGesture];
    }

    [self.view addSubview:tag];
    
    [self.tagBtnMarr addObject:tag];
}

#pragma mark 删除标签
- (void)delegateThisTagBtn:(NSInteger)index {
    if (_canDelete == 1) {
        [self networkDeleteUserGoods:self.goodsIdData[index]];
    } else if (_canDelete == 0) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ %@ , %zi", self.goodsIdData, index);
        [self.goodsIdData removeObject:self.goodsIdData[index]];
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＊＊＊＊＊ %@, %zi", self.goodsIdData, index);
    }
}

#pragma mark 点击编辑产品信息
- (void)showChangeGoodsData:(UIGestureRecognizer *)tap {
    self.seleIndex = tap.view.tag - 392;
    self.userGoodsTag = self.tagBtnMarr[self.seleIndex];
    self.changeGoodsView.goodsTitle.text = [self.userAddGoodsMarr valueForKey:@"title"][self.seleIndex];
    self.changeGoodsView.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[self.userAddGoodsMarr valueForKey:@"price"][self.seleIndex]];
    [self.changeGoodsView.goodsImg downloadImage:[self.userAddGoodsMarr valueForKey:@"img"][self.seleIndex] place:[UIImage imageNamed:@""]];
    [self.view addSubview:self.changeGoodsView];
}

#pragma mark - 标记一个产品图片
- (void)addMarkGoodsImg:(NSString *)imgUrl {
    FBStickersContainer * sticker = [[FBStickersContainer alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [sticker setupSticker:imgUrl];
    sticker.delegate = self;
    [self.view addSubview:sticker];
    [self.stickersContainer addObject:sticker];
    
    for (UserGoodsTag * userTag in self.tagBtnMarr) {
        [self.view bringSubviewToFront:userTag];
    }
}

#pragma mark 删除标记的产品
- (void)didRemoveStickerContainer:(FBStickersContainer *)container {
    [self.stickersContainer removeObject:container];
}

#pragma mark - 编辑产品信息视图
- (ChangeAddUrlView *)changeGoodsView {
    if (!_changeGoodsView) {
        _changeGoodsView = [[ChangeAddUrlView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_changeGoodsView.sure addTarget:self action:@selector(sureChange) forControlEvents:(UIControlEventTouchUpInside)];
        [_changeGoodsView.dele addTarget:self action:@selector(deleteTag) forControlEvents:(UIControlEventTouchUpInside)];
//        [_changeGoodsView.url addTarget:self action:@selector(urlChange) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeGoodsView;
}

//  修改标签
- (void)sureChange {
    if (_canDelete == YES) {
        [self.goodsTitleData removeObjectAtIndex:self.seleIndex];
        [self.goodsPriceData removeObjectAtIndex:self.seleIndex];
        
        self.userGoodsTag.title.text = self.changeGoodsView.goodsTitle.text;
        if ([self.changeGoodsView.goodsPrice.text containsString:@"￥"]) {
            self.userGoodsTag.price.text = [NSString stringWithFormat:@"%@", self.changeGoodsView.goodsPrice.text];
        } else {
            self.userGoodsTag.price.text = [NSString stringWithFormat:@"￥%@", self.changeGoodsView.goodsPrice.text];
        }
        
        [self.changeGoodsView removeFromSuperview];
        
        [self.userAddGoodsMarr[self.seleIndex] setObject:self.changeGoodsView.goodsTitle.text forKey:@"title"];
        [self.userAddGoodsMarr[self.seleIndex] setObject:self.changeGoodsView.goodsPrice.text forKey:@"price"];
        
        [self.goodsTitleData addObject:self.userGoodsTag.title.text];
        [self.goodsPriceData addObject:self.userGoodsTag.price.text];
    }
}

//  删除标签
- (void)deleteTag {
    if (_canDelete == 1) {
        [self delegateThisTagBtn:self.seleIndex];
        [self networkDeleteUserGoods:self.goodsIdData[self.seleIndex]];
        [self.changeGoodsView removeFromSuperview];
        UIButton * btn = [[UIButton alloc] init];
        btn = self.tagBtnMarr[self.seleIndex];
        [btn removeFromSuperview];
    }
}

//  修改产品链接
//- (void)urlChange {
//    [self delegateThisTagBtn:self.seleIndex];
//    [self networkDeleteUserGoods:self.goodsIdData[self.seleIndex]];
//    [self.changeGoodsView removeFromSuperview];
//    [self buttonDidSeletedWithIndex:1];
//    UIButton * btn = [[UIButton alloc] init];
//    btn = self.tagBtnMarr[self.seleIndex];
//    [btn removeFromSuperview];
//}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] init];
    }
    return _filtersImageView;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120)];
    }
    return _filtersView;
}

#pragma mark - 使滤镜视图消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self changeFiltersFrame];
}

- (void)changeFiltersFrame {
    CGRect filtersViewRect = _filtersView.frame;
    filtersViewRect = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120);
    [UIView animateWithDuration:.2 animations:^{
        _filtersView.frame = filtersViewRect;
    }];
}


#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    [self addBackButton:@"icon_back_white"];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
    
    if ([self.createType isEqualToString:@"scene"]) {
        if (self.goodsIdData.count > 3) {
            [SVProgressHUD showInfoWithStatus:@"最多添加三个商品的链接"];
            
        } else if (self.goodsIdData.count == 0) {
            [SVProgressHUD showInfoWithStatus:@"至少添加一个商品的链接"];
            
        } else if (self.goodsIdData.count > 0 && self.goodsIdData.count <= 3) {
            NSMutableArray * originX = [NSMutableArray array];
            NSMutableArray * originY = [NSMutableArray array];
            for (UserGoodsTag * btn in self.tagBtnMarr) {
                [originX addObject:[NSString stringWithFormat:@"%f", btn.frame.origin.x / SCREEN_WIDTH]];
                [originY addObject:[NSString stringWithFormat:@"%f", btn.frame.origin.y / SCREEN_HEIGHT]];
            }
            
            NSMutableArray * priceMarr = [NSMutableArray array];
            NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"￥"];
            for (NSString * str in self.goodsPriceData) {
                NSString * price = [str stringByTrimmingCharactersInSet:set];
                [priceMarr addObject:price];
            }
            
            NSString * goodsPrice = [priceMarr componentsJoinedByString:@","];
            NSString * goodsId = [self.goodsIdData componentsJoinedByString:@","];
            NSString * goodsTitle = [self.goodsTitleData componentsJoinedByString:@","];
            NSString * btnOriginX = [originX componentsJoinedByString:@","];
            NSString * btnOriginY = [originY componentsJoinedByString:@","];
            
            UIImage * goodsImg = [self generateImage:self.filtersImageView];
            
            releaseVC.locationArr = self.locationArr;
            releaseVC.scenceView.imageView.image = goodsImg;
            releaseVC.createType = self.createType;
            releaseVC.fSceneId = self.fSceneId;
            releaseVC.fSceneTitle = self.fSceneTitle;
            releaseVC.goodsTitle = goodsTitle;
            releaseVC.goodsPrice = goodsPrice;
            releaseVC.goodsId = goodsId;
            releaseVC.goodsX = btnOriginX;
            releaseVC.goodsY = btnOriginY;
            [self.navigationController pushViewController:releaseVC animated:YES];
        }
    
    } else if ([self.createType isEqualToString:@"fScene"]) {
        releaseVC.locationArr = self.locationArr;
        releaseVC.scenceView.imageView.image = self.filtersImageView.image;
        releaseVC.createType = self.createType;
        [self.navigationController pushViewController:releaseVC animated:YES];
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


#pragma mark - 接收消息通知
- (void)setNotification {
    //  from "FiltersView.m"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFilter:) name:@"fitlerName" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fitlerName" object:nil];
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
