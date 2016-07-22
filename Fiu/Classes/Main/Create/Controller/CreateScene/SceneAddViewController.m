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
#import "UserGoodsTag.h"
#import "FBStickersContainer.h"
#import "FiltersViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
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
    
    [self.view addSubview:self.bottomBtn];
    
//    [self.view addSubview:self.footView];
//    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
//        make.centerX.equalTo(self.view);
//    }];
}

#pragma mark - 底部的工具栏
- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        [_bottomBtn setTitle:NSLocalizedString(@"markGoodsBtnTitle", nil) forState:(UIControlStateNormal)];
        [_bottomBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:(UIControlStateNormal)];
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomBtn setImage:[UIImage imageNamed:@"ic_touch_app"] forState:(UIControlStateNormal)];
        _bottomBtn.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        [_bottomBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bottomBtn;
}

- (void)bottomBtnClick {
    [self.view addSubview:self.markView];
}

- (MarkGoodsView *)markView {
    if (!_markView) {
        _markView = [[MarkGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_markView.goodsBtn addTarget:self action:@selector(markGoodsClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_markView.urlBtn addTarget:self action:@selector(markUrlClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _markView;
}

- (void)markGoodsClick {
    MarkGoodsViewController * markGoodsVC = [[MarkGoodsViewController alloc] init];
    [self presentViewController:markGoodsVC animated:YES completion:nil];
    markGoodsVC.getImgBlock = ^(NSString * imgUrl, NSString * title, NSString * price, NSString * ids, CGFloat imgW, CGFloat imgH) {
        if (self.goodsIdData.count == 0) {
            _idx = 391;
        }
        
        [self addMarkGoodsImg:imgUrl withImgW:imgW withImgH:imgH];
        [self.goodsIdData addObject:ids];
        NSString * pri = [NSString stringWithFormat:@"￥%@",price];
        [self addUserGoodsTagWithTitle:title withPrice:pri withType:0 withGoodsId:ids];
        
        [self.goodsTitleData addObject:title];
        [self.goodsPriceData addObject:price];
        
        NSMutableDictionary * tagDataDict = [NSMutableDictionary dictionary];
        [tagDataDict setObject:title forKey:@"title"];
        [tagDataDict setObject:price forKey:@"price"];
        [tagDataDict setObject:imgUrl forKey:@"img"];
        [self.userAddGoodsMarr addObject:tagDataDict];
    };

}

- (void)markUrlClick {
    AddUrlViewController * addUrlVC = [[AddUrlViewController alloc] init];
    [self presentViewController:addUrlVC animated:YES completion:nil];
    addUrlVC.findGodosBlock = ^(NSString * title, NSString * price, NSString * ids) {
        if (self.goodsIdData.count == 0) {
            _idx = 391;
        }
        [self.goodsIdData addObject:ids];
        [self addUserGoodsTagWithTitle:title withPrice:price withType:1 withGoodsId:ids];
        _urlGoods = YES;
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

}

#pragma mark - 创建一个标签
- (void)addUserGoodsTagWithTitle:(NSString *)title withPrice:(NSString *)price withType:(NSInteger)type withGoodsId:(NSString *)ids {
    _idx += 1;
    int tagX = (arc4random() % 4) * 40;
    int tagY = ((arc4random() % 2) + 10) * 25;
    
    UserGoodsTag * tag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(tagX, tagY, 175, 32)];
    tag.title.text = title;
    tag.price.text = price;
    tag.isMove = YES;
    tag.tag = _idx;
    tag.index = _idx - 392;
    tag.type = type;
    tag.goodsId = ids;
    tag.delegate = self;
    
    if (type == 1) {
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeGoodsData:)];
        [tag addGestureRecognizer:tapGesture];
    }
    
    [self.view addSubview:tag];
    
    [self.tagBtnMarr addObject:tag];
    [self.markView removeFromSuperview];
}

#pragma mark 删除标签
- (void)delegateThisTagBtn:(NSInteger)index {
    UserGoodsTag * userTag = [[UserGoodsTag alloc] init];
    userTag = self.tagBtnMarr[index];
    [self.tagBtnMarr removeObject:userTag];
    
    if (userTag.type == 1) {
        [self networkDeleteUserGoods:userTag.goodsId];
    } else if (userTag.type == 0) {
        [self.goodsIdData removeObject:userTag.goodsId];
        [self.goodsTitleData removeObject:userTag.title.text];
        [self.goodsPriceData removeObject:userTag.price.text];
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
- (void)addMarkGoodsImg:(NSString *)imgUrl withImgW:(CGFloat)imgW withImgH:(CGFloat)imgH {
    FBStickersContainer * sticker = [[FBStickersContainer alloc] initWithFrame:CGRectMake(100, 100, imgW/4, imgH/4)];
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
    }
    return _changeGoodsView;
}

#pragma mark - 修改标签
- (void)sureChange {
    if (_urlGoods == YES) {
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

#pragma mark - 删除标签
- (void)deleteTag {
    [self delegateThisTagBtn:self.seleIndex];
    [self.changeGoodsView removeFromSuperview];
}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] init];
    }
    return _filtersImageView;
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    [self addNavViewTitle:NSLocalizedString(@"marker", nil)];
    [self addBackButton:@"icon_back_white"];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
        if (self.goodsIdData.count > 3) {
            [SVProgressHUD showInfoWithStatus:@"最多添加三个商品的链接"];
            
        } else if (self.goodsIdData.count <= 3) {
            NSMutableArray * originX = [NSMutableArray array];
            NSMutableArray * originY = [NSMutableArray array];
            for (UserGoodsTag * btn in self.tagBtnMarr) {
                [originX addObject:[NSString stringWithFormat:@"%f", btn.frame.origin.x / SCREEN_WIDTH]];
                [originY addObject:[NSString stringWithFormat:@"%f", (btn.frame.origin.y - 50) / SCREEN_HEIGHT]];
            }
        
            NSMutableArray * priceMarr = [NSMutableArray array];
            NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"￥"];
            for (NSString * str in self.goodsPriceData) {
                NSString * price = [str stringByTrimmingCharactersInSet:set];
                [priceMarr addObject:price];
            }

            UIImage * goodsImg = [self generateImage:self.filtersImageView];
            
            FiltersViewController * filtersVC = [[FiltersViewController alloc] init];
            filtersVC.createType = self.createType;
            filtersVC.locationArr = self.locationArr;
            filtersVC.filtersImg = goodsImg;
            filtersVC.fSceneId = self.fSceneId;
            filtersVC.fSceneTitle = self.fSceneTitle;
            filtersVC.goodsTitle = self.goodsTitleData;
            filtersVC.goodsPrice = priceMarr;
            filtersVC.goodsId = self.goodsIdData;
            filtersVC.goodsX = originX;
            filtersVC.goodsY = originY;
            
            [self.navigationController pushViewController:filtersVC animated:YES];
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
