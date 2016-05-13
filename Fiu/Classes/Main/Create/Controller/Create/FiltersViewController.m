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

@interface FiltersViewController () <FBFootViewDelegate, FBUserGoodsTagDelegaet> {
    UserGoodsTag    * goodsTag;
    NSString        * _title;
    NSString        * _price;
    NSString        * _imgUrl;
    NSInteger         _idx;
}

@pro_strong UserGoodsTag           *   userGoodsTag;
@pro_strong NSMutableDictionary    *   userAddGoodsDict;
@pro_strong NSMutableArray         *   tagBtnMarr;
@pro_strong NSMutableArray         *   userAddGoodsMarr;
@pro_strong NSMutableArray         *   goodsIdData;
@pro_strong NSMutableArray         *   goodsTitleData;
@pro_strong NSMutableArray         *   goodsPriceData;

@end

@implementation FiltersViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setFiltersControllerUI];
    
    [self setNotification];
    
    _idx = 391;
}

#pragma mark - 网络请求
#pragma mark 删除标记的产品
- (void)networkDeleteUserGoods:(NSString *)ids {
    self.deleteUserGoods = [FBAPI getWithUrlString:URLDeleUserGoods requestDictionary:@{@"id":ids} delegate:self];
    [self.deleteUserGoods startRequestSuccess:^(FBRequest *request, id result) {
        [self.goodsIdData removeObject:ids];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    NSLog(@"/n＝＝＝＝＝＝＝＝ 创建的类型：%@ ＝＝＝＝＝＝＝＝＝＝/n", self.createType);
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    [_filtersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.85, SCREEN_HEIGHT - 100));
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
        _footView.backgroundColor = [UIColor blackColor];
        _footView.titleArr = titleArr;
        _footView.titleFontSize = Font_GroupHeader;
        _footView.btnBgColor = [UIColor blackColor];
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
        [self presentViewController:markGoodsVC animated:YES completion:nil];
        markGoodsVC.getImgBlock = ^(NSString * imgUrl) {
            [self addMarkGoodsImg:imgUrl];
        };
        
    } else if (index == 1) {
        [self presentViewController:addUrlVC animated:YES completion:nil];
        addUrlVC.findGodosBlock = ^(NSString * title, NSString * price, NSString * ids) {
            [self.goodsIdData addObject:ids];
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
        
            NSLog(@"＝＝＝＝＝＝ 用户添加的商品标签信息：%@", self.userAddGoodsMarr);
            
        };
        
    } else if (index == 2) {
        CGRect filtersViewRect = _filtersView.frame;
        filtersViewRect = CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120);
        [UIView animateWithDuration:.2 animations:^{
            _filtersView.frame = filtersViewRect;
        }];
    }
}

#pragma mark - 创建一个标签
- (void)addUserGoodsTagWithTitle:(NSString *)title withPrice:(NSString *)price {
    _idx += 1;
    int tagX = (arc4random() % 4);
    int tagY = (arc4random() % 2) + 10;
    
    UserGoodsTag * tag = [[UserGoodsTag alloc] initWithFrame:CGRectMake(tagX * 50, tagY * 40, 175, 32)];
    tag.title.text = title;
    tag.price.text = price;
    tag.tag = _idx;
    tag.index = _idx - 392;
    tag.delegate = self;
    self.userGoodsTag = tag;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChangeGoodsData:)];
    [tag addGestureRecognizer:tapGesture];
    [self.view addSubview:tag];
    
    [self.tagBtnMarr addObject:tag];
}

#pragma mark 删除标签
- (void)delegateThisTagBtn:(NSInteger)index {
    [self networkDeleteUserGoods:self.goodsIdData[index]];
}

#pragma mark 点击编辑产品信息
- (void)showChangeGoodsData:(UIGestureRecognizer *)tap {
    self.seleIndex = tap.view.tag - 392;
    self.changeGoodsView.goodsTitle.text = [self.userAddGoodsMarr valueForKey:@"title"][self.seleIndex];
    self.changeGoodsView.goodsPrice.text = [NSString stringWithFormat:@"￥%@",[self.userAddGoodsMarr valueForKey:@"price"][self.seleIndex]];
    [self.changeGoodsView.goodsImg downloadImage:[self.userAddGoodsMarr valueForKey:@"img"][self.seleIndex] place:[UIImage imageNamed:@""]];
    [self.view addSubview:self.changeGoodsView];
}

#pragma mark - 标记一个产品图片
- (void)addMarkGoodsImg:(NSString *)imgUrl {
    FBStickersContainer * sticker = [[FBStickersContainer alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    [sticker setupSticker:imgUrl];
    [self.view addSubview:sticker];
}

#pragma mark - 编辑产品信息视图
- (ChangeAddUrlView *)changeGoodsView {
    if (!_changeGoodsView) {
        _changeGoodsView = [[ChangeAddUrlView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_changeGoodsView.sure addTarget:self action:@selector(sureChange) forControlEvents:(UIControlEventTouchUpInside)];
        [_changeGoodsView.dele addTarget:self action:@selector(deleteTag) forControlEvents:(UIControlEventTouchUpInside)];
        [_changeGoodsView.url addTarget:self action:@selector(urlChange) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _changeGoodsView;
}

//  修改标签
- (void)sureChange {
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

//  删除标签
- (void)deleteTag {
    [self delegateThisTagBtn:self.seleIndex];
    [self networkDeleteUserGoods:self.goodsIdData[self.seleIndex]];
    [self.changeGoodsView removeFromSuperview];
    UIButton * btn = [[UIButton alloc] init];
    btn = self.tagBtnMarr[self.seleIndex];
    [btn removeFromSuperview];
}

//  修改产品链接
- (void)urlChange {
    [self delegateThisTagBtn:self.seleIndex];
    [self networkDeleteUserGoods:self.goodsIdData[self.seleIndex]];
    [self.changeGoodsView removeFromSuperview];
    [self buttonDidSeletedWithIndex:1];
    UIButton * btn = [[UIButton alloc] init];
    btn = self.tagBtnMarr[self.seleIndex];
    [btn removeFromSuperview];
}

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
    if (self.goodsIdData.count > 3) {
        [SVProgressHUD showInfoWithStatus:@"只能标记三个商品"];
    } else if (self.goodsIdData.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"至少标记一个商品"];
    } else if (self.goodsIdData.count > 0 && self.goodsIdData.count <= 3) {
         NSLog(@"发布的商品ID：－－－－ %@", self.goodsIdData);
        NSLog(@"发布的商品Title：－－－－ %@", self.goodsTitleData);
        NSLog(@"发布的商品Price：－－－－ %@", self.goodsPriceData);
        //        ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
        //        releaseVC.locationArr = self.locationArr;
        //        releaseVC.scenceView.imageView.image = self.filtersImageView.image;
        //        releaseVC.createType = self.createType;
        //        releaseVC.fSceneId = self.fSceneId;
        //        releaseVC.fSceneTitle = self.fSceneTitle;
        //        releaseVC.goodsTitle = @"测试商品1,测试商品2,测试商品3";
        //        releaseVC.goodsPrice = @"321,1829,2901";
        //        releaseVC.goodsId = @"304,301,299";
        //        releaseVC.goodsX = @"43,32,65";
        //        releaseVC.goodsY = @"20,22,42";
        //        [self.navigationController pushViewController:releaseVC animated:YES];
    }
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

@end
